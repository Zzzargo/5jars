#include "user.h"
#include <ctime>
#include <cstring>

typedef struct user_finder_pair {  // Used for the finder function
    bool found;
    size_t index;
} user_finder_pair;

vector <User> read_users(string filename) {
    ifstream users_reader;
    users_reader.open(filename);
    if (!users_reader.is_open()) {
        cerr << "Error: Unable to open the users file." << endl;
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
                cout << "Welcome, " << name << "!" << endl;
                return true;
            } else {
                cout << "Incorrect username or password." << endl;
            }
        }
    }
    return false;
}

int main(int argc, char *argv[]) {
    if (argc == 1) {  // Need to register or log in
        cout << "Welcome, guest!" << endl;
    } else {
        if (argc != 2) {
            cerr << "Usage: " << argv[0] << " <user> or " << argv[0] << " to enter guest mode" << endl;
            exit(EXIT_FAILURE);
        }
        vector <User> users = read_users("./resources/users.txt");
        User curr_user;
        user_finder_pair result = user_found(argv[1], users);  // Used to not call user_found() twice
        if (result.found) {
            size_t found_user_index = result.index;
            cout << "Trying to authenticate as " << argv[1] << endl;
            if (auth(argv[1], users)) {
                curr_user = users[found_user_index];
            } else {
                cout << "Authentication failed." << endl;
                exit(EXIT_FAILURE);
            }
        } else {
            cout << "User not found." << endl;
            exit(EXIT_FAILURE);
        }
        // User set. Now we can do stuff
        curr_user.read_accounts("./resources/accounts.txt");
        while (true) {
            double total = 0.0;
            curr_user.display_accounts(); // Display all accounts, building the total
            cout << "What do you want to do?" << endl;
            cout << "1 - Income" << endl;
            cout << "2 - Withdrawal" << endl;
            cout << "q - quit" << endl;
            char op;
            cin >> op;
            cout << endl;

            double sum;  // We'll need this for everything

            switch (op) {
                case '1': {
                    cout << "Sum: ";
                    cin >> sum;
                    for (size_t i = 0; i < curr_user.num_accounts; i++) {
                        curr_user.income(sum);
                    }
                    total += sum;
                    break;
                }
                case '2': {
                    cout << "Which account do you want to withdraw from?" << endl;
                    for (size_t i = 0; i < curr_user.num_accounts; i++) {
                        cout << i << " - " << curr_user.get_account_name(i) << endl; // Get accounts by their ID
                    }

                    unsigned short choice;
                    cin >> choice;
                    cout << "How much would you like to withdraw from " << curr_user.get_account_name(choice) << " ? ";
                    cin >> sum;
                    curr_user.withdrawal_from(choice, sum);
                    break;
                }
                case 'q': {
                    cout << "Goodbye!";
                    exit(0);
                }
                default: {
                    cout << "Invalid operation. Try again." << endl << "To quit, type 'q' and press ENTER." << endl;
                    break;
                }
            }
        }
    }
    return 0;
}