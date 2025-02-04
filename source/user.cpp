#include "user.h"

User::User(unsigned arg_id, string arg_username, string arg_password, unsigned arg_num_accounts) {
    id = arg_id;
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

Account* User::find_account(string name) {
    Account *acc = NULL;
    for (size_t i = 0; i < num_accounts; i++) {
        if (name == accounts[i].get_name()) {
            acc = &(accounts[i]);  // Found
        }
    }
    return acc;
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

void User::income(double sum) {
    for (size_t i = 0; i < num_accounts; i++) {
        accounts[i].shared_income(sum);
    }
}

string User::get_account_data(unsigned idx) {
    return accounts[idx].get_name() + ": " + to_string(accounts[idx].get_balance());
}

void User::withdrawal_from(string name, double sum) {
    for (size_t i = 0; i < num_accounts; i++) {
        if (name.compare(accounts[i].get_name()) == 0) {
            accounts[i].withdrawal(sum);
        }
    }
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
            lines.emplace_back(username + " " + password + " " + to_string(num_accounts));
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

        ostringstream oss;
        oss.imbue(locale("C"));  // Force the C locale (dot as separator for floats)
        oss << fixed << setprecision(2)
            << accounts[j].get_name() << " "
            << accounts[j].get_coef() << " "
            << accounts[j].get_balance();

        lines.emplace_back(oss.str());

        // line = accounts[j].get_name() + " " + to_string(accounts[j].get_coef()) + " " +
        //        to_string(accounts[j].get_balance());
        // lines.emplace_back(line);

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
