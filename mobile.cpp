#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>
#include <cstring>
#include <ctime>
#include <iomanip>
#include <chrono>

#define INCOME 0
#define WITHDRAWAL 1
#define LOG_FILE "./log.txt"
#define USERS_FILE "./users.txt"
#define ACCOUNTS_FILE "./accounts.txt"

using namespace std;

typedef struct user_finder_pair {  // Used for the finder function
    bool found;
    size_t index;
} user_finder_pair;


class Account {
private:
    string name;
    unsigned short id;
    double coef;
    double balance;

public:
    Account (unsigned short arg_id, string arg_name, double arg_coef, double arg_balance) {
        id = arg_id;
        name = arg_name;
        coef = arg_coef;
        balance = arg_balance;
    }
    void display() {
        cout << name << ": " << balance << endl;
    }
    unsigned short get_id() {
        return id;
    }
    double get_coef() {
        return coef;
    }
    double get_balance() {
        return balance;
    }
    string get_name() {
        return name;
    }
    void shared_income(double sum) {
        balance += sum * coef;
    }
    void deposit(double sum) {
        balance += sum;
    }
    void withdrawal(double sum) {
        balance -= sum;
    }
};

class User {
private:
    unsigned id;
    string username;
    string password;
    vector<Account> accounts;
public:
    string name;
    unsigned num_accounts;
    User() {};  // Dummy constructor. Does nothing but is set as default
    // Real constructor
    User(unsigned arg_id, string arg_name, string arg_username, string arg_password, unsigned arg_num_accounts) {
        id = arg_id;
        name = arg_name;
        username = arg_username;
        password = arg_password;
        num_accounts = arg_num_accounts;
    }
    bool login(string arg_username, string arg_password) {
        if (username == arg_username && password == arg_password) {
        return true;
        }
        return false;
    }

    void read_accounts(string file) {  // Get the accounts from a file
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

    void display_accounts() {  // Get the accounts from the user object
        double total = 0.0;
        for (size_t i = 0; i < num_accounts; i++) {
            total += accounts[i].get_balance();
            accounts[i].display();
        }
        cout << "Total balance: " << total << endl;
    }

    void income(double sum) {
        for (size_t i = 0; i < num_accounts; i++) {
            accounts[i].shared_income(sum);
        }
        log_op(INCOME, UINT16_MAX, sum, LOG_FILE);
    }
    string get_account_name(unsigned short id) {
        return accounts[id].get_name();
    }
    double get_account_coefficient(unsigned short id) {
        return accounts[id].get_coef();
    }

    void withdrawal_from(unsigned  short id, double sum) {
        accounts[id].withdrawal(sum);
        log_op(WITHDRAWAL, id, sum, LOG_FILE);
    }
    void update_users(string file) {
        ifstream users_reader;
        users_reader.open(file);
        if (!users_reader.is_open()) {
            cerr << "Error: Unable to open the users file for reading.\n";
            exit(EXIT_FAILURE);
        }

        vector <string> lines;
        string line;
        // Store the modified copty of the file in the lines vector
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

    void update_accounts(string file, bool new_account = false) {  // When called with true, adds a new line and prevents overwriting
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
                    // cout <<"REACHED. Line: " << line << "\n";
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

    void add_account(unsigned short arg_id, string arg_name, double arg_coef, double arg_balance,
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

    void log_op(int operation, unsigned short acc_id, double sum, string log_file) {
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
};


vector <User> read_users(string filename) {
    ifstream users_reader;
    users_reader.open(filename);
    if (!users_reader.is_open()) {
        cerr << "Error: Unable to open the users file." << "\n";
        exit(EXIT_FAILURE);
    }
    vector <User> users;
    string line;
    while (getline(users_reader, line)) {
        stringstream ss(line);
        string name, username, password;
        unsigned short num_accounts;
        getline(ss, name, ' ');
        getline(ss, username, ' ');
        getline(ss, password, ' ');
        ss >> num_accounts;
        User user(users.size(), name, username, password, num_accounts);
        users.emplace_back(user);
    }
    users_reader.close();
    return users;
}

// Returns true if the user was found, along with the index of the user in the vector
user_finder_pair user_found(string name, vector <User> &users) {
    for (size_t i = 0; i < users.size(); i++) {
        if (users[i].name == name) {
            return {true, i};
        }
    }
    return {false, 0};
}

bool auth(string name, vector <User> &users) {
    for (size_t i = 0; i < users.size(); i++) {
        if (users[i].name == name) {
            string username, password;
            cout << "Username: ";
            cin >> username;
            cout << "Password: ";
            cin >> password;
            if (users[i].login(username, password)) {
                cout << "Welcome, " << name << "!" << "\n";
                return true;
            } else {
                cout << "Incorrect username or password." << "\n";
            }
        }
    }
    return false;
}

void handle_withdrawal(User &curr_user) {
    cout << "Which account do you want to withdraw from?\n";
    for (size_t i = 0; i < curr_user.num_accounts; i++) {
        cout << i << " - " << curr_user.get_account_name(i) << "\n"; // Get accounts by their ID
    }

    unsigned short choice;
    cin >> choice;
    if (choice >= curr_user.num_accounts) {
        cout << "Invalid account.\n";
    }
    cout << "How much would you like to withdraw from " << curr_user.get_account_name(choice) << " ? ";
    double sum = 0.0;
    cin >> sum;
    curr_user.withdrawal_from(choice, sum);
    curr_user.update_accounts(ACCOUNTS_FILE);
}

void handle_new_account(User &curr_user, string accounts_file, string users_file) {
    string name;
    double coefficient = 0.0;
    cout << "New account name: ";
    cin >> name;
    cout << "New account coefficient: ";
    cin >> coefficient;
    double sum_of_other_coefficients = 0.0;
    for (size_t i = 0; i < curr_user.num_accounts; i++) {
        sum_of_other_coefficients += curr_user.get_account_coefficient(i);
    }
    if (sum_of_other_coefficients + coefficient > 1.0) {
        cout << "Sum of all accounts' coefficients is too big. Try again with a smaller coefficient.\n";
        return;
    }
    curr_user.add_account(curr_user.num_accounts, name, coefficient, 0.0, accounts_file, users_file);
}

int main() {
    cout << "Welcome!\nPlease enter your name or type 'register' to register a new user: ";
    string name;
    cin >> name;
    if (name == "register") {

    }
    vector <User> users = read_users(USERS_FILE);
    User curr_user;
    user_finder_pair result = user_found(name, users);  // Used to not call user_found() twice
    if (result.found) {
        size_t found_user_index = result.index;
        cout << "Trying to authenticate as " << name << "...\n";
        if (auth(name, users)) {
            curr_user = users[found_user_index];
        } else {
            cout << "Authentication failed." << "\n";
            exit(EXIT_FAILURE);
        }
    } else {
        cout << "User not found." << "\n";
        exit(EXIT_FAILURE);
    }
    // User set. Now we can do stuff
    curr_user.read_accounts(ACCOUNTS_FILE);
    while (true) {
        curr_user.display_accounts(); // Display all accounts, building the total
        cout << "What do you want to do?\n";
        cout << "1 - Income\n";
        cout << "2 - Withdrawal\n";
        cout << "c - change user\n";
        cout << "n - new account\n";
        cout << "q - quit\n";
        char op;
        cin >> op;

        switch (op) {
            case '1': {
                cout << "Sum: ";
                double sum;
                cin >> sum;
                curr_user.income(sum);
                curr_user.update_accounts(ACCOUNTS_FILE);
                break;
            }
            case '2': {
                handle_withdrawal(curr_user);
                break;
            }
            case 'c': {
                cout << "Name: ";
                string new_name;
                cin >> new_name;
                user_finder_pair result = user_found(new_name, users);
                if (result.found) {
                    size_t found_user_index = result.index;
                    cout << "Trying to authenticate as " << new_name << "...\n";
                    if (auth(new_name, users)) {
                        curr_user = users[found_user_index];
                        curr_user.read_accounts(ACCOUNTS_FILE);
                    } else {
                        cout << "Authentication failed." << "\n";
                        exit(EXIT_FAILURE);
                    }
                } else {
                    cout << "User not found." << "\n";
                    exit(EXIT_FAILURE);
                }
                break;
            }
            case 'n': {
                handle_new_account(curr_user, ACCOUNTS_FILE, USERS_FILE);
                break;
            }
            case 'q': {
                cout << "Goodbye!\n";
                exit(0);
            }
            default: {
                cout << "Invalid operation. Try again.\n" << "To quit, type 'q' and press ENTER.\n";
                break;
            }
        }
    }
    return 0;
}