#include <stdio.h>

void rechnen(int x, int y) {
    int summe = x + y;
    int produkt = x * y;
    double durchschnitt = (x + (double)y) / 2;
    printf("\nZahl 1: %d \nZahl 2: %d", x, y);
    printf("\n%d + %d = %d", x, y, summe);
    printf("\n%d * %d = %d", x, y, produkt);
    printf("\nDurchschnitt(%d, %d) = %f\n", x, y, durchschnitt);
}

int main(void) {
    int zahl_1 = 2, zahl_2 = 4, zahl_3 = 6, zahl_4 = 9;

    rechnen(zahl_1, zahl_2);
    rechnen(zahl_3, zahl_4);

    return 0;
}