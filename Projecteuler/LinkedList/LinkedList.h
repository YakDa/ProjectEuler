#ifndef LINKED_LIST_
#define LINKED_LIST_

struct linked_list
{
    int data;
    struct linked_list *next;
};

typedef struct linked_list NODE;


NODE *head;
NODE *tail;
NODE *current;


void create(int *input, int len);
void append(int data);
void insert(int data, int index);
void deletenode(int index);
void allocate(int index);
int getlistlen();
#endif
