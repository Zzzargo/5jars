#include "Cont.h"

Cont::Cont(const string& file, string denumire, double coef) : numeFisier(file), balanta(0.0), numeCont(denumire), coeficient(coef) {
    ifstream fin(numeFisier);
    if (fin.is_open()) {
        fin >> balanta;
        fin.close();
    }
}

void Cont::afisare()
{
    cout << numeCont << ": " << balanta << endl;
}

void Cont::venit(double suma) {
    balanta += suma * coeficient;
    ofstream fout;
    fout.open(numeFisier);
    if (fout.is_open()) {
        fout << balanta;
        fout.close();
    }
}

void Cont::consum(double suma)
{
    balanta -= suma;
    ofstream fout(numeFisier);
    if (fout.is_open()) {
        fout << balanta;
        fout.close();
    }

    double total;
    ifstream fin("resources/t.txt");
    if (fin.is_open()) {
        fin >> total;
        fin.close();
    }
    total -= suma;
    fout.open("resources/t.txt");
    if (fout.is_open()) {
        fout << total;
        fout.close();
    }

    fout.open("resources/log.txt", ios::app);
    if (fout.is_open()) {
        time_t acum = time(0);
        char* data_ora = ctime(&acum);
        fout << data_ora << " - " << suma << " ";
        string detalii;
        cout << "Detalii: ";
        cin >> detalii;
        fout << detalii << endl;
        fout.close();
    }
}