from threading import Thread
from multiprocessing import JoinableQueue, Event, Lock
import os
from time import sleep, clock, time
from datetime import timedelta, datetime
import random # for testing

if os.name != 'nt':
    clock=time

# Custom Libraries
from utilities.OnePPSSignal import OnePPSSignal
from utilities.DAQConfig import DAQConfig
from utilities.restart_counter import Restart_counter
from utilities.DAQLogger import DAQLogClient
from PostProcessorTree import PostProcessorTree
from Schedule import Schedule, LifetimeLog

from __ver__ import __ver__

__all__ = ['Engine']

# Exception classes from submodules
from DaqCards.DAQExceptions import *
from GpsClocks.GPSExceptions import *
from PostProcessors.PPTExceptions import *

# Flagging and control mechanism
class EngineFlags:

    def __init__(self):
        # Set of flags to denote state of module
        self.is_stopped = Event()
        self.init = Event()
        self.is_running = Event()
        self.error = Event()
        self.resync = Event()

        self.num_restarts = 0
        self.num_errors = 0

        # Init State
        self.is_stopped.set()

    def Reset(self):
        if self.init.is_set():
            self.init.clear()

        if self.is_running.is_set():
            self.is_running.clear()

        if self.is_stopped.is_set():
            self.is_stopped.clear()

        if self.error.is_set():
            self.error.clear()

        if self.resync.is_set():
            self.resync.clear()

        #self.num_restarts = 0
        #self.num_errors = 0

    def __repr__(self):

        rep = "State: "

        if self.is_stopped.is_set():
            rep += "STOP;"
        if self.init.is_set():
            rep += "INIT;"
        if self.is_running.is_set():
            rep += "RUN;"
        if self.error.is_set():
            rep += "ERR;"
        if self.resync.is_set():
            rep += "RRUN;"

        rep += "\tRestarts=%d; Errors=%d" % (self.num_restarts, self.num_errors)

        return rep

# Special Engine error exceptions class
class EngineError(Exception):
    pass

class EngineMaxExceptionError(EngineError):
    pass

class Engine:
    """
    Operation:
    The data acquisition Engine class takes an XML description of a data
    acquisition configuration (DAQ cards, GPS clocks, post processors, and a
    schedule), builds it, and executes it.  The configuration is read and built
    at construction and executed in its own thread using the Engine's Start and
    Stop methods.  An Engine object monitors timestamps from an internal GPS
    clock object, starts a data acquisition according to an internal Schedule
    object using an internal DAQ card object, and each second pushes the data
    received from both the GPS clock and DAQ card objects through an internal
    PostProcessorTree object where it is processed.

    Error Handling:
    There are two types of errors.  Each subprocess created has methods to
    accessing the data or message queues. Errors accessing these queues can be
    caught by the engine by exception catching.  But, the errors internal to
    the process cannot be caught by the engine. Thus, we pass along event()
    flags to each process, and the engine monitors these flags. Errors
    internal to subprocesses should set the flag, the engine then should
    handle the error gracefully.


    """

    # ========================
    # Constructors/Destructors
    # ========================
    def __init__(self, settings, log_queue):
        """
        Constructs a data acquisition solution according to an XML description
        of the data acquisition configuration.  This involves building an
        internal DAQ card object, an internal GPS clock object, an internal
        PostProcessorTree object, and an internal Schedule object.  The details
        of each object are described in the XML file passed to this constructor.
        """

        #Set up engine logging (see logging.conf)
        #self.logger = logging.getLogger('Engine')
        self.logger = DAQLogClient(log_queue, "ENG")
        self.GPS_logger = DAQLogClient(log_queue, "ENG.GPS")
        self.DAQ_logger = DAQLogClient(log_queue, "ENG.DAQ")
        self.PPT_logger = DAQLogClient(log_queue, "ENG.PPT")
        self.SCH_logger = DAQLogClient(log_queue, "ENG.SCH")
        self.WCH_logger = DAQLogClient(log_queue, "ENG.WD")

        self.logger.status('********** Initializing Engine **********')
        self.log_queue = log_queue

        # Initialize thread stuff
        #self.running = False
        self.wd_running = False
##        self.isReady = Event()
        self.thread = None
        self.wd_thread = None

        # Flags to indicate progress between processes
        #self.DAQ_flags = EngineStates()
        #self.GPS_flags = EngineStates()
        #self.PPT_flags = EngineStates()
        #self.SCH_flags = EngineStates()
        self.DAQ_flags = EngineFlags()
        self.GPS_flags = EngineFlags()
        self.PPT_flags = EngineFlags()
        self.SCH_flags = EngineFlags()

        self.flags = EngineFlags() #init to STATE_STOP

        # Restart counters
        self.restarts = 0
        self.restart_counter = Restart_counter()
        self.lastError = 0  #last error DAQ threw

        self.lastStartTime = None
        #self.lastDAQTime = None

        self.exceptions = 0
        #self.MAX_EXCEPT = 500
        self.MAX_EXCEPT = None

        self.latest_timestamp = None

        # DAQ request timeout - default 30s
        self.eng_timeout = 30

        # Timeing variables
        self.cum_lag = 0 #cumulative total of seconds behind realtime
        self.abs_lag = 0 #keep track of lag behind real-time:
        self.adj_lag = 0 #####Unused
        self.MAX_CUM_LAG= 10

        # This is a DAQConfig object, defined in read_config, parsed and setup in main
        self.settings = settings
        #self.gpsSettings = self.settings.GetSubTree("GpsClock")
        #self.daqSettings = self.settings.GetSubTree("DaqCard")

        ########################################################################
        # Nick - Hack to try and fix tdiff issue. Sometimes tdiff is ~ -0.3 sec
        # and an error occurs. This hack will let tdiff fall out of range once,
        # then if it consecutively happens again, the tdiff error will then be
        # thrown.
        self.tdiff_error_twice = False
        ########################################################################



        # Generate modules from setting file
        #self.GenerateModules(settings)
        try:
            self.GenerateModules()
        except DAQError:
            # Catches any sort of DAQError type of exception
            self.logger.exception("Error generating DAQ module.")
            raise
        except ClockError:
            self.logger.exception("Error generating GPS module.")
        except PPTError:
            self.logger.exception("Error generating PPT module.")
        except:
            self.logger.exception("Unknown error generating modules in Engine.")
            raise EngineError("Unknown error generating modules in Engine.")


        self.parent = None
        #self.llog = LifetimeLog('log\\lifetime.log')

        # Software version number
        self.__ver__ = __ver__

        #self.station_name = read_config.GetStrElemVal(settings, "station_name",'X')
        #self.station_id = read_config.GetStrElemVal(settings, "station_id",'XX')
        self.station_name = self.settings.GetStrElemVal("station_name",'X')
        self.station_id = self.settings.GetStrElemVal("station_id",'XX')
        self.lastLat = 0.0
        self.lastLon = 0.0

        self.flags.is_stopped.clear()
        self.flags.init.set()

        self.logger.info("Engine Initialization complete.")

    def SetParent(self,parent):
        self.parent = parent

    def GenerateModules(self):

        self.restart_counter.update('%d' % self.restarts)

        self.logger.info('Generating modules ...')

        # DAQ
        try:
            self.GenerateDAQ()
            self.logger.info('DAQ Module Started...')

            # wait max of 120 seconds for DAQ initialization, handle error if not ready
            if not self.DAQ_flags.init.wait(120.0):
                raise EngineError("DAQ process init timeout.")

        except:
            #self.logger.exception("Failed GenerateDAQ().")
            self.logger.error("Failed GenerateDAQ().")
            raise

        self.logger.info('DAQ Finished Init.')

        # GPS
        try:
            self.GenerateGPS()
            self.logger.info('GPS Module Started...')

            # wait max of 120 seconds for GPS initialization, handle error if not ready
            if not self.GPS_flags.init.wait(120.0):
                raise EngineError("GPS process init timeout")

        except:
            #self.logger.exception("Failed to GenerateGPS().")
            self.logger.error("Failed to GenerateGPS().")
            raise

        self.logger.info('GPS Finished Init.')

        # Post Processor Tree
        try:
            self.GeneratePPT()
            self.logger.info('Postprocessor tree Generated')
        except:
            #self.logger.exception("Failed GeneratePPT().")
            self.logger.error("Failed GeneratePPT().")
            raise

        # Scheduler
        try:
            self.GenerateScheduler()
            self.logger.info('Scheduler Generated')
        except:
            self.logger.exception("Failed GenerateScheduler().")
            raise EngineError("Failed to generate scheduler.")

        # Verify that the number of DAQ channels equals the number of top-level
        # elements in the Post Processor Tree
        if self.daq.GetNumChannels() != self.ppt.GetNumSequences():
            numCh_numSeq = (self.daq.GetNumChannels(),self.ppt.GetNumSequences())
            self.logger.error('Inconsistent: # DAQ Channels: %d; # postprocessor nodes: %d' % numCh_numSeq)

        self.restarting = False

        self.sampleRate = self.daq.GetSampleRate()

        self.logger.info('Modules generated')

    def GenerateGPS(self):
        #gpsSettings = self.gpsSettings
        gpsSettings = DAQConfig(self.settings.GetFirstSubTree("GpsClock"))
        gpsModule = self.settings.GetSubTreeStrElem("GpsClock","module")
        self.logger.info('GPS: %s' % gpsModule)

        # Generate the GPS clock object
        if (gpsModule == 'VirtualClock') and ('onePPS' not in locals()):
            onePPS = OnePPSSignal()
        gpsClocks = __import__("GpsClocks", globals(), locals(), [gpsModule], -1)
        if (gpsModule == 'VirtualClock'):
            gpsConstructor = "gpsClocks." + gpsModule + "." + gpsModule + "(gpsSettings, onePPS, self)"
        else:
            gpsConstructor = "gpsClocks." + gpsModule + "." + gpsModule + "(gpsSettings, self)"

        self.gpsModule = gpsModule
        self.gps = eval(gpsConstructor)

    def GenerateDAQ(self):

        # Get from settings
        #daqSettings = self.daqSettings
        daqSettings = DAQConfig(self.settings.GetFirstSubTree("DaqCard"))
        daqModule = self.settings.GetSubTreeStrElem("DaqCard","module")
        self.logger.info('DAQ: %s' % daqModule)

        gpsModule = self.settings.GetSubTreeStrElem("GpsClock","module")

        # Generate the DAQ card object
        if (daqModule == 'VirtualCard') and ('onePPS' not in locals()):
            onePPS = OnePPSSignal()

        daqCards = __import__("DaqCards", globals(), locals(), [daqModule], -1)

        if (daqModule == 'VirtualCard'):
            self.logger.debug("Contructing DAQ instance with VirtualDaq.")
            isReady = Event()
            daqConstructor = "daqCards." + daqModule + "." + daqModule + "(daqSettings, isReady, onePPS, self)" #This is soooo hacked

        else:

            if str(gpsModule) == 'VirtualClock':
                self.logger.debug("Contructing DAQ instance with VirtualClock.")
                daqConstructor = "daqCards." + daqModule + "." + daqModule + "(daqSettings, self, False)"
            else:
                self.logger.debug("Contructing DAQ instance with %s" % gpsModule)
                daqConstructor = "daqCards." + daqModule + "." + daqModule + "(daqSettings, self, True)"


        self.daqModule = daqModule
        self.daq = eval(daqConstructor)

    def GeneratePPT(self):
        # Generate the post processor tree
        stationSettings = self.settings.GetFirstSubTree("StationSettings")
        pptSettings = self.settings.GetFirstSubTree("PostProcessorTree")
        self.ppt = PostProcessorTree(pptSettings,stationSettings,self)

    def GenerateScheduler(self):
        # Generate the master schedule
        scheduleSettings = self.settings.GetFirstSubTree("Schedule")
        self.schedule = Schedule(scheduleSettings, self)

    # =======
    # Methods
    # =======
    def Start(self):
        """
        Begins execution of the data acquisition in a thread.
        """

        self.flags.init.clear()

        self.logger.status("Starting the VLF DAQ Engine.")
        # Launch the thread
        self.thread = Thread(target=self.MainLoop)
        self.thread.start()

        self.wd_thread = Thread(target=self.WatchDog)
        self.wd_thread.start()

        if not self.flags.is_running.wait(180):
            self.logger.error("Engine not starting up after 180 seconds.")

    def Stop(self):
        """
        Terminates execution of the data acquisition.
        """

        self.logger.status("Stopping the VLF DAQ Engine.")

        self.logger.debug("Sending STOP to engine main loop")
        self.flags.is_running.clear()
        #self.running = False

        # Shutdown the Engine properly
        if self.thread is not None:
            self.logger.info("Stopping Engine thread.")
            # Kill the thread
            self.thread.join()
            self.logger.status("Engine thread terminated.")
            self.thread = None

        # Issue Stop commands

        # The DAQ needs to be stopped first.
        # This is because daq.start is called from syncGPS
        self.logger.debug("Terminating DAQ")
        try:
            self.daq.Quit()
        except:
            self.logger.error('Error stopping DAQ')
            return False
            #raise
        self.logger.status("DAQ terminated.")

        # Stop the GPS clock
        self.logger.debug("Stopping GPS")
        self.gps.Stop()
        self.logger.status("GPS terminated.")

        # Check if DAQ actually stopped
        if not self.DAQ_flags.is_stopped.wait(60.0):
            self.logger.error('DAQ could not stop properly.')
            #raise EngineError('DAQ could not stop properly during restart.')
            return False

        self.daq = None
        self.logger.status('DAQ process stopped')

        # Check if GPS actually stopped
        if not self.GPS_flags.is_stopped.wait(60.0):
            self.logger.error('GPS could not stop properly.')
            #raise EngineError('GPS could not stop properly during restart.')
            return False

        self.gps = None
        self.logger.status('GPS process stopped')

        self.logger.info("Shutting down PostProcessor")
        self.ppt.Stop()
        self.ppt = None
        self.logger.status('PPT process stopped')

        self.logger.info("Shutting down Scheduler")
        self.schedule = None
        self.logger.status('SCH process stopped')

        self.flags.is_stopped.set()

        return True

    def Quit(self):
        #if self.running:
        if self.flags.is_running.is_set():
            self.Stop()

            self.logger.info("Terminating Watchdog thread.")
            self.wd_running = False
            self.wd_thread.join()
            self.logger.status("Watchdog thread terminated.")

    def GetSettingsFile(self):
        return self.settings_file

    def GetStatus(self):
        status =  "--- DAQ Engine status for %s (%s)---\n" % (self.station_name, self.station_id)
        status += "DAQ version: %s  \n" % self.__ver__
        status += "Number of Engine restarts: %d  \n" % self.flags.num_restarts
        status += "Number of DAQ restarts: %d  \n" % self.DAQ_flags.num_restarts
        status += "Number of GPS restarts: %d  \n" % self.GPS_flags.num_restarts
#        status += "Last error: %d  \n" % self.lastError
        #status += "DAQ PID: %d  \n" % self.daq.GetPID()
        if self.gps is not None:
            status += "GPS Queue size: %d  \n" % self.gps.GetQueueSize()
        if self.daq is not None:
            status += "DAQ Queue size: %d  \n" % self.daq.GetQueueSize()
        if self.lastStartTime is not None:
            status += "Last start: %s  \n" % self.lastStartTime.strftime("%Y-%m-%d %H:%M:%S")
        status += self.GetLocation()
        return status

    def GetLocation(self):
        location =  "GPS lat,lon: (%2.5f, %2.5f)  \n" % (self.lastLat, self.lastLon)
        return location

    def SignalEngineResync(self):
        #self.restarting = True
        #self.running = False
        RestartThread = Thread(target=self.EngineResync)
        RestartThread.daemon=True
        RestartThread.start()

    def EngineResync(self):
        pass

    #You have to create a new thread for the restart because you can't
    #.join() a currently running thread (deadlock)
    def SignalEngineRestart(self):
        self.restarting = True
        self.flags.is_running.clear()

        if self.flags.error.is_set():
            self.flags.error.clear()

        if not self.flags.resync.is_set():

            RestartThread = Thread(target=self.EngineRestart)
            RestartThread.daemon=True
            RestartThread.start()

    def EngineRestart(self):
        """
        Stops of the data acquisition, and re-creates/restarts modules in case of an error.
        I'm not sure about memory leaks, but restarting several times will probably lead to them;
        a hard restart (stopping the program and restarting using "python main.py --args"
        is probably a good thing to do after N soft restarts
        """

        self.flags.resync.set()

        # Logging the restart - raise awareness if needed
        #self.restarts += 1
        self.flags.num_restarts += 1

        self.logger.warning("Restart thread activated; ENG restarts=%d. DAQ restarts=%d. GPS restarts=%d " % (self.flags.num_restarts, self.DAQ_flags.num_restarts, self.GPS_flags.num_restarts))

        if self.restarts % 5 == 0:
            self.logger.critical('Notice: # DAQ restarts: %d\n\n%s' % (self.restarts,self.GetStatus()))

        # Stop the thread
        if not self.Stop():
            self.logger.error('Error stopping Engine while restarting')
            self.SignalStop()
            #return

        # wait for engine to stop running
        #if not self.flags.is_stopped.wait(60):
        #    self.logger.error("Could not stop Engine for Engine Restart after 60 seconds.")
        #    self.SignalStop()
            ####
            ####

        hardRestart = False

        #Important Note: This doesn't actually work right now, it just stops everything in engine.py
        #I couldn't find a way to stop the main (CLI) thread from this one, so this is still WIP
        if hardRestart:
            #in case of certain classes of errors, quit the current python instance and launch another
            #from the shell
            self.logger.critical("HARD RESTART")
            #subprocess.Popen("python main.py")
            if self.parent:
                self.parent.onecmd("quit")
                return

        self.logger.info('Waiting 60 seconds before restart.')
        sleep(30.0 + random.random())
        self.logger.info("30 Seconds to go.")
        sleep(30.0 + random.random())


        self.exceptions = 0
        self.DAQ_flags.Reset()
        self.GPS_flags.Reset()
        self.PPT_flags.Reset()
        self.SCH_flags.Reset()

        #settings = self.settings
        #self.GenerateModules(settings)
        self.logger.status("Regenerating modules.")

        try:
            self.GenerateModules()
        except EngineError as err:
            self.logger.exception("Error generating modules in Engine while restarting.")
            #raise
            return
        except:
            self.logger.exception("Unknown error generating modules in Engine while restarting.")
            #raise
            return

        self.logger.status("Restarting the VLF DAQ Engine.")

        # Launch the thread
        self.thread = Thread(target=self.MainLoop)
        self.thread.start()

        if not self.flags.is_running.wait(60):
            self.logger.error("Could not start Engine upon restart.")
            return

        self.restarting = False
        self.flags.resync.clear()

    def SignalStop(self):
        self.logger.warning('Signalling soft stop proceedures.')
        RestartThread = Thread(target=self.SoftStop)
        #RestartThread.daemon=True
        RestartThread.start()

    def SoftStop(self):
        # Stop the thread
        if not self.Stop():
            self.logger.error("VLF DAQ Engine did not stop properly.")

        self.logger.info("Terminating Watchdog thread.")
        self.wd_running = False
        self.wd_thread.join()
        self.logger.status("Watchdog thread terminated.")

        self.logger.critical("VLF DAQ Engine Stopped due to unrecoverable error.")
        self.logger.critical('Notice: # DAQ restarts: %d\n\n%s' % (self.restarts,self.GetStatus()))
        self.logger.info('Type "quit" to close program.')


    # ==============
    # Helper Methods
    # ==============

    def VerifyGPSLock(self):
        """
        Internally handles None GPS output
        """

        self.logger.info("Waiting for GPS lock...")
        self.gps.SetQuality(0)
        wait_count = 0
        prev_quality = -1
        WAIT_TIME = 30

        #if self.running:
        if self.flags.is_running.is_set():

            while True:

                if not self.flags.is_running.is_set():
                    return None

                try:
                    gpsData= self.gps.Get()

                    if gpsData[0] is None:  #poll gps; if timing error, restart
                        self.gps.SetQuality(0)
                        wait_count = 0
                        continue

                    if not self.flags.is_running.is_set():
                        return None

                    quality = self.gps.GetQuality()

                    #resent counter if quality is improving
                    if quality > prev_quality:
                        wait_count = 0
                        prev_quality = quality

                    have_lock = self.gps.HaveLock()

                    if have_lock or not self.flags.is_running.is_set():
                        break
                    if wait_count >= WAIT_TIME and not os.path.isfile('WAIT_FOR_LOCK'):
                        break
                    if self.gps.IsVirtualClock():
                        break

                    wait_count += 1

                    # Debug messages
                    if wait_count % 5 == 4:
                        self.logger.info('Waiting for GPS lock (Quality: %d)' % quality)
                except:
                    self.logger.error("Exception getting GPS data.")
                    raise


            if have_lock:
                self.logger.info("GPS lock acquired. Quality: %d" % quality)
            else:
                self.logger.warning("Continuing without GPS Lock. Quality: %d" % quality)

            self.latest_timestamp = gpsData[1][0]
            return have_lock

        return None

    def _consumeGPS(self,gpsData):
        if gpsData is None:
            raise GPSError('GPS encountered timing issue')
        self.latest_timestamp = gpsData[0]

    def FlushGPSData(self):
        #self.logger.debug("Flushing GPS queue")
        #self.gps.Flush()
        #self.logger.debug("Fin flushing GPS queue")
        pass


    def GetGPSData(self, fast=False):

        self.logger.debug('GetGPSData()')

        if self.flags.is_running.is_set():

            if fast:
                #daq_queue_size = self.daq.GetQueueSize()

                try:
                    #gpsData = self.gps.GetFast(daq_queue_size)  #put in processing load
                    #gpsData = datetime.utcnow(), self.gps.GetFast()  #put in processing load
                    gpsData = self.gps.GetFast()  #put in processing load
                except:
                    self.logger.error("Exception getting DAQ data.")
                    raise

                if gpsData[0] is not None:
                    #Do some timing checks
                    self.CheckTiming(gpsData[1])

            else:
                self.logger.debug("Getting GPS data for the first time.")

                try:
                    #gpsData = datetime.utcnow(), self.gps.Get()
                    gpsData = self.gps.Get()
                except ClockError:
                    self.logger.error("Exception getting GPS data.")
                    raise
                except ClockNoDataError:
                    self.logger.error("Exception getting GPS data.")
                    raise
                except ClockSkipError:
                    self.logger.error("GPS skipping")
                    raise
                except:
                    self.logger.error("Unknown exception getting GPS data for the first time.")
                    raise

                # Since this is the first time, grab the timestamp, store the start time
                self.gps.SetInternalTime(gpsData[1])
                self.abs_lag = 0
                self.cum_lag = 0

                self.logger.debug("Internal time set: %s" % self.gps.internal_dt)
                #self.first_loop = False

            #self._consumeGPS(gpsData)

            if gpsData[0] is None:
                raise ClockNoDataError('GPS returned None. Encountered timing issue?')

            self.latest_timestamp = gpsData[1][0]

            return gpsData

        return None



    def GetDAQData(self):

        self.logger.debug('SyncDAQData()')

        if self.flags.is_running.is_set():

            timeout = self.eng_timeout

            try:
                #daq = datetime.utcnow(), self.daq.Get(self.eng_timeout)
                daq = self.daq.Get(self.eng_timeout)
            except DAQNoDataError:
                self.logger.error("Exception getting DAQ data.")
                raise
            except:
                self.logger.error("Unknown exception getting DAQ data.")
                raise

            if daq[0] is None:

                if self.DAQ_flags.error.is_set():
                    raise DAQInternalError('DAQ error caught by engine.')
                else:
                    raise DAQNoDataError('DAQ returned None')

            return daq

        return None


# Alex
    def SyncDAQwithGPS(self):
        """
        DAQ started here

        In testing,
        sync1 ~=0.999s
        sync2 ~=0.509s - 0.516s
        sync2 ~=1.010s

        then if no lock, next DAQ is 0.990s
        if lock, should be less than 0.3s for next GPS msg

        """
        self.logger.debug('SyncDAQwithGPS()')

        if self.flags.is_running.is_set():

            have_lock = self.gps.HaveLock()

            self.gps.Flush()
            self.daq.Flush()

            sleep(random.random())

            t,d = self.GetGPSData()
            self.logger.info('Clear and sync to GPS @ %s' % t)

            # Start DAQ process - catch any exceptions
            tt = clock()
            try:
                self.daq.Start()
            except Exception:
                raise

            time_to_start_daq = clock()-tt
            self.logger.info('Time to start DAQ: %2.3fs; ' % time_to_start_daq)

            #make sure took ~1 second to get GPS
            #self.gps.Flush()
            #self.daq.Flush()

            time_to_get_gps = 0

            while time_to_get_gps < .9 or time_to_get_gps > 1.1:
                # Use GetGPSData to sync to serial timestamps
                ttgps = clock()

                t,d = self.GetGPSData()
                self.logger.info('1st GPS @ %s' % t)

                time_to_get_gps = clock()-ttgps
                self.logger.info('Sync1: Took %2.3fs to get GPS data ' % time_to_get_gps)

            ttgps = clock()
            num_daq = 0 # counts how many daq samples we got back

            #make sure next DAQ in ~1 second
            time_to_get_data = 0
            while time_to_get_data < .9:
                # This loop uses GetDAQData to make sure 1 data series is returned every 1 second
                ttdaq = clock()

                t,d = self.GetDAQData()
                self.logger.info('DAQ @ %s' % t)

                time_to_get_data = clock()-ttdaq
                self.logger.info('Sync2 Took %2.3fs to get DAQ data ' % time_to_get_data)

                if time_to_get_data > 1.1:
                    raise EngineError("DAQ timing out of range, restarting engine.")

                num_daq += 1

            #We think we have a synced setup now
            tt = clock()

            # Remove all the GPS strings queued up while doing DAQ sync
            number_gps_to_pop = int(round(tt-ttgps-1.0))

            if number_gps_to_pop < num_daq-1:
                #num_daq usually = 2, but sometimes, for some reason, tt-ttgps yields 0
                number_gps_to_pop = num_daq-1

            self.logger.info('Popping %d from gps to sync' % number_gps_to_pop)
            for tmpi in xrange(number_gps_to_pop):
                t,d = self.GetGPSData()
                self.logger.info('Popping GPS @ %s' % t)

            #First check next GPS comes in at right time, next one doesn't come too soon
            t,d = self.GetGPSData()
            self.logger.info('3rd GPS @ %s' % t)

            self.lastStartTime = self.latest_timestamp
            time_to_get_gps2 = clock()-tt

            if have_lock:
                if self.daq.sampleRate > 100000:
                    #Max seen is ~0.56 with new SSR GPS cards
                    tdiff = 0.58
                    if time_to_get_gps2 > tdiff:
                        raise ClockError("'Took too long to get GPS timestamp in queue (%2.3fs)" % time_to_get_gps2)

                else:
                    tdiff = 0.3

                    if time_to_get_gps2 > tdiff:
                        raise ClockError("'Took too long to get GPS timestamp in queue (%2.3fs)" % time_to_get_gps2)

                    sleep((1-tdiff)-time_to_get_gps2)
                    if self.gps.GetQueueSize() > 0:
                        raise ClockError("Extra GPS timestamp in queue")
            else:
                sleep(.1)
                self.gps.Flush()

            #next check if DAQ comes in at right time
            t,d = self.GetDAQData()
            self.logger.info('Next DAQ @ %s' % t)

            time_to_get_data = clock()-tt
            self.logger.info('Daq data %2.3fs after last query' % time_to_get_data)

            if time_to_get_data < .9:
                raise DAQError("DAQ available too soon")

            self.logger.status('Starting at %s UT.' % self.latest_timestamp.strftime("%Y-%m-%d %H:%M:%S"))
            self.logger.info('DAQ/GPS sync complete.')

        return None

    def CheckTiming(self, gpsData):

        self.logger.debug('Start CheckTiming()')

        if self.flags.is_running.is_set():
            if self.gps.HaveLock():
                if gpsData is not None:
                    #difference in time:
                    timediff = self.gps.timediff

                    ZERO = timedelta(seconds=0)

                    if timediff < ZERO:

                        #Engine lagging behind real-time; slow processing or error
                        absolute_lag = (-timediff).seconds  #seconds behind real-time

                        #throw up a warning if things are slowing down:
                        if (absolute_lag > self.abs_lag) and (absolute_lag > 1):
                            #self.logger.warning('Engine %ds behind GPS' % absolute_lag)
                            raise EngineError('Engine %ds behind GPS' % absolute_lag)

                        #subtract off length of data buffer to allow for slow processing
                        adjusted_lag = absolute_lag - self.daq.GetQueueSize()

                        if adjusted_lag > 0:
                            self.cum_lag += adjusted_lag
                            #if (adjusted_lag > 1):
                            if self.cum_lag > 1:
                                self.logger.warning('Adjusted lag %ds behind GPS (cumulative lag: %d)' % (adjusted_lag, self.cum_lag))

                        #reset cumulative adjusted lag if adjusted lag dips back to 0:
                        if adjusted_lag == 0:
                            self.cum_lag = 0

                        #reset data acquisition if cumulative adjust lag grows too large (consistent offset)
                        if self.cum_lag > self.MAX_CUM_LAG:
                            #self.logger.error('Cumulative lag > %d. Restarting' % self.MAX_CUM_LAG)
                            raise EngineError("Engine behind. Cumulative lag > %ds. Restarting" % self.MAX_CUM_LAG)

                        #for next iteration:
                        self.abs_lag = absolute_lag

                    elif timediff > ZERO:
                        #Engine ahead real-time (shouldn't happen, ever)
                        #self.logger.error('Engine %d s ahead. Restarting' % timediff.seconds)
                        raise EngineError("Engine ahead. Engine %ds ahead. Restarting" % timediff.seconds)

                    else:
                        #correct
                        return

        return None

    def CheckDebugFiles(self):
        if not os.path.isfile('DEBUG_mask'):
            return

        if os.path.isfile('DEBUG.raiseerror'):
            print 'Detected DEBUG.raiseerror file--self destruct sequence initiated ...'
            sleep(3)
            os.remove('DEBUG.raiseerror')
            raise TypeError("Introducing a random error! Grab your towel, and don't panic!")

        if os.path.isfile('DEBUG.daqdata'):
            os.remove('DEBUG.daqdata')
            sleep(.25)
            raise DAQError('Debug DAQ error')

        if os.path.isfile('DEBUG.gpsdata'):
            os.remove('DEBUG.gpsdata')
            print 'setting gpsData to None'
            sleep(0.25)
            raise GPSError('Debug GPS error')

        if os.path.isfile('DEBUG.delay'):
            os.remove('DEBUG.delay')
            print 'Sleeping for 5 seconds'
            sleep(5.0)

    def RestartDAQAnalog(self):
        return self.daq.RestartAnalog()

    def RestartDAQ(self):
        return self.daq.Restart()

    def RestartLR(self):
        return self.daq.RestartLineReceiver()

    def RestartGPS(self):
        return self.gps.Restart()

    def MainLoop(self):

        # Start the GPS clock
        self.logger.debug("Starting GPS Thread")
        try:
            self.gps.Start()
        except:
            self.logger.exception('Exception while Starting GPS.')

            if self.restarts < self.MAX_EXCEPT:
                self.SignalEngineRestart()
            else:
                self.logger.error("Reached max restarts: %d" % self.restarts)
                self.SignalStop()
            return False

        # wait max of 30 seconds for GPS to run, handle error if not ready
        if not self.GPS_flags.is_running.wait(30.0):
            self.logger.error('No Response from GPS. Is GPS connected?')
            if self.restarts < self.MAX_EXCEPT:
                self.SignalEngineRestart()
            else:
                self.logger.error("Reached max restarts: %d" % self.restarts)
                self.SignalStop()
            return False
            #raise EngineError("GPS did not start properly.")
            #return False

        self.logger.info("GPS thread started.")

        #self.running = True
        self.flags.is_running.set()

        test_run = 0

        while self.flags.is_running.is_set():

            #self.logger.info("Main loop Started.")

            try:

                # Check Engine error flag
                if self.DAQ_flags.error.is_set():
                    raise DAQInternalError('DAQ error caught by engine.')

                # Check GPS/Serial/Clock error flag
                if self.GPS_flags.error.is_set():
                    raise ClockInternalError('GPS/Serial/Clock error caught by engine.')

                # Verify GPS locking
                self.logger.debug("Verifying GPS Lock.")
                have_lock = self.VerifyGPSLock()
                self.logger.info("Verified GPS Lock.")

                if not self.flags.is_running.is_set():
                    self.logger.debug("Main loop terminated after GPS lock check.")
                    self.flags.is_stopped.set()
                    break

                # Wait until scheduled time to start acquisition
                while self.schedule.SecondsLeftInAcquisition(self.latest_timestamp) == 0:
                    self.GetGPSData()
                    if not self.flags.is_running.is_set():
                        #raise EngineError('self.running set to False')
                        self.flags.is_stopped.set()
                        break

                if not self.flags.is_running.is_set():
                    self.logger.debug("Main loop terminated after GetGPSData.")
                    self.flags.is_stopped.set()
                    break

                #Start DAQ and sync GPS
                self.logger.debug("Syncing GPS")
                self.SyncDAQwithGPS()
                self.logger.status("GPS/DAQ Sync Complete. Starting Main Engine Loop.")

                if not self.flags.is_running.is_set():
                    self.logger.debug("Main loop terminated after syncDAQwithGPS.")
                    self.flags.is_stopped.set()
                    break

                first_loop = True

                while self.schedule.SecondsLeftInAcquisition(self.latest_timestamp) > 0:
                    # It's go time!

                    # Error checking
                    if not self.flags.is_running.is_set():
                        self.logger.debug("Main loop terminated after schedule match.")
                        self.flags.is_stopped.set()
                        break


                    # If GPS queue size=60 (daq hung up)
                    if self.gps.GetQueueSize() == 60:
                        raise ClockQueueFull("Clock queue full. Restarting.")

                    # Check Engine error flag
                    if self.DAQ_flags.error.is_set():
                        raise DAQInternalError('DAQ error caught by engine.')

                    # Check GPS/Serial/Clock error flag
                    if self.GPS_flags.error.is_set():
                        raise ClockInternalError('GPS/Serial/Clock error caught by engine.')

                    # Check number of exceptions to limit infinite restarts - Raise appropriate exception
                    if self.MAX_EXCEPT is not None:
                        if self.flags.num_restarts > self.MAX_EXCEPT:
                            raise EngineMaxExceptionError("Too many Engine exceptions: %s" % self.exceptions)
                        elif self.DAQ_flags.num_restarts > self.MAX_EXCEPT:
                            raise EngineMaxExceptionError("Too many DAQ exceptions: %s" % self.DAQ_flags.num_restarts)
                        elif self.GPS_flags.num_restarts > self.MAX_EXCEPT:
                            raise EngineMaxExceptionError("Too many GPS exceptions: %s" % self.GPS_flags.num_restarts)
                        """
                        elif self.PPT_flags.num_restarts > self.MAX_EXCEPT:
                            raise EngineMaxExceptionError("Too many PPT exceptions: %s" % self.PPT_flags.num_restarts)
                        elif self.SCH_flags.num_restarts > self.MAX_EXCEPT:
                            raise EngineMaxExceptionError("Too many SCH exceptions: %s" % self.SCH_flags.num_restarts)
                        """

                    # Get GPS data
                    if first_loop:
                        self.logger.debug("Getting GPS Data first")
                        gpsData = self.GetGPSData()
                        self.gps.SetInternalTime(gpsData[1])
                        self.logger.debug("Fin GPS Data first")
                        first_loop = False
                    else:
                        self.logger.debug("Getting GPS Data faster")
                        gpsData = self.GetGPSData(True)
                        self.logger.debug("Fin GPS Data faster")

                    #self.logger.info("stgps=%s" % gpsData[0])

                    if not self.flags.is_running.is_set():
                        self.logger.debug("Main loop terminating after GetGPSData().")
                        self.flags.is_stopped.set()
                        break

                    self.logger.debug("Getting DAQ Data.")
                    # Pull this second's data from the DAQ card--usually waiting .8 seconds
                    daqData = self.GetDAQData()
                    self.logger.debug("Got DAQ Data.")

                    if not self.flags.is_running.is_set():
                        self.logger.debug("Main loop terminating after GetDAQData().")
                        self.flags.is_stopped.set()
                        break

                    # Check Engine error flag
                    if self.DAQ_flags.error.is_set():
                        raise DAQInternalError('DAQ error caught by engine.')

                    # Check GPS/Serial/Clock error flag
                    if self.GPS_flags.error.is_set():
                        raise ClockInternalError('GPS/Serial/Clock error caught by engine.')

                    # Process data
                    tdaq = daqData[0]
                    tgps = gpsData[0]

                    #self.logger.debug("tdaq=%s; tgps=%s" % (tdaq, tgps))


                    # Alex
                    if tgps is not None and tdaq is not None:

                        # Check time diff between GPS data and DAQ data, should be avg 0.5s for LF, min 0.19s in some random instances
                        # I5, 8GB, Moto GPS on serial port with PCI DAQ 2ch: diff ~= 0.51s
                        # I5, 8GB, Moto GPS with onboard usb serial, USB DAQ 3ch: 0.37 < diff < 0.52
                        # C2Duo 3GHz, 8GB, Moto GPS on USB, USB DAQ 3ch:   ~.16 < diff < .2

                        tdiff = tdaq - tgps
                        #self.logger.debug("tdaq=%s; tgps=%s" % (tdaq, tgps))
                        #self.logger.debug("tdiff: %s" % tdiff)
                        #self.logger.info("tdaq=%s; tgps=%s; tdiff=%s" % (tdaq, tgps, tdiff))
                        self.logger.debug("tdaq=%s; tgps=%s; tdiff=%s" % (tdaq, tgps, tdiff))
                        #self.logger.debug("tdiff=%s" % (tdiff))
                        td = (tdiff.microseconds+tdiff.seconds*10**6)

                        if self.sampleRate > 100000:

                            if False: #td<300000 or td>1020000:
                                if self.tdiff_error_twice: #Nick - see Engine.__init__ for details
                                    self.logger.warning("tdaq=%s; tgps=%s; tdiff=%s" % (tdaq, tgps, tdiff))
                                else:
                                    self.tdiff_error_twice = True

                            if(td < 1e6 and td > 1):
                                self.tdiff_error_twice = False
                                self.CheckDebugFiles()

                                self.lastLat = gpsData[1][1][0]
                                self.lastLon = gpsData[1][1][1]

                                # Process the DAQ and GPS data
                                start_time = datetime.utcnow()
                                self.logger.debug("Start PPT=%s" % start_time)
                                self.ppt.Process([daqData[1], gpsData[1], self.sampleRate])
                                end_time = datetime.utcnow()
                                self.logger.debug("End PPT=%s, delta_t=%s" % (end_time, end_time - start_time))
                                #self.llog.log(self.latest_timestamp)
                                # Set tighter timing constraints for LF

                            else:
                                raise EngineError("DAQ and GPS data not sync'd properly. Tdiff: %s" % tdiff)
                        else:

                            # Set timing constraints for VLF - avg around 0.520s
                            # Core i7 is at 0.875
                            if td<300000 or td>900000:
                                self.logger.warning("tdaq=%s; tgps=%s; tdiff=%s" % (tdaq, tgps, tdiff))

                            if  (td<900000 and td>400000):

                                self.CheckDebugFiles()

                                self.lastLat = gpsData[1][1][0]
                                self.lastLon = gpsData[1][1][1]

                                # Process the DAQ and GPS data
                                self.ppt.Process([daqData[1], gpsData[1], self.sampleRate])

                                #self.llog.log(self.latest_timestamp)

                            else:
                                raise EngineError("DAQ and GPS data not sync'd properly. Tdiff: %s" % tdiff)

                    else:
                        raise EngineError("GPS or DAQ returned None.")

                    #########################
                    ###### FOR TESTING ######
                    #########################
                    """
                    # Uncomment these line for testing
                    test_run += 1

                    if test_run == 20:
                        err_num = random.randint(1, 7)
                        #err_num = 7
                        self.logger.debug('fake error=%d' % err_num)

                        test_run = 0
                        if err_num == 1:
                            raise DAQError("Simulating: DAQError")
                        elif err_num == 2:
                            raise DAQNoDataError("Simulating: DAQNoDataError")
                        elif err_num == 3:
                            raise ClockError("Simulating: ClockError")
                        elif err_num == 4:
                            raise ClockSkipError("Simulating: ClockSkipError")
                        elif err_num == 5:
                            raise ClockNoDataError("Simulatingg: ClockNoData")
                        elif err_num == 6:
                            raise ClockQueueFull("Simulating: ClockQueueFull")
                        elif err_num == 7:
                            raise EngineError("Simulating: EngineError")
                    """



                # Acquisition stopped
                #self.llog.logend(self.latest_timestamp)
                self.logger.info('Engine loop finished at.')

            # DAQ Exceptions

            except DAQNoDataError:
                # Usually, this is the DAQ skipping a beat
                # Restart DAQ analog task without touching board power or GPS
                self.logger.exception("Exception getting data from DAQ (timeout). Restarting DAQ analog task.")
                #self.llog.logend(self.latest_timestamp)

                if self.flags.is_running.is_set():

                    self.flags.error.set()

                    # Restart daq analog task
                    if not self.RestartDAQAnalog():
                        # Some error happened restarting analog, restart engine
                        self.logger.warning('DAQ did not restart properly. SignalEngineRestart().')
                        self.SignalEngineRestart()
                        return False
                    pass

            except DAQStartError:
                self.logger.exception("Exception rstarting DAQ.  Full restart of DAQ.")
                if self.flags.is_running.is_set():

                    self.flags.error.set()

                    # Do full restart of DAQ
                    if not self.RestartDAQ():
                        self.logger.warning('DAQ did not restart properly. SignalEngineRestart().')
                        self.SignalEngineRestart()
                        return False
                    pass

            except DAQInternalError:
                # Some error happened in the DAQ thread.
                self.logger.exception("Exception internal to DAQ process.  Full restart of DAQ.")
                #self.llog.logend(self.latest_timestamp)

                if self.flags.is_running.is_set():

                    self.flags.error.set()

                    # Do full restart of DAQ
                    if not self.RestartDAQ():
                        self.logger.warning('DAQ did not restart properly. SignalEngineRestart().')
                        self.SignalEngineRestart()
                        return False
                    pass

            except DAQNotFoundError:
                # DAQ device not found...serious error. Stopping
                self.logger.exception("DAQ Failure.")
                self.SignalStop()

            except DAQError:
                # General class of error, generated mostly in Engine when capturing
                self.logger.exception("Exception running GetDAQData().  Full restart of DAQ.")
                #self.llog.logend(self.latest_timestamp)

                if self.flags.is_running.is_set():

                    self.flags.error.set()

                    # Do full restart of DAQ
                    if not self.RestartDAQ():
                        self.logger.warning('DAQ did not restart properly. SignalEngineRestart().')
                        self.SignalEngineRestart()
                        return False
                    pass


            # GPS/Serial/Clock exceptions
            except ClockSkipError:
                self.logger.exception("Clock skipped. Non-critical error. Continuing.")
                #self.llog.logend(self.latest_timestamp)
                pass

            except ClockNoDataError:
                self.logger.exception("No data from serial clock. Restart LR.")
                #self.llog.logend(self.latest_timestamp)
                if self.flags.is_running.is_set():

                    self.flags.error.set()

                    if not self.RestartLR():
                        self.logger.warning('LR did not restart properly. SignalEngineRestart().')
                        # Some error happened restarting LR, restart engine
                        self.SignalEngineRestart()
                        return False
                    if not self.RestartGPS():
                        self.logger.warning('LR did not restart properly. SignalEngineRestart().')
                        # Some error happened restarting LR, restart engine
                        self.SignalEngineRestart()
                        return False

                    # Noticed that on GPS errors (no data - maybe a tick skip)
                    #  want to wait a small amount of time
                    self.logger.info('Waiting 60 seconds before restart.')
                    sleep(60.0 + random.random())
                    self.logger.info("Waiting 60 more.")
                    sleep(60.0 + random.random())

                    pass

            except ClockQueueFull:
                self.logger.exception("Clock queue full. Restart engine")

                if self.flags.is_running.is_set():

                    self.flags.error.set()

                    self.SignalEngineRestart()
                    return False


            except ClockInternalError:
                self.logger.exception("Exception happened in GPS process. Trying a restart.")
                #self.llog.logend(self.latest_timestamp)

                if self.flags.is_running.is_set():

                    self.flags.error.set()

                    # Stop(pause) daq first
                    if not self.RestartDAQAnalog():
                        self.logger.warning('DAQ analog did not restart properly. SignalEngineRestart().')
                        # Some error happened restarting LR, restart engine
                        self.SignalEngineRestart()
                        return False

                    if not self.RestartGPS():
                        self.logger.warning('GPS did not restart properly. Power cycle LR')

                        if not self.RestartLR():
                            self.logger.warning('LR did not restart properly. SignalEngineRestart().')
                            # Some error happened restarting LR, restart engine
                            self.SignalEngineRestart()
                            return False

                    pass

            except ClockError:
                # General error in Clock Process
                self.logger.exception("Exception running GetGPSData(). Trying a restart.")
                #self.llog.logend(self.latest_timestamp)

                if self.flags.is_running.is_set():

                    self.flags.error.set()

                    if not self.RestartDAQAnalog():
                        self.logger.warning('DAQ analog did not restart properly. SignalEngineRestart().')
                        # Some error happened restarting LR, restart engine
                        self.SignalEngineRestart()
                        return False
                    if not self.RestartGPS():
                        self.logger.warning('GPS did not restart properly. SignalEngineRestart().')
                        self.SignalEngineRestart()
                        return False

                    pass

            # Possible Engine errors
            except EngineMaxExceptionError:
                self.logger.exception("Max number of acceptable exceptions reached.")
                if self.flags.is_running.is_set():

                    self.flags.error.set()

                    # We want to keep going, but want to limit number of
                    self.SignalStop()
                    #self.SignalEngineRestart()
                    return False

            except EngineError:
                self.logger.exception("Engine error detected. Trying a restart.")
                #self.llog.logend(self.latest_timestamp)

                self.exceptions += 1

                if self.flags.is_running.is_set():

                    self.flags.error.set()

                    self.SignalEngineRestart()
                    return False

            except IOError:
                self.logger.exception("Disk IO Error")
                self.logger.critical("Disk Full!!!! Please clear hard drives space, according to Stanford instructions.")
                #self.llog.logend(self.latest_timestamp)

                self.SignalStop()


            # All other possible exceptions
            except Exception:
                self.logger.exception('Unexpected error.' )
                #self.llog.logend(self.latest_timestamp)

                self.exceptions += 1

                if self.flags.is_running.is_set():

                    self.flags.error.set()

                    self.SignalEngineRestart()
                    return False

        self.logger.info('Engine main loop finished.')

        self.flags.is_stopped.set()

        return True

    def WatchDog(self):

        self.wd_running = True
        state = None
        #tt = clock()
        tt = time()

        self.WCH_logger.info("Engine Watchdog thread started.")

        while self.wd_running:

            #ts = clock() - tt
            ts = time() - tt
            #self.WCH_logger.debug("Watchdog elapsed: %d " % ts)

            # Coarse measurement every 2 mins
            if (ts > 120):

                # reset timer
                tt = time()

                # If main loop is not running
                if not self.flags.is_running.is_set():
                    if state is None:

                        self.WCH_logger.warning("Engine does not seem to be running.")

                        # First time running this
                        state = "checking"

                    elif state == "checking":

                        # Second time running this...something is wrong
                        self.WCH_logger.warning("Caught the engine napping...restarting Engine")

                        # reset
                        state = None

                        # Uh oh...
                        self.SignalEngineRestart()

                    else:

                        self.WCH_logger.warning("Something strange going on in the watchdog.")
                        # reset
                        state = None

                else:
                    self.WCH_logger.info("Check OK.")

                    # reset
                    state = None


            # Need to set this to 1 sec so that when stopping the software, won't hang up waiting long time
            #self.WCH_logger.debug("Sleeping 1.")
            sleep(1)

        self.WCH_logger.info("Engine Watchdog thread finished.")



# =========
# Unit Test
# =========
if __name__ == "__main__":
    # Create the Engine object
    engine = Engine("../debugtools/EngineUnitTestDaqSettings.xml")

    # Perform the acquisition
#    engine.Start()
#    while raw_input("? ") != 'q':
#        pass
#    engine.Stop()
    engine.MainLoop()
