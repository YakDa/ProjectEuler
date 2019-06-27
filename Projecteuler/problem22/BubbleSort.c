#include "BubbleSort.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


/*
 *=========================================================================
 * Function Name: bubbleSort
 * Description:
 *            Bubble sorting strings according to the alphabet order
 * Input:
 *         pointer -- a pointer pointing the location of the string pools
 *         number  -- number of strings
 *
 *=========================================================================
 */
void bubbleSort(char pointer[6000][20], int number)
{
	int i = 0;
	int j = 0;
	char* temp;

	for (i = 0; i < number-1; ++i)
	{
		for (j = 0; j < number-1; ++j)
		{
			if(pointer[j] > pointer[j+1])
			{
				//temp = pointer[j+1];
				memcpy(temp, pointer[j+1], strlen(pointer[j+1]));
				//pointer[j+1] = pointer[j];
				memcpy(pointer[j+1], pointer[j], strlen(pointer[j]));
				//pointer[j] = temp;
				memcpy(pointer[j], temp, strlen(temp));
			}
		}
	}
}