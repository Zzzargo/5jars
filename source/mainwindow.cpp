#include "mainwindow.h"
#include "./ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow) {  // Create the UI object
    ui->setupUi(this);        // Load the UI from mainwindow.ui

    // Read the users before all
    users = read_users("../../resources/users.txt");
    // Ensure that the login page is shown first
    ui->stackedWidget->setCurrentIndex(0);
    // Make the password field hidden
    ui->line_password->setEchoMode(QLineEdit::Password);
    // Hide the menu (it's used just for the dashboard)
    ui->menubar->hide();
}

MainWindow::~MainWindow() {
    delete ui;
}

vector <User> MainWindow::read_users(string filename) {
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
        string username, password;
        unsigned short num_accounts;
        getline(ss, username, ' ');
        getline(ss, password, ' ');
        ss >> num_accounts;
        User user(users.size(), username, password, num_accounts);
        users.emplace_back(user);
    }
    users_reader.close();
    return users;
}

bool MainWindow::auth(string username, string password, vector <User> &users, unsigned user_index) {
    if (users[user_index].login(username, password)) {
        curr_user = &(users[user_index]);
        return true;
    }
    return false;
}

void MainWindow::populate_accounts_list() {
    ui->accounts_list->clear();  // Make sure it's empty first
    for (size_t i = 0; i < curr_user->num_accounts; i++) {
        QString account_info = QString::fromStdString(curr_user->get_account_data(i));
        ui->accounts_list->addItem(account_info);
    }
}

void MainWindow::on_btn_login_clicked() {
    QString input_uname = ui->line_username->text();
    QString input_upass = ui->line_password->text();

    bool user_found = false;
    unsigned user_idx = -1;
    for (size_t i = 0; i < users.size(); i++) {
        if (users[i].user_finder(input_uname.toStdString())) {
            user_found = true;
            user_idx = i;
            break;
        }
    }
    if (!user_found) {
        ui->label_auth->setText("User not found");
    } else {
        if (auth(input_uname.toStdString(), input_upass.toStdString(), users, user_idx)) {
            ui->label_auth->setText("Authentication successful!");

            // Populate the current user's accounts vector
            curr_user->read_accounts("../../resources/accounts.txt");
            populate_accounts_list();

            // Setup the dashboard page
            ui->label_curruser->setText("Current user: " + input_uname);
            ui->label_income->hide();
            ui->income_sum->hide();
            ui->ok_income->hide();
            ui->progress_income->setValue(0);
            ui->progress_income->hide();
            ui->label_withdrawal1->hide();
            ui->withdrawal_sum->hide();
            ui->label_withdrawal2->hide();
            ui->withdrawal_source->hide();
            ui->ok_withdrawal->hide();
            ui->progress_withdrawal->setValue(0);
            ui->progress_withdrawal->hide();

            // Wait a second( literally :)) )
            QTimer::singleShot(1000, this, [this]() {
                ui->stackedWidget->setCurrentIndex(1);  // Set the widget to dashboard
                ui->menubar->show();  // Show menu
                // Reset the login page
                ui->line_password->clear();
                ui->line_username->clear();
                ui->label_auth->clear();
            });
        } else {
            ui->label_auth->setText("Username/password incorrect!");
        }
    }

}

void MainWindow::on_line_username_returnPressed() {
    on_btn_login_clicked();
}


void MainWindow::on_line_password_returnPressed() {
    on_btn_login_clicked();
}

void MainWindow::delete_account(QListWidgetItem *item) {
    cout << item->text().toStdString();
}

void MainWindow::on_accounts_list_itemDoubleClicked(QListWidgetItem *item) {
    // Create a context menu
    QMenu menu(this);

    // Create actions
    QAction *modifyAction = new QAction("Modify Account", &menu);
    QAction *deleteAction = new QAction("Delete Account", &menu);

    // Add actions to the menu
    menu.addAction(modifyAction);
    menu.addAction(deleteAction);

    // Connect actions to slots (functions)
    // connect(modifyAction, &QAction::triggered, this, [=]() {
    //     modifyAccount(item);
    // });

    connect(deleteAction, &QAction::triggered, this, [=]() {
        delete_account(item);
    });

    // Show the menu at the cursor position
    menu.exec(QCursor::pos());
}


void MainWindow::on_btn_logout_clicked() {
    curr_user = NULL;  // Reset the current user
    ui->accounts_list->clear();  // Clear the accounts list
    ui->stackedWidget->setCurrentIndex(0);  // Get to the login page
}

void MainWindow::on_btn_income_clicked() {
    // Show the fields
    ui->label_income->show();
    ui->income_sum->show();
    ui->ok_income->show();
}

void MainWindow::update_progress_bar(QProgressBar *bar, int &progressValue, QTimer *timer) {
    if (progressValue >= 100) {
        timer->stop();
        bar->hide();
        delete timer;  // Cleanup
        populate_accounts_list();  // Update the list
        curr_user->update_accounts("../../resources/accounts.txt", false);
        return;
    }
    progressValue++;
    bar->setValue(progressValue);
}

void MainWindow::on_ok_income_clicked() {
    double sum = ui->income_sum->text().toDouble();

    // Reset and prepare progress bar
    ui->progress_income->setValue(0);
    ui->progress_income->show();

    int *progress = new int(0);  // Dynamically allocated so it persists in lambda
    QTimer *timer = new QTimer(this);

    connect(timer, &QTimer::timeout, this, [=]() mutable {
        update_progress_bar(ui->progress_income, *progress, timer);
    });
    timer->start(10);  // Update every 10ms (100 steps in 1 second)

    curr_user->income(sum);
    // Fancy coordination. blabla
    QTimer::singleShot(1000, this, [this]() {
        ui->label_income->hide();
        ui->income_sum->clear();
        ui->income_sum->hide();
        ui->ok_income->hide();
    });
}

void MainWindow::on_income_sum_returnPressed() {
    on_ok_income_clicked();
}

void MainWindow::on_btn_withdrawal_clicked() {
    ui->label_withdrawal1->show();
    ui->label_withdrawal2->show();
    ui->withdrawal_source->show();
    ui->withdrawal_sum->show();
    ui->ok_withdrawal->show();
}

void MainWindow::on_ok_withdrawal_clicked() {
    double sum = ui->withdrawal_sum->text().toDouble();
    QString source = ui->withdrawal_source->text();
    Account *acc = curr_user->find_account(source.toStdString());

    // Reset and prepare progress bar
    ui->progress_withdrawal->setValue(0);
    ui->progress_withdrawal->show();

    int *progress = new int(0);  // Dynamically allocated so it persists in lambda
    QTimer *timer = new QTimer(this);

    connect(timer, &QTimer::timeout, this, [=]() mutable {
        update_progress_bar(ui->progress_withdrawal, *progress, timer);
    });
    timer->start(10);  // Update every 10ms (100 steps in 1 second)

    curr_user->withdrawal_from(acc->get_name(), sum);

    // Fancy coordination. blabla
    QTimer::singleShot(1000, this, [this]() {
        ui->label_withdrawal1->hide();
        ui->label_withdrawal2->hide();
        ui->withdrawal_sum->clear();
        ui->withdrawal_sum->hide();
        ui->withdrawal_source->clear();
        ui->withdrawal_source->hide();
        ui->ok_withdrawal->hide();
    });
}

void MainWindow::on_withdrawal_sum_returnPressed() {
    on_ok_withdrawal_clicked();
}

void MainWindow::on_withdrawal_source_returnPressed() {
    on_ok_withdrawal_clicked();
}


// void handle_new_account(User &curr_user, string accounts_file, string users_file) {
//     string name;
//     double coefficient = 0.0;
//     cout << "New account name: ";
//     cin >> name;
//     cout << "New account coefficient: ";
//     cin >> coefficient;
//     double sum_of_other_coefficients = 0.0;
//     for (size_t i = 0; i < curr_user.num_accounts; i++) {
//         sum_of_other_coefficients += curr_user.get_account_coefficient(i);
//     }
//     if (sum_of_other_coefficients + coefficient > 1.0) {
//         cout << "Sum of all accounts' coefficients is too big. Try again with a smaller coefficient.\n";
//     }
//     curr_user.add_account(curr_user.num_accounts, name, coefficient, 0.0, accounts_file, users_file);
// }

void MainWindow::on_action_new_account_triggered() {

}
