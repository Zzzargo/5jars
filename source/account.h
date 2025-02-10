#pragma once
#include <iostream>
using namespace std;

#include <QDebug>
#include <QListWidget>
// Upgrades, people. Upgrades.
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>

class Account {
private:
    QString name;
    unsigned short id;
    double coef;
    double balance;

public:
    Account (unsigned short arg_id, QString arg_name, double arg_coef, double arg_balance);
    QListWidgetItem* to_list_item() const;
    double get_coef();
    double get_balance();
    string get_name();
    string get_owner();

    void deposit(double sum, bool shared = false);
    void withdrawal(double sum);
};
