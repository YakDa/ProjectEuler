#include "long_math.h"
#include <stdlib.h>
#include <string.h>

/*
long_mul()
inpput:  two array numbers
output:
*/
void long_mul(char *a, char *b, char *result, int length)
{
    int i=0;
    int j=0;
    char carry=0;
    char *temp;
    char *sum;

    sum = (char *)malloc(length);
    temp = (char *)malloc(length);

    for (i=0;i<length;++i)
    {
        sum[i] = 0;
        temp[i] = 0;
    }

    for(j=0;j<length;j++)
    {
        for (i=0;i<j;++i)
        {
            temp[i]=0;
        }

        for(i=0;i<length-j;i++)
        {
            temp[i+j]=a[i]*b[j]+carry;
            carry = temp[i+j] / 10;
            temp[i+j] = temp[i+j] % 10;
        }

        long_add(sum, temp, sum, length);
    }
    memcpy(result, sum, length);
    free(sum);
    free(temp);
}

/*
long_mul_simple()
inpput:  One array number, one integer number
output:
*/
void long_mul_simple(char *a, int b, char *result, int length)
{
    char *temp;
    temp = malloc(length);

    for (int i = 0; i < length; ++i)
    {
        temp[i]=0;
    }

    for (int i = 0; i < b; ++i)
    {
        long_add(temp, a, temp, length);
    }

    memcpy(result, temp, length);
    free(temp);
}

/*
long_add()
input: two array numbers
output:
*/
void long_add(char *a, char *b, char *result, int length)
{
    int i=0;
    int carry=0;

    for (i = 0; i < length; ++i)
    {
        result[i]= a[i] + b[i] + carry;
        carry = result[i] / 10;
        result[i] = result[i] % 10;
    }
}

