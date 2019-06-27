#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char * arrayReverse_base1(char *source);
void arrayReverse_base2(char *source, char *target);
void doNothing();

int main() {

    char a[100] = "reverse me!";
    char b[100];
    char *c;

    arrayReverse_base2(a, b);
    printf("%s\n", a);
    printf("%s\n", b);

    c = arrayReverse_base1(a);
    printf("%s\n", c);
    free(c);
    doNothing();
    printf("%s\n", a);

}

/*
 *************************************************
 * input:
 *       source - source pointer before reverse 
 *       return - return the new allocated pointer
 *                to the reversed string
 *************************************************
 */
char * arrayReverse_base1(char *source) {
    int i;
    char *temp;

    temp = (char *) malloc(100);

    for(i = strlen(source) - 1; i >= 0; i--)
        temp[i] = source[strlen(source) - 1 - i];
    
    temp[strlen(source)] = '\0';

    return temp;
}

void doNothing() {
    char temp[100];
    char *string = "whatever is";
    int i;
   
    for(i = 0; i < strlen(string); i++)
        temp[i] = string[i];
    temp[strlen(string)] = '\0';
}

/*
 *************************************************
 * input:
 *       source - source pointer before reverse
 *       target - taget pointer after reverse
 *************************************************
 */

void arrayReverse_base2(char *source, char *target) {
    int i;
    
    for(i = strlen(source) - 1; i >= 0; i--)
        target[i] = source[strlen(source) - 1 - i];
    
    target[strlen(source)] = '\0';
    return;

}




