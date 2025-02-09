#include "user.h"

User::User(unsigned arg_id, QString arg_nickname, QString arg_username, QString arg_password, unsigned arg_num_accounts) {
    id = arg_id;
    nickname = arg_nickname;
    username = arg_username;
    password = arg_password;
    num_accounts = arg_num_accounts;
}

/*      Adds the accounts to the user's accounts vector
        and the QListWidget
*/
void User::get_accounts() {
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
    for (size_t i = 0; i < num_accounts; i++) {
        list->addItem(accounts[i].to_list_item());
    }
}

// void User::add_account(unsigned short arg_id, string arg_name, double arg_coef, double arg_balance,
//     string accounts_file_path, string users_file_path) {
//     Account account(arg_id, arg_name, arg_coef, arg_balance);
//     accounts.emplace_back(account);
//     num_accounts++;
//     // Update the accounts file
//     update_accounts(accounts_file_path, true);
//     // Update the users file
//     update_users(users_file_path);
// }

void User::income(double sum) {
    for (size_t i = 0; i < num_accounts; i++) {
        accounts[i].shared_income(sum);
    }
}

void User::withdrawal_from(string name, double sum) {
    for (size_t i = 0; i < num_accounts; i++) {
        if (name.compare(accounts[i].get_name()) == 0) {
            accounts[i].withdrawal(sum);
        }
    }
}

string unix_timestamp_to_humanreadable(time_t timestamp) {
    tm *time = localtime(&timestamp);
    ostringstream oss;
    oss << put_time(time, "%Y/%m/%d %H:%M:%S");
    return oss.str();
}

// void User::log_op(int operation, string acc_name, double sum, string log_file) {
//     ofstream log_writer;
//     log_writer.open(log_file, ios::app);
//     if (!log_writer.is_open()) {
//         cerr << "Error: Unable to open the log file for writing.\n";
//         exit(EXIT_FAILURE);
//     }
//     time_t now = time(0);
//     switch (operation) {
//         case INCOME: {
//             log_writer << unix_timestamp_to_humanreadable(now) << " - " << nickname << " deposited " << sum << ".\n";
//             break;
//         }
//         case WITHDRAWAL: {
//             log_writer << unix_timestamp_to_humanreadable(now) << " - " << nickname << " withdrew " << sum << " from " << acc_name << ".\n";
//             break;
//         }
//     }
//     cout << "Logged." << endl;
//     log_writer.close();
// }
