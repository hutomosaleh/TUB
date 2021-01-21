#include <stdio.h>

int finde(char text[], char zuFinden[]) {
    int position = -1;

    int i = 0;
    int j = 0;
    while (1) {
        if (zuFinden[i]) {
            while (1) {
                if (text[j] == zuFinden[i]) {
                    if (position == -1) {
                        position = j;
                    }
                    ++j;
                    break;
                } else if ((position != -1) && (j > position)) {
                    i = -1;
                    position = -1;
                    break;
                } else if (!text[j]) {
                    break;
                }
                ++j;
            }
            ++i;
        } else {
            return position;
        }
    }
}

int main() {
    char text[] = "DieserTextistsehrsehrlang";
    char zuFinden[] = "ist";
    int index = finde(text, zuFinden);
    printf("%s beginnt bei Index %d\n", zuFinden, index);
}
