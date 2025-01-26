#pragma once
#include "account.h"
#include <vector>
#include <fstream>
#include <sstream>

#include <ctime>
#include <iomanip>
#include <chrono>

#define INCOME 0
#define WITHDRAWAL 1
#define LOG_FILE "./resources/log.txt"

class User {
private:
    unsigned id;
    string username;
    string password;
    vector<Account> accounts;
public:
    string name;
    unsigned num_accounts;
    User() {};  // Dummy constructor. Does nothing but is set as default
    // Real constructor
    User(unsigned arg_id, string arg_name, string arg_username, string arg_password, unsigned arg_num_accounts);
    bool login(string arg_username, string arg_password);
    void read_accounts(string file);  // Get the accounts from a file
    void display_accounts();  // Get the accounts from the user object
    void income(double sum);
    string get_account_name(unsigned short id);
    double get_account_coefficient(unsigned short id);
    void withdrawal_from(unsigned  short id, double sum);
    void update_users(string file);
    void update_accounts(string file, bool new_account = false);  // When called with true, adds a new line and prevents overwriting
    void add_account(unsigned short arg_id, string arg_name, double arg_coef, double arg_balance,
        string accounts_file, string users_file);
    void log_op(int operation, unsigned short acc_id, double sum, string log_file);
};