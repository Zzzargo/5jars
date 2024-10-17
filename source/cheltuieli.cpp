#include "Cont.h"

int main() {
    char bucla;
    double total = 0.0;
    Cont N("resources/n.txt", "Nevoi", 0.6), P("resources/p.txt", "Placeri", 0.3), E("resources/e.txt", "Economii", 0.1);
    ofstream fout;
    ifstream fin;

    do
    {
        N.afisare();
        P.afisare();
        E.afisare();
        fin.open("resources/t.txt");
        if (fin.is_open()) {
            fin >> total;
            fin.close();
        }
        cout << "Total: " << total << endl;

        cout << "Selectati operatia dorita: " << endl;
        cout << "1 - Venit nou" << endl;
        cout << "2 - Consum" << endl;
        unsigned short op;
        cin >> op;
        cout << endl;
        double suma;

        switch (op)
        {
        case 1:
        {
            cout << "Suma: ";
            cin >> suma;
            N.venit(suma);
            P.venit(suma);
            E.venit(suma);
            total += suma;
            fout.open("resources/t.txt");
            if (fout.is_open()) {
                fout << total;
                fout.close();
            }
            fout.open("resources/log.txt", ios::app);
            if (fout.is_open()) {
                time_t acum = time(0);
                char* data_ora = ctime(&acum);
                fout << data_ora << " + " << suma << " ";
                string detalii;
                cout << "Detalii: ";
                cin >> detalii;
                fout << detalii << endl;
                fout.close();
            }
            break;
        }
        case 2:
        {
            cout << "Alegeti contul: " << endl;
            cout << "1 - Nevoi" << endl;
            cout << "2 - Placeri" << endl;
            cout << "3 - Economii" << endl;
            unsigned short alegere;
            cin >> alegere;
            switch (alegere)
            {
            case 1:
            {
                cout << "Suma: ";
                cin >> suma;
                N.consum(suma);
                break;
            }
            case 2:
            {
                cout << "Suma: ";
                cin >> suma;
                P.consum(suma);
                break;
            }
            case 3:
            {
                cout << "Suma: ";
                cin >> suma;
                E.consum(suma);
                break;
            }
            default:
                cout << "Cont invalid" << endl;
                break;
            }
        }
            break;
        default:
            cout << "Operatie invalida" << endl;
            break;
        }

        cout << "Doriti sa executati o alta operatie? (y/n) ";
        cin >> bucla;
        cout << endl;
    } while (bucla == 'y');
    return 0;
}
