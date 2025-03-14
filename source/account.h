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
    unsigned id;
    double coef;
    double balance;

public:
    Account (unsigned short arg_id, QString arg_name, double arg_coef, double arg_balance);

    QListWidgetItem* to_list_item() const;

    void deposit(double sum, bool shared = false);
    void withdrawal(unsigned acc_id, double sum);
};
