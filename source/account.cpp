#include "account.h"

Account::Account (unsigned short arg_id, string arg_name, double arg_coef, double arg_balance) {
    name = arg_name;
    coef = arg_coef;
    balance = arg_balance;
}

void Account::display()
{
    cout << name << ": " << balance << endl;
}

double Account::get_coef() {
    return coef;
}

double Account::get_balance() {
    return balance;
}

string Account::get_name() {
    return name;
}

void Account::income(double sum) {
    balance += sum * coef;
    cout << "OPERATION SUCCESSFUL" << endl;
}

void Account::withdrawal(double sum)
{
    balance -= sum;
    cout << "OPERATION SUCCESSFUL" << endl;
}
