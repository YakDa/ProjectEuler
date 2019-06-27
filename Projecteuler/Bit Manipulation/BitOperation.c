#include <stdio.h>

#define setbit(a, b)  a = a|(1<<(b-1))
#define clrbit(a, b)  a = a&(0xFE<<(b-1))
#define revbit(a, b)  a = a^(1<<(b-1))

int main() {
    unsigned char testSet = 0x00;
    unsigned char testClr = 0xFF;
    unsigned char testRev = 0xAA;
    int i;

    for(i = 1; i <= 8; i++) {
        setbit(testSet, i);
        printf("%i\n", testSet);
    }

    for(i = 1; i <= 8; i++) {
        clrbit(testClr, i);
        printf("%i\n", testClr);
    }

    for(i = 1; i <= 8; i++) {
        revbit(testRev, i);
        printf("%i\n", testRev);
    }
    
}
