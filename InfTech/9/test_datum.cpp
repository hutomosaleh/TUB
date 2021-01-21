#include <iostream>
#include <sstream>
#include <string>

class Datum {
private:
    int tag, monat, jahr;

public:
    Datum(int t, int m, int j) : tag(t), monat(m), jahr(j) {
        if (t < 0 || t > 31) {
            std::cout << "Warnung: Ungueltiger Tag " << tag << std::endl;
        }
        if (m < 0 || m > 12) {
            std::cout << "Warnung: Ungueltiger Monat " << monat << std::endl;
        }
    };
    std::string getTT() {
        std::stringstream ss;
        if (tag < 10) {
            ss << "0" << std::to_string(tag);
        } else {
            ss << std::to_string(tag);
        }
        return ss.str();
    };
    std::string getMM() {
        std::stringstream ss;
        if (monat < 10) {
            ss << "0" << std::to_string(monat);
        } else {
            ss << std::to_string(monat);
        }
        return ss.str();
    };
    std::string getJahr() {
        return std::to_string(jahr);
    };
    virtual std::string formatiere() = 0;
};

class DatumISO : public Datum {
public:
    using Datum::Datum;
    std::string formatiere() {
        std::stringstream ss;
        ss << getJahr() << "." << getMM() << "." << getTT();
        return ss.str();
    };
};

class DatumDE : public Datum {
public:
    using Datum::Datum;
    std::string formatiere() {
        std::stringstream ss;
        ss << getTT() << "." << getMM() << "." << getJahr();
        return ss.str();
    };
};

class DatumUSA : public Datum {
public:
    using Datum::Datum;
    std::string formatiere() {
        std::stringstream ss;
        ss << getMM() << "." << getTT() << "." << getJahr();
        return ss.str();
    };
};

int main() {
    std::cout << "Erzeuge Objekte und gebe korrektes Datum in den drei Formaten aus:" << std::endl;
    DatumDE dateDE(1, 12, 2021);
    std::cout << "Deutsche Formatierung: " << dateDE.formatiere() << std::endl;
    DatumUSA dateUSA(1, 12, 2021);
    std::cout << "Amerikanische Formatierung: " << dateUSA.formatiere() << std::endl;
    DatumISO dateISO(1, 12, 2021);
    std::cout << "ISO-Formatierung: " << dateISO.formatiere() << std::endl;

    std::cout << "Erzeuge Objekte und gebe falsches Datum in den drei Formaten aus:" << std::endl;
    DatumDE dateDE_falsch(4, 20, 2021);
    std::cout << "Deutsche Formatierung: " << dateDE_falsch.formatiere() << std::endl;
    DatumUSA dateUSA_falsch(4, 20, 2021);
    std::cout << "Amerikanische Formatierung: " << dateUSA_falsch.formatiere() << std::endl;
    DatumISO dateISO_falsch(4, 20, 2021);
    std::cout << "ISO-Formatierung: " << dateISO_falsch.formatiere() << std::endl;

    return 0;
}