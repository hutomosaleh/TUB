#include <stdio.h>

int main(void) {
    float halbwertzeit = 11.4f;
    float startwert = 200.0f;
    float endwert = 0.02 * startwert;

    float mol_wert = startwert;
    float tage = 0.0f;
    while (mol_wert > endwert) {
        printf("%4.1f Tage: %8.4f mol\n", tage, mol_wert);
        tage += halbwertzeit;
        mol_wert = mol_wert / 2;
    }

    printf("%4.1f Tage: %8.4f mol - VERBRAUCHT\n", tage, mol_wert);
}