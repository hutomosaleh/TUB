#include "stdlib.h"
#include <stdio.h>

char **storage;
unsigned short capacity;

void vector(unsigned short size) {
    storage = (char **)calloc(sizeof(char *), size);
    capacity = size;
}

void push(char *string) {
    // Get size
    int size = 0;
    int i = 0;
    while (1) {
        if (!string[i]) {
            break;
        }
        ++i;
        ++size;
    }

    // Make string pointer
    char *str = (char *)malloc(sizeof(char) * size);
    for (int j = 0; j <= size; ++j) {
        str[j] = string[j];
    }

    int k = 0;
    while (1) {
        // Check if storage empty
        if (!storage[k] && k < capacity) {
            storage[k] = str;
            break;
        } else if (k >= capacity) {
            // Resize storage & insert str
            storage = (char **)realloc(storage, sizeof(char *) * capacity * 2);
            capacity = capacity * 2;
            storage[k] = str;
            // Put default value
            for (int l = k + 1; l < capacity; ++l) {
                storage[l] = 0;
            }
            break;
        }
        ++k;
    }
}

char *at(unsigned short index) {
    return storage[index];
}

void set(unsigned short index, char *string) {
    // Check validity of input
    if (index >= capacity) {
        printf("Index ausserhalb der Vektorlaenge.\n");
        return;
    } else if (!string) {
        storage[index] = 0;
        return;
    }

    // Get size
    int size = 0;
    int i = 0;
    while (1) {
        if (!string[i]) {
            break;
        }
        ++i;
        ++size;
    }

    // Make string pointer
    char *str = (char *)malloc(sizeof(char) * size);
    for (int j = 0; j <= size; ++j) {
        str[j] = string[j];
    }

    // Insert value by index
    storage[index] = str;
}

unsigned short size(void) {
    int vector_size = capacity;
    int i = 0;
    while (1) {
        if (!storage[i]) {
            --vector_size;
        } else if (i >= capacity) {
            return vector_size;
        }
        ++i;
    }
}

int main() {

    // Erzeuge Test-Vector
    vector(3);

    // Fuege 4 Strings hinten an
    push("Anton");
    push("Berta");
    push("Caesar");
    push("schon");
    push("aus");

    // setze erste 3 Elemente
    set(0, "Das");
    set(1, "sieht");
    set(2, "Dora");

    // setze ein ungueltiges Element
    set(100, "Friedrich");

    // loesche zweites und viertes Element
    set(2, 0);
    set(4, 0);

    // speichere neue Elemente
    push("doch");
    push("sehr");
    push("gut");
    push("aus");
    push(":)");

    // Gebe Test-Vektor aus
    for (int i = 0; i < capacity; ++i) {
        printf("%s ", at(i));
    }
    printf("\nInsgesamt %hu Eintraege.\n", size());

    return (0);
}