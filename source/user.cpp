#include "user.h"

User::User(unsigned arg_id, QString arg_nickname, QString arg_username, QString arg_password, unsigned arg_num_accounts) {
    id = arg_id;
    nickname = arg_nickname;
    username = arg_username;
    password = arg_password;
    num_accounts = arg_num_accounts;
}

/*      Adds the accounts to the user's accounts vector     */
void User::get_accounts() {
    accounts.clear();  // When the function is used to update
    QSqlQuery query;
    query.prepare("SELECT * FROM accounts WHERE owner_id = :uid");
    query.bindValue(":uid", id);  // Current user's id

    if (!query.exec()) {
        qDebug() << "Error executing query:" << query.lastError();
        return;
    }

    while (query.next()) {
        unsigned short acc_id = query.value("id").toInt();
        QString acc_name = query.value("name").toString();
        double acc_coef = query.value("coef").toDouble();
        double acc_balance = query.value("balance").toDouble();

        // Add the account to the user's accounts vector
        Account acc(acc_id, acc_name, acc_coef, acc_balance);
        accounts.emplace_back(acc);
        qDebug() << "Account fetched:" << acc_id << acc_name << acc_coef << acc_balance;
    }
}

void User::populate_accounts_list(QListWidget *list) {
    list->clear();  // If it's used to update
    for (size_t i = 0; i < num_accounts; i++) {
        list->addItem(accounts[i].to_list_item());
    }
}

void User::income(double sum) {
    for (size_t i = 0; i < num_accounts; i++) {
        accounts[i].deposit(sum, true);
    }
}

void User::withdrawal_from(unsigned acc_id, double sum) {
    for (size_t i = 0; i < num_accounts; i++) {
        accounts[i].withdrawal(acc_id, sum);
    }
}

string unix_timestamp_to_humanreadable(time_t timestamp) {
    tm *time = localtime(&timestamp);
    ostringstream oss;
    oss << put_time(time, "%Y/%m/%d %H:%M:%S");
    return oss.str();
}

void User::log_op(int operation, string acc_name, double sum, string log_file) {
    ofstream log_writer;
    log_writer.open(log_file, ios::app);
    if (!log_writer.is_open()) {
        cerr << "Error: Unable to open the log file for writing.\n";
        exit(EXIT_FAILURE);
    }
    time_t now = time(0);
    switch (operation) {
        case INCOME: {
            log_writer << unix_timestamp_to_humanreadable(now) << " - " << nickname.toStdString() << " deposited " << sum << ".\n";
            break;
        }
        case WITHDRAWAL: {
            log_writer << unix_timestamp_to_humanreadable(now) << " - " << nickname.toStdString() << " withdrew " << sum << " from " << acc_name << ".\n";
            break;
        }
    }
    qDebug() << "Logged.";
    log_writer.close();
}
