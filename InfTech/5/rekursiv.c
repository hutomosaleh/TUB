#include "stdlib.h"
#include <stdio.h>

int folgeglied = 1;

int rec1(int n) {
    int a_n = 3 * n + 2;
    if (a_n > 200) {
        return a_n;
    } else {
        return rec1(a_n);
    }
}

int rec2(int n) {
    if (n < 1)
        n = 1;

    int a_n;
    if (folgeglied % 2 != 0)
        a_n = 2 * n;
    else if (folgeglied % 2 == 0)
        a_n = 2 * n - 1;

    if (folgeglied < 9) {
        ++folgeglied;
        return rec2(a_n);
    } else {
        folgeglied = 1;
        return a_n;
    }
}

int main() {
    int a = rec1(0);
    printf("%d\n", a);
    int b = rec2(2);
    printf("%d\n", b);
}