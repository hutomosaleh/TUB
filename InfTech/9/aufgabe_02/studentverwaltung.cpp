#include "student.hpp"
#include <iostream>
#include <sstream>
#include <vector>

int main() {
    char eingabe;
    std::vector<Student *> studenten;
    std::stringstream ss;
    ss << "e: Das Program beenden\n"
       << "a: Ein Student hinzufuegen\n"
       << "s: Student ueber Matrikelnummer suchen\n"
       << "d: Student aus Liste loeschen\n"
       << "l: Alle Studenten auflisten\n";

    while (1) {
        std::cout << ss.str();
        std::cout << "Bitte geben Sie ein Befehl: ";
        std::cin >> eingabe;
        std::cin.clear();
        std::cin.ignore(1000, '\n');

        switch (eingabe) {
        case 'e':
            std::cout << "Das Programm ist beendet." << std::endl;
            exit(1);
        case 'a': {
            std::string name;
            unsigned int matrikelnummer;
            std::string studiengang;

            std::cout << "Ein/e Student/in wird jetzt hinzugefuegt" << std::endl;
            std::cout << "Geben Sie ein Name: ";
            std::cin >> name;
            std::cin.clear();
            std::cin.ignore(1000, '\n');
            std::cout << "Geben Sie die Matrikelnummer: ";
            std::cin >> matrikelnummer;
            std::cin.clear();
            std::cin.ignore(1000, '\n');
            std::cout << "Geben Sie der Studiengang: ";
            std::cin >> studiengang;
            std::cin.clear();
            std::cin.ignore(1000, '\n');

            Student *tempStudent = new Student(name, matrikelnummer, studiengang);
            studenten.push_back(tempStudent);
            break;
        }
        case 's': {
            int matrikelnummer;
            std::cout << "Student aus Studentenlist wird gesucht..." << std::endl;
            std::cout << "Geben Sie die Matrikelnummer: ";
            std::cin >> matrikelnummer;
            std::cin.clear();
            std::cin.ignore(1000, '\n');

            std::vector<Student *>::iterator it;
            bool gefunden = false;
            for (it = studenten.begin(); it != studenten.end(); ++it) {
                gefunden = (matrikelnummer == (*it)->getMatrikelnummer());
                if (gefunden) {
                    std::cout << (*it)->asString();
                    break;
                }
            }
            if (!gefunden) {
                std::cout << "\nKeine passende Matrikelnummer gefunden." << std::endl;
            }
            break;
        }
        case 'd': {
            int matrikelnummer;
            std::cout << "Student aus Studentenlist wird geloescht..." << std::endl;
            std::cout << "Geben Sie die Matrikelnummer: ";
            std::cin >> matrikelnummer;
            std::cin.clear();
            std::cin.ignore(1000, '\n');

            std::vector<Student *>::iterator it;
            bool gefunden = false;
            for (it = studenten.begin(); it != studenten.end(); ++it) {
                gefunden = (matrikelnummer == (*it)->getMatrikelnummer());
                if (gefunden) {
                    std::cout << (*it)->asString() << "wird geloescht" << std::endl;
                    delete *it;
                    studenten.erase(it);
                    break;
                }
            }
            if (!gefunden) {
                std::cout << "\nKeine passende Matrikelnummer gefunden." << std::endl;
            }
            break;
        }
        case 'l': {
            std::vector<Student *>::iterator it;
            for (it = studenten.begin(); it != studenten.end(); ++it) {
                std::cout << (*it)->asString() << std::endl;
            }
            break;
        }
        default:
            std::cout << "\nUngueltige Eingabe." << std::endl;
            break;
        }
    }
}