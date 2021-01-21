#include <stdio.h>

int main(void) {
    float eps = 1.0f;

    while ((eps + 1000000.0f) != 1000000.0f) {
        printf("\nEps: %.15f", eps);
        eps = eps / 2;
    }

    printf("\nEps: %.15f", eps);
}