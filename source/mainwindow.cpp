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
                curr_user = &(users[i]);
                return true;
            }
        }
    }
    return false;
}

void MainWindow::populate_accounts_list() {
    ui->accounts_list->clear();  // Make sure it's empty first
    for (size_t i = 0; i < curr_user->num_accounts; i++) {
        QString account_info = QString::fromStdString(curr_user->get_account_name(i)) +
            ": " + QString::number(curr_user->get_account_balance(i));
        ui->accounts_list->addItem(account_info);
    }
}

void MainWindow::on_btn_login_clicked() {
    QString input_uname = ui->line_username->text();
    QString input_upass = ui->line_password->text();

    if (auth(input_uname.toStdString(), input_upass.toStdString(), users)) {
        ui->label_auth->setText("Authentication successful!");

        // Populate the current user's accounts vector
        curr_user->read_accounts("../../resources/accounts.txt");
        // And the list on the GUI
        populate_accounts_list();
        // Set the user label
        ui->label_curruser->setText("Current user: " + QString::fromStdString(curr_user->get_username()));
        // Hide the fields for operations
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

            // Reset the login page
            ui->line_password->clear();
            ui->line_username->clear();
            ui->label_auth->clear();
        });
    } else {
        ui->label_auth->setText("Username/password incorrect!");
    }
}

void MainWindow::on_line_username_returnPressed() {
    on_btn_login_clicked();
}


void MainWindow::on_line_password_returnPressed() {
    on_btn_login_clicked();
}

void MainWindow::on_accounts_list_itemDoubleClicked(QListWidgetItem *item) {

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
}

