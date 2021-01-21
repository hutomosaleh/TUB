/*
 * Hauptprogramm, welches unsere Haustier-Klasse enthaelt
 */

#include <iostream>
#include <string>

class Haustier {
public:
    std::string name;
    int alter;
    bool istSaeugetier;
};

int main() {
    Haustier weissbauchigel;
    weissbauchigel.name = "Isolde";
    weissbauchigel.alter = 9;
    weissbauchigel.istSaeugetier = true;

    Haustier chinchilla;
    chinchilla.name = "Chili";
    chinchilla.alter = 4;
    chinchilla.istSaeugetier = true;

    std::cout << "Der Weissbauchigel ist " << weissbauchigel.alter << " Jahre alt und heisst " << weissbauchigel.name << "." << std::endl;

    std::cout << "Der Chinchilla ist " << chinchilla.alter << " Jahre alt und heisst " << chinchilla.name << "." << std::endl;
}
