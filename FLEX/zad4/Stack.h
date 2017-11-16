#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define FREE(T) do { free (T); T = NULL; } while (0)

typedef struct listNode node;
typedef struct list List;

struct listNode {
    int value;
    node* next;
};

struct list {
    node* head;
    node* tail;
    int size;
};

List* create() {
    List* list = (List*) malloc(sizeof(List*));
    list->head = NULL;
    list->tail = NULL;
    list->size = 0;
    return list;
}

void push(List* list, int value) {
    node* element = (node*) malloc(sizeof(node*));
    element->value = value;

    if(list->size == 0) {
        list->head = element;
        list->tail = element;
        element->next = NULL;
    }
    else{
        element->next = list->head;
        list->head = element;
    }

    ++list->size;
}

int pull(List* list) {
    if(list->size > 1) {
        int value = list->head->value;
        node* temp = list->head;

        list->head = temp->next;
        FREE(temp);
        --list->size;
        return value;
    }else if(list->size == 1) {
        int value = list->head->value;
        FREE(list->head);
        --list->size;
        return value;
    }
    else {
        return -1;
    }
}

int getValue(List* list, int position) {
    if(position > list->size || position < 1) {
        printf("wrong position indicator\n");
        return -1;
    }
    int i;
    node* element = list->head;
    for(i = 1; i < position; i++)
        element = element->next;

    return element->value;
}

void empty(List* list) {
    node* element;
    while(list->size > 1) {
        element = list->head;
        list->head = list->head->next;
        FREE(element);
        --list->size;
    }
    // FREE(element);
    --list->size;
}

List* empty2() {
    List* list = (List*) malloc(sizeof(List*));
    list->head = NULL;
    list->tail = NULL;
    list->size = 0;
    return list;
}

void destroy(List* list) {
    if(list->size > 0)
        empty(list);
    FREE(list);
    list->head = NULL;
}
