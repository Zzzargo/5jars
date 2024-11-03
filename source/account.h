#pragma once
#include <iostream>
#include <fstream>
#include <vector>
#include <ctime>

using namespace std;

class Account
{
private:
    unsigned short id;
    string name;
    double coef;
    double balance;

public:
    Account (unsigned short arg_id, string arg_name, double arg_coef, double arg_balance);
    void display();
    double get_coef();
    double get_balance();
    string get_name();
    void income(double sum);
    void withdrawal(double sum);
};