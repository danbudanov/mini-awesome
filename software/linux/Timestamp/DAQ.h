#ifndef DAQ_H
#define DAQ_H

#include <string>

using namespace std;

#define SUCCESS 1
#define FAILURE 0

typedef struct DAQData
{
    string t;
    string d;
} DAQData;

class DAQ
{
    public:
        DAQ();
        void Flush();
        int Start();
        DAQData getDAQData();
    public:
        int sampleRate;
};

#endif
