#include <stdio.h>

int main(void) {
    short punkte;
    printf("Geben Sie Ihre Punkte: ");
    scanf("%d", &punkte);

    // // Verschachtelte Ifs
    // if (punkte >= 36 && punkte <= 40) {
    //     printf("Ihre Note ist: %d", 1);
    // } else if (punkte >= 31 && punkte <= 35) {
    //     printf("Ihre Note ist: %d", 2);
    // } else if (punkte >= 26 && punkte <= 30) {
    //     printf("Ihre Note ist: %d", 3);
    // } else if (punkte >= 21 && punkte <= 25) {
    //     printf("Ihre Note ist: %d", 4);
    // } else if (punkte >= 0 && punkte <= 20) {
    //     printf("Ihre Note ist: %d", 5);
    // } else {
    //     printf("Eingabefehler");
    // }

    // Dijkstra-if's
    if (punkte >= 36 && punkte <= 40)
        printf("Ihre Note ist: %d", 1);
    if (punkte >= 31 && punkte <= 35)
        printf("Ihre Note ist: %d", 2);
    if (punkte >= 26 && punkte <= 30)
        printf("Ihre Note ist: %d", 3);
    if (punkte >= 21 && punkte <= 25)
        printf("Ihre Note ist: %d", 4);
    if (punkte >= 0 && punkte <= 20) {
        printf("Ihre Note ist: %d", 5);
    } else {
        printf("Eingabefehler");
    };
}
