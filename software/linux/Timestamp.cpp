#include <iostream>
#include <unistd.h>
#include <fstream>
#include <string>
#include <chrono>

using namespace std;

ifstream serial;
ofstream file;

void openSerialPort()
{
    serial.open("/dev/tty.usbserial-AK05DLE0");
    
    cout << "Serial open attempt" << endl;
    
    if (serial.fail())
    {
        cerr << "Could not open serial port" << endl;
        exit(1);
    }
    
    cout << "Serial port opened successfully" << endl;
}

void openOutputFile()
{
    file.open("timestamp.txt", ios::app);
    
    cout << "Output file open attempt" << endl;
    
    if(file.fail())
    {
        cerr << "Could not open output file" << endl;
        exit(1);
    }
    
    cout << "Output file opened successfully" << endl;
}

string getDataFromSerial()
{
    string line;

    if(!getline(serial,line))
    {
        cout << "Failure reading line from serial" << endl;
        exit(1);
    }
    
    return line;
}

tm parseLine(string line)
{
    tm ts;
    
    line = line.substr(24); // random value to chop off position info at front
    
    int year = stoi(line.substr(0,4));
    int month = stoi(line.substr(4,6));
    int day = stoi(line.substr(6,8));
    int hour = stoi(line.substr(8,10));
    int minute = stoi(line.substr(12,14));
    int second = stoi(line.substr(14,16));
    int millisecond = stoi(line.substr(16,19));
    
    ts.tm_year = year - 1900;   // in terms of years since 1900
    ts.tm_mon = month - 1;      // range is 0-11 (months since January)
    ts.tm_day = day;
    ts.tm_hour = hour;
    ts.tm_min = minute;
    ts.tm_sec = second;
    ts.MILLISECOND = millisecond;
    
    return ts;
}

void writeToOutputFile(string line)
{
    file << line << endl;
}

int main()
{
    cout << "Start of main" << endl;
    
    openSerialPort();
    
    string line = getDataFromSerial();
    writeToOutputFile(line);
    
    serial.close();
    file.close();
}


























