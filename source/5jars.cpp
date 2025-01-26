#include "user.h"
#include <cstring>

#define USERS_FILE "./resources/users.txt"
#define ACCOUNTS_FILE "./resources/accounts.txt"

typedef struct user_finder_pair {  // Used for the finder function
    bool found;
    size_t index;
} user_finder_pair;

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
    curr_user.update_accounts("./resources/accounts.txt");
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