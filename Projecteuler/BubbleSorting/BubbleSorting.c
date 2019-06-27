#include <stdio.h>

int main() {

    FILE * fp;
    int buffer[1024];
    int len = 0;
    int i = 0;
    int j = 0;
    int temp;
    

    /* Read numbers from input file */
    fp = fopen("Numbers.txt", "r");

    while(fscanf(fp, "%d,", &buffer[len]) != EOF) {
        len++;
    }
    fclose(fp);



    /* Bubble sort algorithm */
    for(i = 0; i < len - 1; i++) {
        for(j = 0; j< len - i - 1; j++) {
            if (buffer[j] > buffer[j+1]) {
                temp = buffer[j];
                buffer[j] = buffer[j+1];
                buffer[j+1] = temp;
            }
        }
    }


    /* Write the result into output file */
    fp = fopen("Result.txt", "w");

    for(i = 0; i < len; i++)
        fprintf(fp, "%i,", buffer[i]);
    fclose(fp);



}
