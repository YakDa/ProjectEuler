#include <stdio.h>
#include "Amicable.h"

int main(int argc, char const *argv[])
{
	long sum = 0;

	for (int i = 1; i <= 10000; ++i)
	{
		if (isAmicable(i))
		{
			sum = sum + i;
		}
	}

	printf("sum of amicable numbers is %ld\n", sum);
	return 0;
}