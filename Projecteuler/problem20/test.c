#include <stdio.h>
#include "long_math.h"

#define BUFFER_SIZE 250
char result[BUFFER_SIZE];
char a[BUFFER_SIZE];


int main(int argc, char const *argv[])
{

    long sum = 0;

	for (int i = 0; i < BUFFER_SIZE; ++i)
	{
		a[i]=0;
		result[i] = 0;
	}

    result[0] = 1;

/*
	for (int i = 1; i <= 100; ++i)
	{
		a[0] = i % 10;
		a[1] = (i / 10) %10;
		a[2] = i / 100;
		long_mul(result, a, result, BUFFER_SIZE);
	}
*/
	for (int i = 1; i <= 100; ++i)
	{
		long_mul_simple(result, i, result, BUFFER_SIZE);
	}
	 
    for (int i = 0; i < BUFFER_SIZE; ++i)
    {
    	sum = sum + result[i];
    }

    printf("Sum of the result is %ld\n", sum);

	
	return 0;
}