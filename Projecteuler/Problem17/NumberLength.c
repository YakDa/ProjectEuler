#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* numbertostring(char* str, int i);


char numberString0To19[20][10] = {"", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",\
                                  "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen",\
                                  "seventeen", "eighteen", "nineteen"};
char numberStringX0[10][10] = {"", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"};

int main() {

    int i;
    long result = 0;
    char* buffer;
    for(i = 1; i <= 1000; i++) {
        // Here is the best solution to allocate dynamic memory, if
        // allocate inside function, then there is no good way to free the memory.
        // You can free the memory after return from function, but it is hard to read.
        // So managing the buffer outside function will be clearer and easier.
        buffer = (char*) malloc(100);
        result = result + strlen(numbertostring(buffer, i));
        free(buffer);
    }

    printf("%li\n", result);

}


/*
 * Function Name: numbertostring
 * input:  
 *         str: the dynamic buffer pointer allocated outside the function
 *         i:   integer number from 1 to 1000
 * output: String converted from input integer number
 */

char* numbertostring(char* str, int i) {

    if( i >= 0 && i <= 19)
        return numberString0To19[i];

    else if( i >= 20 && i < 1000 ) {

        if( i/100 != 0 ) {

            strcpy(str, numberString0To19[i/100]);

            if ( i%100 == 0) {
                strcat(str, "hundred");
            }
            else {
                strcat(str, "hundredand");

                if( i%100 >= 0 && i%100 <= 19 ) {
                    strcat(str, numberString0To19[i%100]);
                }
                else {
                    strcat(str, numberStringX0[(i/10)%10]);
                    strcat(str, numberString0To19[i%10]);
                }
            }
        }
        else {
            strcpy(str, numberStringX0[i/10]);
            strcat(str, numberString0To19[i%10]);
        }

        return str;
            
    }
    else if( i == 1000 )
        return "onethousand";
    
    return NULL;
}
