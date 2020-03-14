#include <stdio.h>
#include "LinkedList.h"




int main() {
    int buffer[100] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int i;
    NODE node;

    for(i = 0; i < 10; i++)
        printf("%i\n", buffer[i]);

    create(buffer, 10);


    append(11);
    insert(3, 2);
    insert(5, 2);
    deletenode(3);
    deletenode(3);
    deletenode(0);
    deletenode(9);
    deletenode(7);

    node = *head;
    printf("%i\n", node.data);
    for(i = 1; i < 8; i++) {
        node = *node.next;
        printf("%i\n", node.data);
    }

    allocate(5);
    printf("%i\n", current->data);
    printf("The length of linked list is %i\n", getlistlen());

}



