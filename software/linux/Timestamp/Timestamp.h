#ifndef TIMESTAMP_H
#define TIMESTAMP_H

class Timestamp
{
    public:
        Timestamp(int,int,int,int,int,int);
        bool operator==(const Timestamp & rhs) const;
        int operator-(const Timestamp & rhs) const;
    public:
        int year;
        int month;
        int day;
        int hour;
        int minute;
        int second;
};

#endif
