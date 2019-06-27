#include<stdio.h>

/*
 * Define a normal structure 
 */
struct playcast {
    long a;
    int b;
    float c;
};


int main() {
    int i;
    /* Get the offset of each member of structure playcast */
    i = (int)&(((struct playcast *)0) -> a);
    printf("Offset of a = %i\n", i);
    i = (int)&(((struct playcast *)0) -> b);
    printf("Offset of b = %i\n", i);
    i = (int)&(((struct playcast *)0) -> c);
    printf("Offset of c = %i\n", i);
}
