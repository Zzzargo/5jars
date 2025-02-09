#include "mainwindow.h"
#include "./ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow) {  // Create the UI object
    ui->setupUi(this);        // Load the UI from mainwindow.ui

    // Read the users before all
    // users = read_users(USERS_FILE);

    connect_database();
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

void MainWindow::connect_database() {
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("../../resources/5jars.db");

    if (!db.open()) {
        qDebug() << "Failed to open database";
        return;
    }
}

bool MainWindow::auth(const QString& username, const QString& password) {
    QSqlQuery query;
    query.prepare("SELECT password FROM users WHERE username = :username");
    query.bindValue(":username", username);

    if (!query.exec()) {
        qDebug() << "Error executing query:" << query.lastError();
        return false;
    }

    if (query.next()) {
        QString stored_password = query.value(0).toString();
        if (stored_password == password) {
            ui->label_auth->setText("Authentication successful!");

            // Build the user in memory
            query.prepare("SELECT * FROM users WHERE username = :username");
            query.bindValue(":username", username);
            if (!query.exec()) {
                qDebug() << "Error executing query:" << query.lastError();
                return false;
            }

            if (query.next()) {
                User *u = new User(query.value("id").toInt(), query.value("nickname").toString(), query.value("username").toString(),
                       query.value("password").toString(), query.value("num_acc").toInt());
                curr_user = u;
            }
            return true;
        } else {
            ui->label_auth->setText("Username/password incorrect!");
            return false;
        }
    } else {
        ui->label_auth->setText("User not found.");
        return false;
    }
}

void MainWindow::on_btn_login_clicked() {
    QString input_uname = ui->line_username->text();
    QString input_upass = ui->line_password->text();

    if (auth(input_uname, input_upass)) {
        // Populate the current user's accounts vector
        curr_user->get_accounts();
        curr_user->populate_accounts_list(ui->accounts_list);

        // Setup the dashboard page
        ui->label_curr_user->setText("Current user: " + curr_user->nickname);
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
        ui->label_bad_account->hide();

        // Wait a second( literally :)) )
        QTimer::singleShot(1000, this, [this]() {
            ui->stackedWidget->setCurrentIndex(1);  // Set the widget to dashboard
            ui->menubar->show();

            // Reset the login page
            ui->line_password->clear();
            ui->line_username->clear();
            ui->label_auth->clear();
        });
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
    delete curr_user;
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
        // populate_accounts_list();  // Update the list
        // curr_user->update_accounts(ACCOUNTS_FILE, false);
        return;
    }
    progressValue++;
    bar->setValue(progressValue);
}

void MainWindow::on_ok_income_clicked() {
//     double sum = ui->income_sum->text().toDouble();
//     if (sum == 0) {
//         return;
//     }

//     // Reset and prepare progress bar
//     ui->progress_income->setValue(0);
//     ui->progress_income->show();

//     int *progress = new int(0);  // Dynamically allocated so it persists in lambda
//     QTimer *timer = new QTimer(this);

//     connect(timer, &QTimer::timeout, this, [=]() mutable {
//         update_progress_bar(ui->progress_income, *progress, timer);
//     });
//     timer->start(10);  // Update every 10ms (100 steps in 1 second)

//     curr_user->income(sum);
//     curr_user->log_op(INCOME, "income", sum, LOG_FILE);

//     // Fancy coordination. blabla
//     QTimer::singleShot(1000, this, [this]() {
//         ui->label_income->hide();
//         ui->income_sum->clear();
//         ui->income_sum->hide();
//         ui->ok_income->hide();
//     });
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
//     double sum = ui->withdrawal_sum->text().toDouble();
//     if (sum == 0) {
//         return;
//     }

//     QString source = ui->withdrawal_source->text();
//     Account *acc = curr_user->find_account(source.toStdString());
//     if (acc == NULL) {
//         // Highlight error
//         ui->withdrawal_source->setStyleSheet("background-color: rgba(255, 0, 0, 100);");
//         ui->label_bad_account->show();
//         QTimer::singleShot(2000, this, [this]() {
//             // Hide the error after 2s
//             ui->withdrawal_source->setStyleSheet("background-color: rgb(52, 38, 75);");
//             ui->label_bad_account->hide();
//         });
//         return;
//      }

//     // Reset and prepare progress bar
//     ui->progress_withdrawal->setValue(0);
//     ui->progress_withdrawal->show();

//     int *progress = new int(0);  // Dynamically allocated so it persists in lambda
//     QTimer *timer = new QTimer(this);

//     connect(timer, &QTimer::timeout, this, [=]() mutable {
//         update_progress_bar(ui->progress_withdrawal, *progress, timer);
//     });
//     timer->start(10);  // Update every 10ms (100 steps in 1 second)

//     curr_user->withdrawal_from(acc->get_name(), sum);
//     curr_user->log_op(WITHDRAWAL, acc->get_name(), sum, LOG_FILE);

//     // Fancy coordination. blabla
//     QTimer::singleShot(1000, this, [this]() {
//         ui->label_withdrawal1->hide();
//         ui->label_withdrawal2->hide();
//         ui->withdrawal_sum->clear();
//         ui->withdrawal_sum->hide();
//         ui->withdrawal_source->clear();
//         ui->withdrawal_source->hide();
//         ui->ok_withdrawal->hide();
//     });
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

void MainWindow::on_btn_register_clicked() {
    // Reset the login page, just in case
    ui->line_password->clear();
    ui->line_username->clear();

    ui->line_register_pass->setEchoMode(QLineEdit::Password);
    ui->line_register_pass2->setEchoMode(QLineEdit::Password);
    ui->stackedWidget->setCurrentIndex(2);  // Go to register page
}

void MainWindow::on_btn_reg_back_clicked() {
    // Reset the register page
    ui->line_register_pass->clear();
    ui->line_register_pass2->clear();
    ui->line_register_uname->clear();
    ui->stackedWidget->setCurrentIndex(0);  // Go to login page
}

void MainWindow::update_users(string file) {
    // CHANGE THIS TO READ FROM THE PRIVATE MEMBER USERS VECTOR AND WRITE TO FILE
    // ofstream users_writer;
    // users_writer.open(file);
    // if (!users_writer.is_open()) {
    //     cerr << "Error: Unable to open the users file for writing.\n";
    //     exit(EXIT_FAILURE);
    // }
    // for (size_t i = 0; i < users.size(); i++) {
    //     users_writer >> users[i].
    // }
    // users_writer.close();
}

void MainWindow::on_btn_new_user_clicked() {
//     QString nick = ui->line_register_nick->text();
//     QString uname = ui->line_register_uname->text();
//     QString pass = ui->line_register_pass->text();
//     QString pass_confirm = ui->line_register_pass2->text();

//     if (pass != pass_confirm) {
//         // Highlight error
//         ui->label_register_success->setText("Passwords don't match!");
//         ui->label_register_success->setStyleSheet("color: red;");
//         ui->line_register_pass->setStyleSheet("background-color: red;");
//         ui->line_register_pass2->setStyleSheet("background-color: red;");
//         QTimer::singleShot(2000, this, [this]() {
//             // Hide the error after 2s
//             ui->label_register_success->clear();
//             ui->label_register_success->setStyleSheet("color: white;");
//             ui->line_register_pass->setStyleSheet("background-color: rgb(61, 56, 70);");
//             ui->line_register_pass2->setStyleSheet("background-color: rgb(61, 56, 70);");

//         });
//         return;
//     }

//     for (size_t i = 0; i < users.size(); i++) {
//         if (users[i].user_finder(uname.toStdString())) {
//             ui->label_register_success->setText("Username not free");
//             ui->label_register_success->setStyleSheet("color: red;");
//             ui->line_register_uname->setStyleSheet("background-color: red;");
//             QTimer::singleShot(2000, this, [this]() {
//                 // Hide the error after 2s
//                 ui->label_register_success->clear();
//                 ui->label_register_success->setStyleSheet("color: white;");
//                 ui->line_register_uname->setStyleSheet("background-color: rgb(61, 56, 70);");
//             });
//         }
//     }
//     // If all checks passed create a new user
//     User u(users.size(), nick.toStdString(), uname.toStdString(), pass.toStdString(), 0);
//     users.emplace_back(u);
}
