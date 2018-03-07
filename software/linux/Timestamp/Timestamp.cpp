#include "Timestamp.h"

Timestamp::Timestamp(int y, int mon, int d, int h, int min, int s)
{
    year = y;
    month = mon;
    day = d;
    hour = h;
    minute = min;
    second = s;
}

//bool Timestamp::operator==(const Timestamp & rhs) const
//{
//    if(this->year == rhs.year &&
//       this->month == rhs.month &&
//       this->day == rhs.day &&
//       this->hour == rhs.hour &&
//       this->minute == rhs.minute &&
//       this->second == rhs.second)
//    {
//        return true;
//    }
//    else
//        return false;
//}

// Returns difference in seconds
int Timestamp::operator-(const Timestamp & rhs) const
{
    int year = this->year - rhs.year;
    int month = this->month - rhs.month;
    int day = this->day - rhs.day;

    int hour = this->hour - rhs.hour;
    int minute = this->minute - rhs.minute;
    int second = this->second - rhs.second;

    int result = 0;

    result = (year * 31540000) + (month * 2628000) + (day * 86400) + (hour * 3600) + (minute * 60) + second;
    
    return result;
}


















