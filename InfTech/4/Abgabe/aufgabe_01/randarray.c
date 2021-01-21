#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 100

/*
 * Dieses Programm erzeugt und initialisiert einen int-Array zufaellig. 
 * Anschliessend werden geometrischer Mittelwert und arithmetischer 
 * Mittelwert berechnet und auf der Konsole ausgegeben.
 */
int main(void) {
    // Initialisiere Zufallszahlengenerator
    srand(time(0));

    // Deklariere und Intialisiere Variablen
    double arithm_mittelwert = 0.0;
    double geom_mittelwert = 1.0;

    // Array fuer Zufallszahlen anlegen
    int random_array[N];

    // Zufallszahlen erzeugen
    for (int i = 0; i < N; ++i) {
        random_array[i] = 1 + rand() % 100;
    }

    // Arithmetischen Mittelwert berechnen
    double summe = 0;
    for (int i = 0; i < N; ++i) {
        summe += random_array[i];
    }
    arithm_mittelwert = summe / N;

    // Geometrischen Mittelwert berechnen
    double produkt = random_array[0];
    for (int i = 1; i < N; ++i) {
        produkt = produkt * random_array[i];
    }
    geom_mittelwert = pow(produkt, (double)1 / N);

    // Ausgabe
    printf("Die arithmetische Mittelwert ist: %g\n", arithm_mittelwert);
    printf("Der geometrische Mittelwert ist: %g\n", geom_mittelwert);
}
