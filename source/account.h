#pragma once
#include <iostream>
using namespace std;
#include <QDebug>

class Account {
private:
    string name;
    string owner;
    unsigned short id;
    double coef;
    double balance;

public:
    Account (unsigned short arg_id, string arg_name, string arg_owner, double arg_coef, double arg_balance);
    double get_coef();
    double get_balance();
    string get_name();
    string get_owner();

    void shared_income(double sum);
    void deposit(double sum);
    void withdrawal(double sum);
};
