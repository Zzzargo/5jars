#include "account.h"

Account::Account (unsigned short arg_id, string arg_name, double arg_coef, double arg_balance) {
    id = arg_id;
    name = arg_name;
    coef = arg_coef;
    balance = arg_balance;
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

void Account::shared_income(double sum) {
    balance += sum * coef;
    cout << "OPERATION SUCCESSFUL" << endl;
}

void Account::deposit(double sum) {
    balance += sum;
    cout << "OPERATION SUCCESSFUL" << endl;
}

void Account::withdrawal(double sum) {
    balance -= sum;
    cout << "OPERATION SUCCESSFUL" << endl;
}
