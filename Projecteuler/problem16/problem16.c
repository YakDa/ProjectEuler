/*  HELLO.C -- Hello, world */

#include "stdio.h"

/*
long_mul()
inpput:  two numbers
output:
*/
void long_mul(char *a, char b)
{
    int i=0;
    char carry=0;

    for(i=0;i<500;i++)
    {
        a[i]=a[i]*b+carry;
        if(a[i]>=10)
        {
            carry=1;
            a[i]=a[i]-10;
        }
        else
            carry=0;
    }
}

int main()
{
   char num[500]={0},carry=0;
   int i=0, j=0, length=0;
   long sum=0;
   num[0]=2;
   for(i=0;i<1000-1;i++)
        long_mul(num, 2);
   for(i=499;i>=0;i--)
   {
        if(num[i]!=0)
        {
            length=i+1;
            break;
        }
   }

   for(i=0;i<length;i++)
        sum+=num[i];
   printf("%d\n",length);
   printf("%ld\n",sum);

   getchar();

}
