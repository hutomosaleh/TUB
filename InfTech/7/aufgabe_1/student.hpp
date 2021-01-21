/*
 * Klasse, die einen Studenten repraesentiert
 */
#ifndef STUDENT_HPP
#define STUDENT_HPP

#include <string>

class Student {
public:
    std::string nachname;
    std::string vorname;
    unsigned int matrikelnummer;
    Student(std::string nachname, std::string vorname, unsigned int matrikelnummer);
};

#endif
