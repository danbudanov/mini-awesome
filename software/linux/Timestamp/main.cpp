#include <iostream>
#include <cmath>
#include "Timestamp.h"
#include "GPS.h"
#include "DAQ.h"
#include <unistd.h>

using namespace std;

#define LOW_LIMIT 0.9
#define UPPER_LIMIT 1.1

#define FAILED 0

// variables needed for SyncDAQwithGPS() function
bool is_running = false;
bool have_lock = false;
GPS gps;
DAQ daq;
time_t latest_timestamp;

// SyncDAQwithGPS function from Nick's python code
void SyncDAQwithGPS()
{
    if(is_running)
    {
        have_lock = gps.haveLock();
        
        gps.Flush();
        daq.Flush();
        
        usleep(random());
        
        GPSData gpsData = gps.getGPSData();
        cout << "Clear and sync to GPS @ " << gpsData.t << endl;
        
        time_t tt = clock();
        
        if(daq.Start() == FAILED)
        {
            cerr << "Error attempting to start DAQ" << endl;
        }
        
        time_t time_to_start_daq = clock() - tt;
        
        cout << "Time to start DAQ: " << time_to_start_daq << endl;
        
        time_t time_to_get_gps = 0;
        
        time_t ttgps;
        
        while(time_to_get_gps < 0.9 || time_to_get_gps > 1.1)
        {
            ttgps = clock();
            
            gpsData = gps.getGPSData();
            cout << "1st GPS @ " << gpsData.t << endl;
            
            time_to_get_gps = clock() - ttgps;
            cout << "Sync1: took " << time_to_get_gps << " to get GPS data" << endl;
        }
        
        ttgps = clock();
        int num_daq = 0;
        
        time_t time_to_get_data = 0;
        
        while(time_to_get_data < 0.9)
        {
            time_t ttdaq = clock();
            
            DAQData daqData = daq.getDAQData();
            cout << "DAQ @ " << daqData.t << endl;
            
            time_to_get_data = clock() - ttdaq;
            cout << "Sync2: took " << time_to_get_data << " to get DAQ data" << endl;
            
            if(time_to_get_data > 1.1)
            {
                cerr << "DAQ timing out of range, restarting engine" << endl;
            }
            num_daq++;
        }
        tt = clock();
        
        int number_gps_to_pop = int(round(tt-ttgps-1.0));
        
        if(number_gps_to_pop < num_daq-1)
        {
            number_gps_to_pop = num_daq - 1;
        }
        
        cout << "Popping " << number_gps_to_pop << " from GPS to sync" << endl;
        
        for(int i = 0; i<number_gps_to_pop; i++)
        {
            gpsData = gps.getGPSData();
            cout << "Popping GPS @ " << gpsData.t << endl;
        }
        
        gpsData = gps.getGPSData();
        cout << "3rd GPS @ " << gpsData.t << endl;
        
        time_t lastStartTime = latest_timestamp;
        time_t time_to_get_gps2 = clock() - tt;
        
        if(have_lock)
        {
            if(daq.sampleRate > 100000)
            {
                float tdiff = 0.58;
                if(time_to_get_gps2 > tdiff)
                {
                    cerr << "Took too long to get GPS timestamp in queue " << time_to_get_gps2 << endl;
                }
                else
                {
                    tdiff = 0.3;
                    if(time_to_get_gps2 > tdiff)
                    {
                        cerr << "Took too long to get GPS timestamp in queue " << time_to_get_gps2 << endl;
                    }
                    int sleep_seconds = (1-tdiff)-time_to_get_gps2;
                    int sleep_usecs = sleep_seconds * 1000000;
                    usleep(sleep_usecs);
                    if(gps.getQueueSize() > 0)
                    {
                        cerr << "Extra GPS timestamp in queue" << endl;
                    }
                }
            }
        }
        else
        {
            float sleep_seconds = 0.1;
            float sleep_usecs = sleep_usecs * 1000000.0;
            usleep(sleep_usecs);
            gps.Flush();
        }
        
        DAQData daqData = daq.getDAQData();
        cout << "Next DAQ @ " << daqData.t;
        
        time_to_get_data = clock() - tt;
        cout << "DAQ data " << time_to_get_data << " after last query" << endl;
        
        if(time_to_get_data < 0.9)
        {
            cerr << "DAQ available too soon" << endl;
        }
        
        cout << "Starting at " << latest_timestamp << endl;
        cout << "DAQ/GPS sync complete." << endl;
    }
}

bool compareTimestamps(Timestamp gpsT1, Timestamp gpsT2,
                       Timestamp sysT1, Timestamp sysT2)
{
    bool gpsGood = false;
    bool sysGood = false;
    
    int deltaT_GPS = gpsT2 - gpsT1;
    int deltaT_SYS = sysT2 - sysT1;
    
    int deltaD1 = gpsT1 - sysT1;
    int deltaD2 = gpsT2 - sysT2;
    
    if(deltaT_GPS >= LOW_LIMIT && deltaT_GPS <= UPPER_LIMIT)
        gpsGood = true;
    if(deltaT_SYS >= LOW_LIMIT && deltaT_SYS <= UPPER_LIMIT)
        sysGood = true;
    
    if(gpsGood && sysGood)
        return true;
    else
        return false;
}

int main()
{
    cout << "Hello world" << endl;
    
    // Got 1st timestamp from GPS
    Timestamp gpsT1(2018,2,28,2,41,5);

    // Log system time
    Timestamp sysT1(2018,2,28,2,41,5);

    // Got 2nd timestamp from GPS
    Timestamp gpsT2(2018,2,28,2,41,5);
    
    // Log system time
    Timestamp sysT2(2018,2,28,2,41,5);
    
    // Check for errors
    bool valid_timestamps = compareTimestamps(gpsT1, gpsT2, sysT1, sysT2);
    
    Timestamp ts1(2018,2,28,2,41,5);
    Timestamp ts2(2018,2,28,2,41,23);
    
    return 0;
}
