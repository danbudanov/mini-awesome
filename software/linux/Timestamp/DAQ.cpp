#include "DAQ.h"

DAQ::DAQ()
{
    sampleRate = 100000;
}

void DAQ::Flush()
{
    
}

int DAQ::Start()
{
    return SUCCESS;
}

DAQData DAQ::getDAQData()
{
    DAQData daqData;
    daqData.t = "time";
    daqData.d = "date"; // ?
    
    return daqData;
}
