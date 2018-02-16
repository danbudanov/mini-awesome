/*  Author: Alex Simoneaux
 *
 *  Opportunity Research Scholars (ORS)
 *  2017-2018 Academic Year
 *
 *  Low Frequency (LF) Radio Lab
 *  Faculty: Dr. Morris Cohen
 *  Graduate Mentors: Nicholas Gross, Jackson McCormick
 */

#include <iostream>
#include <stdint.h>
#include <string>
#include <pthread.h>
#include <cstdio>
#include <ctime>
#include <fstream>
#include <iomanip>
#include <signal.h>

using namespace std;

pthread_t readThread;
pthread_t writeThread;

pthread_mutex_t coutMutex;

// FPGA addresses and size
uint32_t * FPGA_start;
uint32_t * FPGA_stop;
int FPGA_size = 5;

// DRAM addresses and size
uint32_t * DRAM_start;
uint32_t * DRAM_stop;
int DRAM_size = 20;

// Temporary buffers for testing data
uint32_t FPGA_buffer[5];
uint32_t DRAM_buffer[20];

// Address used by write thread to read from FPGA
uint32_t * FPGA_read_address;
uint32_t * DRAM_write_address;
uint32_t * DRAM_read_address;

// Keep track of how far behind the read thread is from the write thread
int readWriteGap = 0;

// Timing variables
clock_t start;
double duration;

// Average write time variables
int numWrites = 0;
int maxWrites = 100000;

// Output file that will be stored on external hard drive
ofstream file;

// Enumeration to make circular_buffer_update function more readable
typedef enum Memory_Types
{
    FPGA = 0,
    DRAM = 1,
} Memory;

// Use datetime instead
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void getTimeStamp()
{
    int
}

// Initialization function for temporary FPGA buffer
void init_FPGA_memory()
{
    for(int i=0; i<FPGA_size; i++)
        FPGA_buffer[i] = i;
}

// Helper print functions
void print_FPGA_memory()
{
    pthread_mutex_lock(&coutMutex);
    cout << endl << "**********FPGA memory**********" << endl;
    for(int i=0; i<FPGA_size; i++)
        cout << "FPGA[" << i << "]: " << *(FPGA_start+i) << endl;
    
    cout << "*******************************" << endl << endl;
    pthread_mutex_unlock(&coutMutex);

}
void print_DRAM_memory()
{
    pthread_mutex_lock(&coutMutex);
    cout << endl << "**********DRAM memory**********" << endl;
    for(int i=0; i<DRAM_size; i++)
        cout << "DRAM[" << i << "]: " << *(DRAM_start+i) << endl;
    
    cout << "*******************************" << endl << endl;
    pthread_mutex_unlock(&coutMutex);
}

double getTime_ms()
{
    return (clock() / (double) CLOCKS_PER_SEC);
}

void print_timestamped_value(uint32_t value, string rw)
{
    // Safely print that value to the console
    pthread_mutex_lock(&coutMutex);
    {
        if(!rw.compare("read"))
            cout << "(+" << getTime_ms() << ") - - - " << "DRAM read[" << DRAM_read_address << "]: " << value << endl;
        else
            cout << "(+" << getTime_ms() << ") - - - " << "DRAM write[" << DRAM_write_address << "]: " << value << endl;
    }
    pthread_mutex_unlock(&coutMutex);
}

// Use this function when updating the addresses (FPGA_read, DRAM_write, and DRAM_read)
// to ensure that they wrap around for the circular buffer
void circular_buffer_update(uint32_t * & ptr, Memory type)
{
    ptr++;
    switch (type) {
        case FPGA:
        {
            if(ptr >= FPGA_stop)
                ptr = FPGA_start;
            break;
        }
        case DRAM:
        {
            if(ptr >= DRAM_stop)
                ptr = DRAM_start;
            break;
        }
    }
}

// Read from DRAM thread
void * readFromDRAM(void * v)
{
    
    // app (append), trunc (overwrite)
    file.open("data.txt", ofstream::out | ofstream::trunc);
    
    file << "Sample #\tValue" << endl;
    
    unsigned long threadID = (unsigned long) v;
    
    bool holding = false;
    bool going = false;
    
    uint32_t value = 0;
    
    int numReads = 0;
    
    // Run continuously (Ctrl+C)
    while(true)
    //while(numReads < maxWrites)
    {
        if(readWriteGap <= 0)
        {
            holding = true;
        //  pthread_mutex_lock(&coutMutex);
            {
                if(going)
                {
                    going = false;
                    holding = true;
                    
                //    cout << "Starting timer..." << endl;
                    start = clock();
                }
                
            //  cout << "Read thread caught up to write thread. Waiting..." << endl;
            }
            //pthread_mutex_unlock(&coutMutex);

        }
        
        else
        {
            if(holding)
            {
                holding = false;
                going = true;
            /*
                pthread_mutex_lock(&coutMutex);
                {
                    cout << "Stopping timer..." << endl;
                    duration = (clock() - start) / (double) CLOCKS_PER_SEC;
                    cout << "Elapsed time: " << duration << endl;
                }
                pthread_mutex_unlock(&coutMutex);
            */  
            }
            
            // Access the DRAM and read the value
            value = (*DRAM_read_address);
            
            // Write that value to the file
            file << numReads << "\t\t" << value << endl;
  
        /*          
            print_timestamped_value(value, "read");
        */    
        
            // Update the position of the DRAM_read_address
            circular_buffer_update(DRAM_read_address, DRAM);
            
            readWriteGap--;
            numReads++;
        }
    }

//    pthread_mutex_lock(&coutMutex);
//    {
//        cout << "Max writes: " << maxWrites << endl;
//        cout << "Num reads: " << numReads << endl;
//        cout << "Read finished" << endl;
//    }
//    pthread_mutex_unlock(&coutMutex);
    
    return v;
}

// Write to DRAM thread
void * writeToDRAM(void * v)
{
    unsigned long threadID = (unsigned long) v;
    
    uint32_t value = 0;
    
    // Run continuously (Ctrl+C)
    while(true)
    {
        // Access the FPGA memory and write the current value to DRAM
        //
        // NOTE: Don't need mutexes because of implicit control flow of the code
        // (i.e. - We make sure the read thread always trails the write thread and
        //          therefore you will never have memory contention)
        
        value = (*FPGA_read_address);
        
        (*DRAM_write_address) = value;

    /*
        print_timestamped_value(value, "write");
    */
        
        // Update both the FPGA_read_address and DRAM_write_address for next iteration
        circular_buffer_update(FPGA_read_address, FPGA);
        circular_buffer_update(DRAM_write_address, DRAM);
        
        numWrites++;
        readWriteGap++;
    }
    
    return v;
}

// Define the function to be called when ctrl-c (SIGINT) signal is sent to process
void signal_callback_handler(int signum)
{
    printf("Caught signal %d\n",signum);
    // Cleanup and close up stuff here
    
    file.close();

    // Terminate program
    exit(signum);
}


int main()
{
    // Register signal and signal handler
    signal(SIGINT, signal_callback_handler);
    
    cout << "Start of main" << endl;
    
    // Timestamp verification
    
    // Initialize all the pointers
    FPGA_start = FPGA_buffer;
    DRAM_start = DRAM_buffer;
    
    // EDIT: use these functions when implementing on SoC
    //FPGA_start = GET_FPGA_BASE_ADDRESS();
    //FPGA_size = GET_FPGA_SIZE(); 
    //DRAM_start = GET_DRAM_BASE_ADDRESS();
    //DRAM_size = GET_DRAM_SIZE();
    
    // Align pointers to the starts of the DRAM and FPGA memory spaces
    DRAM_read_address = DRAM_start;
    DRAM_write_address = DRAM_start;
    FPGA_read_address = FPGA_start;
    
    // Align stopping points to end of the memory spaces
    // (for use with circular_buffer_update)
    FPGA_stop = FPGA_start + FPGA_size;
    DRAM_stop = DRAM_start + DRAM_size;
    
    // Print out where the starting addresses are
    cout << "DRAM_write address: " << DRAM_write_address << endl;
    cout << "DRAM_read address: " << DRAM_read_address << endl;
    cout << "FPGA_read address: " << FPGA_read_address << endl;
    
    // Initialize temporary testing memory
    init_FPGA_memory();
    
    // Print init state for FPGA and DRAM memories
    print_FPGA_memory();
    print_DRAM_memory();

    // Initalize mutexes
    pthread_mutex_init(&coutMutex,0);
    
    // Spawn threads
    pthread_create(&readThread, 0, readFromDRAM, (void*) 0);
    pthread_create(&writeThread, 0, writeToDRAM, (void*) 1);

    // Measure time it takes to write 10,000 samples
    // and find the average time/write
    double startTime = clock();    
   
    while(numWrites < maxWrites) {}

    double stopTime = clock();

    double duration = (stopTime - startTime) / (double) CLOCKS_PER_SEC;
    double avgWriteTime = duration/maxWrites;

    pthread_mutex_lock(&coutMutex);
    {
        cout << "Time to write " << maxWrites  << ": " << duration << endl;
            cout << "Average time per write: " << avgWriteTime << endl << endl;
    }
    pthread_mutex_unlock(&coutMutex);
    
    // Wait for thread termination (don't let program finish)
    pthread_join(readThread, NULL);
    
    //pthread_join(writeThread, NULL);
}
