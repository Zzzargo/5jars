#include "account.h"

int main() {
    vector<Account> accounts; // vector containing Account objects(accounts)

    // Reading accounts
    ifstream accounts_reader;
    accounts_reader.open("../resources/accounts.txt");

    if (!accounts_reader.is_open()) {
        cerr << "Error: Unable to open the accounts file." << endl;
        return 1; // Exit the program with an error code
    }

    unsigned short num_of_accounts;
    accounts_reader >> num_of_accounts;

    unsigned short i = 0;
    while (i < num_of_accounts) {
        string name;
        double coef;
        double balance;
        accounts_reader >> name;
        accounts_reader >> coef;
        accounts_reader >> balance;
        accounts.emplace_back(i, name, coef, balance); // Construct a new account with the ID = i and append it to the vector
        i++;
    }
    accounts_reader.close();
    ofstream fout;
    ifstream fin;

    cout << "WELCOME HOME, MASTER" << endl;

    while (true) {
        double total = 0.0;
        for (i = 0; i < num_of_accounts; i++) {
            accounts[i].display(); // Display all accounts, building the total
            total += accounts[i].get_balance();
        }
        cout << "What do you want to do?" << endl;
        cout << "1 - Income" << endl;
        cout << "2 - Withdrawal" << endl;
        cout << "q - quit" << endl;
        char op;
        cin >> op;
        cout << endl;

        double sum;

        switch ((int)op)
        {
        case '1':
            cout << "Sum: ";
            cin >> sum;
            for (i = 0; i < num_of_accounts; i++) {
                accounts[i].income(sum);
            }
            total += sum;
            break;

        case '2':
            cout << "Which account do you want to withdraw from?" << endl;
            for (i = 0; i < num_of_accounts; i++) {
                cout << i << " - " << accounts[i].get_name() << endl; // Get accounts by their ID
            }

            unsigned short choice;
            cin >> choice;
            cout << "How much would you like to withdraw from " << accounts[choice].get_name() << " ? ";
            cin >> sum;
            accounts[choice].withdrawal(sum);
            break;

        case 'q':
            exit(0);
        default:
            cout << "Invalid operation. Try again." << endl << "To quit, type 'q' and press ENTER." << endl;
            break;
        }
    }
    return 0;
}
