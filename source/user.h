#pragma once
#include "account.h"
#include <vector>
#include <string.h>
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

    // Auth methods
    bool user_finder(string arg_username);  // Used to check if a user with the given name exists
    bool login(string arg_username, string arg_password);
    void read_accounts(string file);  // Get the accounts from a file
    Account* find_account(string name);  // Returns a pointer to an account which has given name

    string get_account_data(unsigned idx);

    // Operations
    void income(double sum);
    void withdrawal_from(string name, double sum);

    void update_accounts(string file, bool new_account = false);
    void update_users(string file);
    void add_account(unsigned short arg_id, string arg_name, double arg_coef, double arg_balance,
        string accounts_file, string users_file);
};
