#include "user.h"

User::User(unsigned arg_id, string arg_name, string arg_username, string arg_password, unsigned arg_num_accounts) {
    id = arg_id;
    name = arg_name;
    username = arg_username;
    password = arg_password;
    num_accounts = arg_num_accounts;
}

void User::createAccount(unsigned short arg_id, string arg_name, double arg_coef, double arg_balance) {
    Account account(arg_id, arg_name, arg_coef, arg_balance);
    accounts.emplace_back(account);
}

bool User::login(string arg_username, string arg_password) {
    if (username == arg_username && password == arg_password) {
        return true;
    }
    return false;
}

void User::read_accounts(string file) {
    ifstream accounts_reader;
    accounts_reader.open(file);
    if (!accounts_reader.is_open()) {
        cerr << "Error: Unable to open the accounts file." << endl;
        exit(EXIT_FAILURE);
    }
    vector <Account> accounts;
    string line;
    while (getline(accounts_reader, line)) {
        if (line == User::username) {
            break;  // Found where to start reading
        }
    }
    for (size_t i = 0; i < num_accounts; i++) {  // Read the accounts
        string name;
        double coef;
        double balance;
        accounts_reader >> name;
        accounts_reader >> coef;
        accounts_reader >> balance;
        Account account(i, name, coef, balance);
        accounts.emplace_back(account); // Construct a new account with the ID = i and append it to the vector
    }
    accounts_reader.close();
    User::accounts = accounts;
}

void User::display_accounts() {
    double total = 0.0;
    for (size_t i = 0; i < num_accounts; i++) {
        total += accounts[i].get_balance();
        accounts[i].display();
    }
    cout << "Total balance: " << total << endl;
}

void User::income(double sum) {
    for (size_t i = 0; i < num_accounts; i++) {
        accounts[i].shared_income(sum);
    }
}

string User::get_account_name(unsigned short id) {
    return accounts[id].get_name();
}

void User::withdrawal_from(unsigned  short id, double sum) {
    accounts[id].withdrawal(sum);
}