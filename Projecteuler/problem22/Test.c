#include "BubbleSort.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_NAME 20

int main(int argc, char const *argv[])
{
	char name[MAX_NAME];
	int n = 0;
	int i = 0;
	char** result;
	char name_pool[6000][20]={0};
	FILE* file = fopen("p022_names.txt", "r");

	while(fscanf(file, "\"%[^\"]\",", name) != EOF)
	{
		memcpy(name_pool[n], name, strlen(name));
		//printf("%s\n", name_pool[n]);
		n++;
	}
	printf("%i\n", n);
	fclose(file);

	bubbleSort(name_pool, n);

	for (i = 0; i < n; ++i)
	{
		printf("%s\n", name_pool[i]);
	}



	file = fopen("p022_names.txt", "r");
	
	return 0;
}