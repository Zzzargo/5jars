#include "user.h"

User::User(unsigned arg_id, string arg_name, string arg_username, string arg_password, unsigned arg_num_accounts) {
    id = arg_id;
    name = arg_name;
    username = arg_username;
    password = arg_password;
    num_accounts = arg_num_accounts;
}

bool User::login(string arg_username, string arg_password) {
    if (username == arg_username && password == arg_password) {
        return true;
    }
    return false;
}

void User::read_accounts(string file) {
    ifstream accounts_reader;
    accounts_reader.open(file);
    if (!accounts_reader.is_open()) {
        cerr << "Error: Unable to open the accounts file." << endl;
        exit(EXIT_FAILURE);
    }
    vector <Account> accounts;
    string line;
    while (getline(accounts_reader, line)) {
        if (line == User::username) {
            break;  // Found where to start reading
        }
    }
    for (size_t i = 0; i < num_accounts; i++) {  // Read the accounts
        string name;
        double coef;
        double balance;
        accounts_reader >> name;
        accounts_reader >> coef;
        accounts_reader >> balance;
        Account account(i, name, coef, balance);
        accounts.emplace_back(account); // Construct a new account with the ID = i and append it to the vector
    }
    accounts_reader.close();
    User::accounts = accounts;
}

void User::display_accounts() {
    double total = 0.0;
    for (size_t i = 0; i < num_accounts; i++) {
        total += accounts[i].get_balance();
        accounts[i].display();
    }
    cout << "Total balance: " << total << endl;
}

void User::income(double sum) {
    for (size_t i = 0; i < num_accounts; i++) {
        accounts[i].shared_income(sum);
    }
    log_op(INCOME, UINT16_MAX, sum, LOG_FILE);
}

string User::get_account_name(unsigned short id) {
    return accounts[id].get_name();
}

double User::get_account_coefficient(unsigned short id) {
    return accounts[id].get_coef();
}

void User::withdrawal_from(unsigned  short id, double sum) {
    accounts[id].withdrawal(sum);
    log_op(WITHDRAWAL, id, sum, LOG_FILE);
}

void User::update_accounts(string file, bool new_account) {
    ifstream accounts_reader;
    vector <string> lines;
    accounts_reader.open(file);
    if (!accounts_reader.is_open()) {
        cerr << "Error: Unable to open the accounts file for reading.\n";
        exit(EXIT_FAILURE);
    }
    size_t i, j = 0;
    string line;
    for (i = 0; getline(accounts_reader, line); i++) {
        lines.emplace_back(line);
        if (lines[i] == username) {  // Found where to start updating
            break;
        }
    }

    while (j < num_accounts) {  // For each account of the respective user
        // Write updated data to the lines vector
        line = accounts[j].get_name() + " " + to_string(accounts[j].get_coef()) + " " +
        to_string(accounts[j].get_balance());
        lines.emplace_back(line);

        getline(accounts_reader, line);  // Skip file lines we are updating
        if (new_account && j == num_accounts - 1) {
            // Case where we prevent incorrectly overwriting a line that had data of another user
            // Copy the line that had data of another user into the lines vector
            // If we've reached the end of file prevent doubling the endline character
            if (line != "\n" && line != "" && line != "\r") {
                cout <<"REACHED. Line: " << line << "\n";
                lines.emplace_back(line);
            }
        }
        j++;
    }
    // Read the rest of the file and append it to the lines vector
    while(getline(accounts_reader, line)) {
        lines.emplace_back(line);
    }
    accounts_reader.close();

    // Write the updated lines to the file
    ofstream accounts_writer;
    accounts_writer.open(file);
    if (!accounts_writer.is_open()) {
        cerr << "Error: Unable to open the accounts file for writing.\n";
        exit(EXIT_FAILURE);
    }
    for (i = 0; i < lines.size(); i++) {
        accounts_writer << lines[i] << "\n";
    }
    accounts_writer.close();
}

void User::update_users(string file) {
    ifstream users_reader;
    users_reader.open(file);
    if (!users_reader.is_open()) {
        cerr << "Error: Unable to open the users file for reading.\n";
        exit(EXIT_FAILURE);
    }

    vector <string> lines;
    string line;
    // Store the modified copy of the file in the lines vector
    while (getline(users_reader, line)) {
        if (line.find(username) != string::npos) {
            lines.emplace_back(name + " " + username + " " + password + " " + to_string(num_accounts));
        } else {
            lines.emplace_back(line);
        }
    }
    users_reader.close();
    // Copy the lines vector to the file
    ofstream users_writer;
    users_writer.open(file);
    if (!users_writer.is_open()) {
        cerr << "Error: Unable to open the users file for writing.\n";
        exit(EXIT_FAILURE);
    }
    for (size_t i = 0; i < lines.size(); i++) {
        users_writer << lines[i] << "\n";
    }
    users_writer.close();
}

void User::add_account(unsigned short arg_id, string arg_name, double arg_coef, double arg_balance,
    string accounts_file_path, string users_file_path) {
    Account account(arg_id, arg_name, arg_coef, arg_balance);
    accounts.emplace_back(account);
    num_accounts++;
    // Update the accounts file
    update_accounts(accounts_file_path, true);
    // Update the users file
    update_users(users_file_path);
}

string unix_timestamp_to_humanreadable(time_t timestamp) {
    tm *time = localtime(&timestamp);
    ostringstream oss;
    oss << put_time(time, "%Y/%m/%d %H:%M:%S");
    return oss.str();
}

void User::log_op(int operation, unsigned short acc_id, double sum, string log_file) {
    ofstream log_writer;
    log_writer.open(log_file, ios::app);
    if (!log_writer.is_open()) {
        cerr << "Error: Unable to open the log file for writing.\n";
        exit(EXIT_FAILURE);
    }
    time_t now = time(0);
    switch (operation) {
        case INCOME: {
            log_writer << unix_timestamp_to_humanreadable(now) << " - " << name << " deposited " << sum << ".\n";
            break;
        }
        case WITHDRAWAL: {
            for (size_t i = 0; i < num_accounts; i++) {
                if (accounts[i].get_id() == acc_id) {
                    log_writer << unix_timestamp_to_humanreadable(now) << " - " << name << " withdrew " << sum << " from " << accounts[i].get_name() << ".\n";
                    break;
                }
            }
        }
    }
}