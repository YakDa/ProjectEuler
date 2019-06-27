#include "Amicable.h"


/*
char isAmicable
Input: an integer number
output: 0 : not amicable number
        1 : is amicable number
*/
char isAmicable(int num)
{
	int divisors[10000];
	int count=0;
	int pair1=0;
	int pair2=0;

	if (num < 2)
	{
		return 0;
	}
    else
    {
    	for (int i = 1; i < num; ++i)
    	{
    		if (num % i == 0)
    		{
    			divisors[count] = i;
    			count++;
    		}
    	}

    	for (int i = 0; i < count; ++i)
    	{
    		pair1 = pair1 + divisors[i];
    	}

    	count = 0;

    	for (int i = 1; i < pair1; ++i)
    	{
    		if (pair1 % i == 0)
    		{
    			divisors[count] = i;
    			count++;
    		}
    	}

    	for (int i = 0; i < count; ++i)
    	{
    		pair2 = pair2 + divisors[i];
    	}

    	if ((pair2 == num) && (pair1 != num))
    	{
    		return 1;
    	}
    	else
    	{
    		return 0;
    	}
    }
}