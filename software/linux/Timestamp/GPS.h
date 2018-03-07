#ifndef GPS_H
#define GPS_H

#include <string>

using namespace std;

typedef struct GPSData
{
    string t;
    string d;
} GPSData;

class GPS
{
    public:
        GPS();
        bool haveLock();
        void Flush();
        GPSData getGPSData();
        int getQueueSize();
};

#endif
