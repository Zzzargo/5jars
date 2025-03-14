#include "account.h"

Account::Account (unsigned short arg_id, QString arg_name, double arg_coef, double arg_balance) {
    id = arg_id;
    name = arg_name;
    coef = arg_coef;
    balance = arg_balance;
}

QListWidgetItem* Account::to_list_item() const {
    return new QListWidgetItem(name + " - " + QString::number(balance));
}

void Account::deposit(double sum, bool shared) {
    QSqlDatabase db = QSqlDatabase::database(); // Get the existing connection
    if (!db.isOpen()) {
        qDebug() << "Database not open!";
        return;
    }
    QSqlQuery query;
    if (shared) {
        balance += sum * coef;
    } else {
        balance += sum;
    }
    query.prepare("UPDATE accounts SET balance = :new_balance WHERE id = :acc_id");
    query.bindValue(":new_balance", balance);
    query.bindValue(":acc_id", id);
    if (!query.exec()) {
        qDebug() << "Error executing query:" << query.lastError();
        return;
    }
    qDebug() << "Income success";
}

void Account::withdrawal(unsigned acc_id, double sum) {
    if (acc_id == id) {
        balance -= sum;
        QSqlDatabase db = QSqlDatabase::database(); // Get the existing connection
        if (!db.isOpen()) {
            qDebug() << "Database not open!";
            return;
        }
        QSqlQuery query;
        query.prepare("UPDATE accounts SET balance = :new_balance WHERE id = :acc_id");
        query.bindValue(":new_balance", balance);
        query.bindValue("acc_id", acc_id);
        if (!query.exec()) {
            qDebug() << "Error executing query:" << query.lastError();
            return;
        }
        qDebug() << "Withdrawal success";
    }
}
