#include "user.h"

User::User(unsigned arg_id, string arg_username, string arg_password, unsigned arg_num_accounts) {
    id = arg_id;
    username = arg_username;
    password = arg_password;
    num_accounts = arg_num_accounts;
}

bool User::user_finder(string arg_username) {
    if (arg_username == username) {
        return true;
    }
    return false;
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

double User::get_account_coefficient(unsigned short id) {
    return accounts[id].get_coef();
}

double User::get_account_balance(unsigned short id) {
    return accounts[id].get_balance();
}

void User::withdrawal_from(unsigned  short id, double sum) {
    accounts[id].withdrawal(sum);
}

void User::update_accounts(string file) {
    fstream accounts_file;
    accounts_file.open(file);
    if (!accounts_file.is_open()) {
        cerr << "Error: Unable to open the accounts file." << endl;
        exit(EXIT_FAILURE);
    }
    string line;
    while (getline(accounts_file, line)) {
        if (line == User::username) {
            break;  // Found where to start writing
        }
    }
    for (size_t i = 0; i < num_accounts; i++) {  // Get the accounts
        accounts_file << accounts[i].get_name() << " " << accounts[i].get_coef() << " " << accounts[i].get_balance();
        accounts_file << endl;
    }
    accounts_file.close();
}

void User::add_account(unsigned short arg_id, string arg_name, double arg_coef, double arg_balance,
    string accounts_file, string users_file) {
    Account account(arg_id, arg_name, arg_coef, arg_balance);
    accounts.emplace_back(account);
    // Update the number of accounts in users file and add a new line in the accounts file
    
}
