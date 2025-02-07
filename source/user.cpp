#include "user.h"

User::User(unsigned arg_id, string arg_nickname, string arg_username, string arg_password, unsigned arg_num_accounts) {
    id = arg_id;
    nickname = arg_nickname;
    username = arg_username;
    password = arg_password;
    num_accounts = arg_num_accounts;
}

bool User::user_finder(string arg_username) {
    if (arg_username == username) {
        return true;
    }
    return false;
}

bool User::login(string arg_username, string arg_password) {
    if (username == arg_username && password == arg_password) {
        return true;
    }
    return false;
}

void User::read_accounts(string file) {
    locale::global(locale("C"));  // Force C locale cuz comma
    ifstream accounts_reader;
    accounts_reader.open(file);
    if (!accounts_reader.is_open()) {
        cerr << "Error: Unable to open the accounts file." << endl;
        exit(EXIT_FAILURE);
    }
    string line;
    while (getline(accounts_reader, line)) {
        stringstream ss(line);
        unsigned acc_id;
        string word, acc_name, acc_owner;
        double coef, balance;
        size_t i = 1;
        while (getline(ss, word, ':')) {
            switch (i) {
                case 1: {
                    acc_id = stoi(word);
                    break;
                }
                case 2: {
                    acc_name = word;
                    break;
                }
                case 3: {
                    acc_owner = word;
                    break;
                }
                case 4: {
                    coef = stod(word);
                    break;
                }
                case 5: {
                    balance = stod(word);
                    // Data for an account has been read
                    if (acc_owner != username) {
                        i = 0;
                        continue;  // Account doesn't belong to this user
                    }
                    Account acc(acc_id, acc_name, acc_owner, coef, balance);
                    accounts.emplace_back(acc);
                    i = 1;
                    break;
                }
            }
            i++;
        }
    }
    accounts_reader.close();
}

Account* User::find_account(string name) {
    Account *acc = NULL;
    for (size_t i = 0; i < num_accounts; i++) {
        if (name == accounts[i].get_name()) {
            acc = &(accounts[i]);  // Found
        }
    }
    return acc;
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

vector <string> User::get_accounts_data() {
    vector <string> accounts_data;
    for (size_t i = 0; i < num_accounts; i++) {
        string line = "";
        line.append(accounts[i].get_name() + ": " + to_string(accounts[i].get_balance()));
        accounts_data.emplace_back(line);
    }
    return accounts_data;
}

void User::withdrawal_from(string name, double sum) {
    for (size_t i = 0; i < num_accounts; i++) {
        if (name.compare(accounts[i].get_name()) == 0) {
            accounts[i].withdrawal(sum);
        }
    }
}

void User::update_accounts(string file, bool new_account) {
    locale::global(locale("C"));  // Force C locale
    ifstream accounts_reader;
    vector <string> lines;
    accounts_reader.open(file);
    if (!accounts_reader.is_open()) {
        cerr << "Error: Unable to open the accounts file for reading.\n";
        exit(EXIT_FAILURE);
    }
    string line;
    while (getline(accounts_reader, line)) {
        stringstream ss(line);
        string word, acc_name, acc_owner;
        unsigned acc_id;
        double acc_coef, acc_balance;
        for (size_t i = 0; i < 5; i++) {
            getline(ss, word, ':');
            switch (i) {
                case 0: {
                    acc_id = stoi(word);
                    break;
                }
                case 1: {
                    acc_name = word;
                    break;
                }
                case 2: {
                    acc_owner = word;
                    break;
                }
                case 3: {
                    acc_coef = stod(word);
                    break;
                }
                case 4: {
                    acc_balance = stod(word);
                    break;
                }
            }
        }
        if (acc_owner == username) {
            // Write modified line
            Account *acc = find_account(acc_name);
            line = to_string(acc_id) + ":" + acc->get_name() + ":" + acc_owner + ":" +
                   to_string(acc->get_coef()) + ":" + to_string(acc->get_balance());
        }
        lines.emplace_back(line);
    }

    // Write the updated lines to the file
    ofstream accounts_writer;
    accounts_writer.open(file);
    if (!accounts_writer.is_open()) {
        cerr << "Error: Unable to open the accounts file for writing.\n";
        exit(EXIT_FAILURE);
    }
    for (size_t i = 0; i < lines.size(); i++) {
        accounts_writer << lines[i] << "\n";
    }
    accounts_writer.close();
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
            log_writer << unix_timestamp_to_humanreadable(now) << " - " << nickname << " deposited " << sum << ".\n";
            break;
        }
        case WITHDRAWAL: {
            log_writer << unix_timestamp_to_humanreadable(now) << " - " << nickname << " withdrew " << sum << " from " << acc_name << ".\n";
            break;
        }
    }
    cout << "Logged." << endl;
    log_writer.close();
}
