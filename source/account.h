#pragma once
#include <iostream>
using namespace std;

class Account {
private:
    string name;
    unsigned short id;
    double coef;
    double balance;

public:
    Account (unsigned short arg_id, string arg_name, double arg_coef, double arg_balance);
    void display();
    double get_coef();
    double get_balance();
    string get_name();
    void shared_income(double sum);
    void deposit(double sum);
    void withdrawal(double sum);
};