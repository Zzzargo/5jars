#pragma once
#include "account.h"
#include <vector>
#include <string.h>
#include <fstream>
#include <sstream>
#include <iomanip>

#define INCOME 0
#define WITHDRAWAL 1
#define USERS_FILE "../../resources/users.txt"
#define ACCOUNTS_FILE "../../resources/accounts.txt"
#define LOG_FILE "../../resources/log.txt"

class User {
private:
    unsigned id;
    string username;
    string password;
    vector<Account> accounts;
public:
    string nickname;
    unsigned num_accounts;

    User() {};  // Dummy constructor. Does nothing but is set as default
    // Real constructor
    User(unsigned arg_id, string arg_nickname, string arg_username, string arg_password, unsigned arg_num_accounts);

    // Auth methods
    bool user_finder(string arg_username);  // Used to check if a user with the given name exists
    bool login(string arg_username, string arg_password);
    void read_accounts(string file);  // Get the accounts from a file
    Account* find_account(string name);  // Returns a pointer to an account which has given name

    vector <string> get_accounts_data();

    // Operations
    void income(double sum);
    void withdrawal_from(string name, double sum);
    void log_op(int operation, string acc_name, double sum, string log_file);

    void update_accounts(string file, bool new_account = false);
    // void add_account(unsigned short arg_id, string arg_name, double arg_coef, double arg_balance,
    //     string accounts_file, string users_file);
};
