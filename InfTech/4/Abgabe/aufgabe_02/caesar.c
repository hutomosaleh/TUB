#include <stdio.h>
#include <stdlib.h>

/*
 * Bekommt ein beliebiges Zeichen zeichen und einen Wert shift uebergeben.
 * Shiftet alle Zeichen aus dem Bereich a-z und A-Z um den Wert Shift. 
 * An den Wertebereichsgrenzen findet ein Umlauf statt (Beispielsweise:
 * nach Z folgt A, vor A liegt Z, nach z folgt a und vor a liegt z).
 * Zahlen ausserhalb des Bereichs werden unveraendert zurueckgegeben.
 * Gibt das kalkulierte Zeichen zurueck.
 */

char shiftChar(char zeichen, int shift) {
    char ergebnis;
    _Bool kleinbuchstabe = (unsigned)(zeichen - 'a') <= ('z' - 'a');
    _Bool grossbuchstabe = (unsigned)(zeichen - 'A') <= ('Z' - 'A');
    if (kleinbuchstabe) {
        ergebnis = zeichen + shift;
        if (ergebnis < 'a') {
            ergebnis = ergebnis - 'a' + 'z';
        } else if (ergebnis > 'z') {
            ergebnis = ergebnis - 'z' + 'a';
        }
    } else if (grossbuchstabe) {
        ergebnis = zeichen + shift;
        if (ergebnis < 'A') {
            ergebnis = ergebnis - 'A' + 'Z';
        } else if (ergebnis > 'Z') {
            ergebnis = ergebnis - 'Z' + 'A';
        }
    } else {
        ergebnis = zeichen;
    }
    return ergebnis;
}

/*
 * Bekommt einen beliebigen C-String uebergeben. 
 * Fuehrt auf jedem Zeichen des Strings die shiftChar-Funktion aus.
 * Der uebergebene originale String wird dabei veraendert.
 */
void cipher(char str[], int shift) {
    int i = 0;
    while (1) {
        if (str[i]) {
            str[i] = shiftChar(str[i], shift);
            ++i;
        } else {
            break;
        }
    }
}

/*
 * Testprogramm, das Strings mit dem Caesar-Chiffre chiffrieren kann. 
 * Es benutzt dazu die cipher-Funktion.
 */
int main(void) {
    char str[25] = "Das ist der Originaltext"; // Originaltext
    int shift = 5;
    printf("Original: ");
    printf("%s\n", str);

    // Verschluesseln
    cipher(str, shift);
    printf("Verschluesselt: ");
    printf("%s\n", str);

    // Entschluesseln
    cipher(str, -shift);
    printf("Entschluesselt: ");
    printf("%s\n", str);
}
