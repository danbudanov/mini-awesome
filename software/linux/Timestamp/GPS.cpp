#include "GPS.h"

GPS::GPS()
{
    
}

bool GPS::haveLock()
{
    return true;
}

void GPS::Flush()
{
    
}

GPSData GPS::getGPSData()
{
    GPSData gpsData;
    gpsData.t = "time";
    gpsData.d = "date"; // ?
    
    return gpsData;
}

int GPS::getQueueSize()
{
    return 0;
}
