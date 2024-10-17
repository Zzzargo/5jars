#pragma once
#include <fstream>
#include <iostream>
#include <ctime>
using namespace std;

class Cont
{
private:
    string numeFisier;
    string numeCont;
    double balanta;
    double coeficient;

public:
    Cont(const string& file, string denumire, double coef);
    void afisare();
    void venit(double suma);
    void consum(double suma);
};