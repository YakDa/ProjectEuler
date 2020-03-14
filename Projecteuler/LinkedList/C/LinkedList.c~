#include <stdio.h>
#include <stdlib.h>
#include "LinkedList.h"

/*
 *********************************************************
 * Function name: create
 *         input: input -- array pointer to data to be
 *                         created in linked list
 *                len   -- the length of linked list
 *        output: none
 *********************************************************
 */
void create(int *input, int len) {
    NODE *new;
    int i = 1;

    head = NULL;
    tail = NULL;

    new = (struct linked_list *)malloc(sizeof(struct linked_list));
    head = new;
    tail = new;
    tail->data = input[0];

    while(i < len) {
        new = (struct linked_list *)malloc(sizeof(struct linked_list));
        tail->next = new;
        tail = tail->next;
        tail->data = input[i];
        i++;
    }
    tail->next = NULL;
}

/*
 *********************************************************
 * Function name: append
 *         input: data -- data to be append at the tail
 *        output: none
 *********************************************************
 */

void append(int data) {
    NODE *new;
    
    new = (struct linked_list *)malloc(sizeof(struct linked_list));
    tail->next = new;
    tail = tail->next;
    tail->data = data;
    tail->next = NULL;
}

/*
 *********************************************************
 * Function name: insert
 *         input: data -- data to be insert
 *               index -- the index to insert data
 *        output: none
 *********************************************************
 */

void insert(int data, int index) {
    NODE *new;
    NODE *allocate;
    int i = 1;

    new = (struct linked_list *)malloc(sizeof(struct linked_list));
    new->data = data;
    allocate = head;
    while(i <= index) {
        allocate = allocate->next;
        i++;
    }
    new->next = allocate->next;
    allocate->next = new;
}

/*
 *********************************************************
 * Function name: deletenode
 *         input: index -- the index of the node to be
 *                         deleted
 *        output: none
 *********************************************************
 */

void deletenode(int index) {
    NODE *temp;
    allocate(index);
    
    if(current == head) {
        head = current->next;
    }
    else if(current == tail) {
        allocate(index - 1);
        tail = current;
        tail->next = NULL;
    }
    else {
        temp = current->next;
        allocate(index - 1);
        current->next = temp;
    }

}

/*
 *********************************************************
 * Function name: allocate
 *         input: index -- the index of data to allocate
 *        output: none
 *********************************************************
 */

void allocate(int index) {
    int i = 1;

    current = head;
    while(i <= index) {
        current = current->next;
        i++;
    }
}

/*
 *********************************************************
 * Function name: getlistlen
 *         input: none
 *        output: get length of the linked list pointed by
 *                header pointer
 *********************************************************
 */

int getlistlen() {
    int len = 1;
    NODE *temp;

    temp = head;

    if(head == NULL) return 0;
    while(temp->next != NULL) {
        temp = temp->next;
        len++;
    }
    return len;
}


