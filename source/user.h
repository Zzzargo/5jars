#pragma once
#include "account.h"
#include <vector>
#include <string.h>
#include <fstream>
#include <sstream>
#include <iomanip>

#define INCOME 0
#define WITHDRAWAL 1
#define LOG_FILE "/home/zargo/.custom/5jars/log.txt"

class User {
private:
    unsigned id;
    QString username;
    QString password;
    vector<Account> accounts;
public:
    QString nickname;
    unsigned num_accounts;

    User(unsigned arg_id, QString arg_nickname, QString arg_username, QString arg_password, unsigned arg_num_accounts);

    void get_accounts();
    void populate_accounts_list(QListWidget *list);

    // Operations
    void income(double sum);
    void withdrawal_from(unsigned acc_id, double sum);
    void log_op(int operation, string acc_name, double sum, string log_file);
};
