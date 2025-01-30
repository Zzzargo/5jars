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

bool MainWindow::auth(string username, string password, vector <User> &users) {
    for (size_t i = 0; i < users.size(); i++) {
        if (users[i].user_finder(username)) {
            if (users[i].login(username, password)) {
                curr_user = users[i];
                return true;
            }
        }
    }
    return false;
}

void MainWindow::populate_accounts_list() {
    for (size_t i = 0; i < curr_user.num_accounts; i++) {
        QString account_info = QString::fromStdString(curr_user.get_account_name(i)) +
            ": " + QString::number(curr_user.get_account_balance(i));
        ui->accounts_list->addItem(account_info);
    }
}

void MainWindow::on_btn_login_clicked() {
    QString input_uname = ui->line_username->text();
    QString input_upass = ui->line_password->text();
    if (auth(input_uname.toStdString(), input_upass.toStdString(), users)) {
        ui->label_auth->setText("SUCCESS");
        // Populate the current user's accounts vector
        curr_user.read_accounts("../../resources/accounts.txt");
        // And the list on the GUI
        populate_accounts_list();
        // Wait a second( literally :)) )
        QTimer::singleShot(1000, this, [this]() {
            ui->stackedWidget->setCurrentIndex(1);  // Set the widget to dashboard
        });
    } else {
        ui->label_auth->setText("FAIL");
    }
}
