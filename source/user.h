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
    QString username;
    QString password;
    vector<Account> accounts;
public:
    QString nickname;
    unsigned num_accounts;

    User() {};  // Dummy constructor. Does nothing but is set as default
    // Real constructor
    User(unsigned arg_id, QString arg_nickname, QString arg_username, QString arg_password, unsigned arg_num_accounts);

    void get_accounts();
    void populate_accounts_list(QListWidget *list);

    // Operations
    void income(double sum);
    void withdrawal_from(string name, double sum);
    void log_op(int operation, string acc_name, double sum, string log_file);

    // void add_account(unsigned short arg_id, string arg_name, double arg_coef, double arg_balance,
    //     string accounts_file, string users_file);
};
