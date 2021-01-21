#include "stdlib.h"
#include <stdio.h>

int rec1(int n) {
    if (n <= 1)
        return 0;
    else
        return 3 * rec1(n - 1) + 2;
}

int rec2(int n) {
    if (n <= 1) {
        return 1;
    } else {
        if (n % 2 != 0) {
            return 2 * rec2(n - 1);
        } else if (n % 2 == 0) {
            return 2 * rec2(n - 1) - 1;
        }
    }
}

int main() {
    // rec1
    int index = 1;
    while (rec1(index) < 200) {
        ++index;
    }
    printf("%d", rec1(index));

    // rec2
}