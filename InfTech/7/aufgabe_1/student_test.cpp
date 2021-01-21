#include "student.hpp"
#include <iostream>

int main() {
    Student *student_heap = new Student("Nachname1", "Vorname1", 1);
    Student student_stack("Nachname2", "Vorname2", 2);

    std::cout << student_heap->nachname << std::endl;
    std::cout << student_heap->vorname << std::endl;
    std::cout << student_heap->matrikelnummer << std::endl;

    std::cout << student_stack.nachname << std::endl;
    std::cout << student_stack.vorname << std::endl;
    std::cout << student_stack.matrikelnummer << std::endl;

    delete student_heap;
}