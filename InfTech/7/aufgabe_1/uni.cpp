#include "student.hpp"
#include <iostream>

int main() {
    int n = 0;
    do {
        std::cout << "Bitte geben Sie die Anzahl der Studenten ein: ";
        std::cin >> n;

        std::cin.clear();
        std::cin.ignore(1000, '\n');
    } while (n <= 0);

    Student **studenten = new Student *[n];
    std::string vorname, nachname;
    int matrikelnummer;

    for (int i = 0; i < n; ++i) {
        std::cout << "Vorname: ";
        std::cin >> vorname;
        std::cin.clear();
        std::cin.ignore(1000, '\n');

        std::cout << "Nachname: ";
        std::cin >> nachname;
        std::cin.clear();
        std::cin.ignore(1000, '\n');

        std::cout << "Matrikelnummer: ";
        std::cin >> matrikelnummer;
        std::cin.clear();
        std::cin.ignore(1000, '\n');

        studenten[i] = new Student(vorname, nachname, matrikelnummer);
    }

    for (int j = 0; j < n; ++j) {
        std::cout << " " << std::endl;
        std::cout << studenten[j]->nachname << std::endl;
        std::cout << studenten[j]->vorname << std::endl;
        std::cout << studenten[j]->matrikelnummer << std::endl;
    }

    for (int k = 0; k < n; ++k) {
        delete studenten[k];
    }
}
