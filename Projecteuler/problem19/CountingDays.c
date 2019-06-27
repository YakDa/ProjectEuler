#include <stdio.h>

int count=0; // used to count the sundays which fell on the first of the month
int week;
int day;
int month;
int year;
int daysInMonth;

int main(int argc, char const *argv[])
{
	year = 1900;
	month = 1;
	day = 1;
	week = 1;
	daysInMonth = 31;

	// if it is 1st Jan 2001, then stop
	while(!((year==2001) && (month==1) && (day==1)))
	{
		// if it's sunday and the first of the month, then count plus one
		if ((week==7) && (day==1) && (year >= 1901))
		{
			count++;
		}

		week = week % 7 + 1;

        // year calculation
        if ((month == 12) && (day == (daysInMonth)))
        {
        	year++;
        }

        // month calucalation
        if (day == (daysInMonth))
        {
        	month = month % 12 + 1;
        }

        // day calcaulation
		day = day%(daysInMonth) + 1;


        // leap year judgement
        if ((month==9) || (month==4) || (month==6) || (month==11))
        {
        	daysInMonth = 30;
        }
        else if (month == 2)
        {
        	if (year%100 == 0)
        	{
        		if (year%400 == 0)
        		{
        			daysInMonth = 29;
        		}
        		else 
        			daysInMonth = 28;
        	}
        	else
        	{
		        if (year%4 == 0)
		        {
		        	daysInMonth = 29;
		        }
		        else
		        {
		        	daysInMonth = 28;
		        }
        	}

        }
        else 
        	daysInMonth = 31;

	}

	printf("The number of Sundays fell on the first day of month is: %d\n", count);

	return 0;
}