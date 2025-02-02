#pragma once
#include "account.h"
#include <vector>
#include <fstream>
#include <sstream>
#include <iomanip>

class User {
private:
    unsigned id;
    string username;
    string password;
    vector<Account> accounts;
public:
    unsigned num_accounts;
    User() {};  // Dummy constructor. Does nothing but is set as default
    // Real constructor
    User(unsigned arg_id, string arg_username, string arg_password, unsigned arg_num_accounts);

    bool user_finder(string arg_username);  // Used to find the user in a file
    bool login(string arg_username, string arg_password);
    void read_accounts(string file);  // Get the accounts from a file
    void display_accounts();  // Get the accounts from the user object

    string get_username(); // Used on the dashboard
    string get_account_name(unsigned short id);
    double get_account_coefficient(unsigned short id);
    double get_account_balance(unsigned short id);

    // Operations
    void income(double sum);
    void withdrawal_from(unsigned  short id, double sum);

    void update_accounts(string file, bool new_account = false);
    void add_account(unsigned short arg_id, string arg_name, double arg_coef, double arg_balance,
        string accounts_file, string users_file);
};
