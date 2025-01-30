#include "mainwindow.h"
#include <QApplication>

#include <ctime>
#include <cstring>

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
    }
    curr_user.add_account(curr_user.num_accounts, name, coefficient, 0.0, accounts_file, users_file);
}

// int app() {
//     string name;
//     cin >> name;
//     user_finder_pair result = user_found(name, users);  // Used to not call user_found() twice
//     if (result.found) {
//         size_t found_user_index = result.index;
//         cout << "Trying to authenticate as " << name << "...\n";
//         if (auth(name, users)) {
//             curr_user = users[found_user_index];
//         } else {
//             cout << "Authentication failed." << "\n";
//             exit(EXIT_FAILURE);
//         }
//     } else {
//         cout << "User not found." << "\n";
//         exit(EXIT_FAILURE);
//     }
//     // User set. Now we can do stuff
//     curr_user.read_accounts("./resources/accounts.txt");
//     while (true) {
//         curr_user.display_accounts(); // Display all accounts, building the total
//         cout << "What do you want to do?\n";
//         cout << "1 - Income\n";
//         cout << "2 - Withdrawal\n";
//         cout << "c - change user\n";
//         cout << "n - new account\n";
//         cout << "q - quit\n";
//         char op;
//         cin >> op;

//         switch (op) {
//         case '1': {
//             cout << "Sum: ";
//             double sum;
//             cin >> sum;
//             curr_user.income(sum);
//             curr_user.update_accounts("./resources/accounts.txt");
//             break;
//         }
//         case '2': {
//             handle_withdrawal(curr_user);
//             break;
//         }
//         case 'c': {
//             cout << "Name: ";
//             string new_name;
//             cin >> new_name;
//             user_finder_pair result = user_found(new_name, users);
//             if (result.found) {
//                 size_t found_user_index = result.index;
//                 cout << "Trying to authenticate as " << new_name << "...\n";
//                 if (auth(new_name, users)) {
//                     curr_user = users[found_user_index];
//                     curr_user.read_accounts("./resources/accounts.txt");
//                 } else {
//                     cout << "Authentication failed." << "\n";
//                     exit(EXIT_FAILURE);
//                 }
//             } else {
//                 cout << "User not found." << "\n";
//                 exit(EXIT_FAILURE);
//             }
//             break;
//         }
//         case 'n': {
//             handle_new_account(curr_user, "./resources/accounts.txt", "./resources/users.txt");
//             break;
//         }
//         case 'q': {
//             cout << "Goodbye!\n";
//             exit(0);
//         }
//         default: {
//             cout << "Invalid operation. Try again.\n" << "To quit, type 'q' and press ENTER.\n";
//             break;
//         }
//         }
//     }
//     return 0;
// }

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
