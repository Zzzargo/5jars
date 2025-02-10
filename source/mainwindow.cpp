#include "mainwindow.h"
#include "./ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow) {  // Create the UI object
    ui->setupUi(this);        // Load the UI from mainwindow.ui

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
    QSqlQuery query;  // Make sure dependencies work
    if (!(query.exec("PRAGMA foreign_keys = ON;"))) {
        qDebug() << "Failed to set dependencies";
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
                curr_user_id = query.value("id").toInt();
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

        // Had to do it. Otherwise it was gray and blunt
        ui->menu->setStyleSheet("QMenu {"
                            "border: 1px solid #ccc;"
                            "}"
                            "QMenu::item {"
                            "background-color: transparent;"
                            "}"
                            "QMenu::item:selected {"
                            "background-color: rgb(52, 38, 75);"
                            "}"
                            "QMenu::item:pressed {"
                            "background-color: rgb(129, 61, 156);"
                            "}");

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
    ui->line_register_nick->clear();
    ui->line_register_uname->clear();
    ui->line_register_pass->clear();
    ui->line_register_pass2->clear();
    ui->stackedWidget->setCurrentIndex(0);  // Go to login page
}

void MainWindow::on_btn_new_user_clicked() {
    if (ui->line_register_pass2->text().isEmpty() || ui->line_register_uname->text().isEmpty() ||
        ui->line_register_pass->text().isEmpty() || ui->line_register_nick->text().isEmpty()) {
        ui->label_register_success->setText("All fields must be filled!");
        ui->label_register_success->setStyleSheet("color: red;");
        QTimer::singleShot(2000, this, [this]() {
            // Hide the error after 2s
            ui->label_register_success->clear();
            ui->label_register_success->setStyleSheet("color: white;");
        });
        return;
    }

    QString nick = ui->line_register_nick->text();
    QString uname = ui->line_register_uname->text();
    QString pass = ui->line_register_pass->text();
    QString pass_confirm = ui->line_register_pass2->text();


    if (pass != pass_confirm) {
        // Highlight error
        ui->label_register_success->setText("Passwords don't match!");
        ui->label_register_success->setStyleSheet("color: red;");
        ui->line_register_pass->setStyleSheet("background-color: red;");
        ui->line_register_pass2->setStyleSheet("background-color: red;");
        QTimer::singleShot(2000, this, [this]() {
            // Hide the error after 2s
            ui->label_register_success->clear();
            ui->label_register_success->setStyleSheet("color: white;");
            ui->line_register_pass->setStyleSheet("background-color: rgb(61, 56, 70);");
            ui->line_register_pass2->setStyleSheet("background-color: rgb(61, 56, 70);");
        });
        return;
    }

    QSqlQuery query;
    query.prepare("SELECT COUNT(*) FROM users WHERE username = :username");
    query.bindValue(":username", uname);

    if (!query.exec()) {
        qDebug() << "Error checking username availability:" << query.lastError();
        return;
    }

    query.next();
    int count = query.value(0).toInt();

    if (count > 0) {
        // Username is already taken
        ui->label_register_success->setText("Username not free");
        ui->label_register_success->setStyleSheet("color: red;");
        ui->line_register_uname->setStyleSheet("background-color: red;");
        QTimer::singleShot(2000, this, [this]() {
            // Hide the error after 2s
            ui->label_register_success->clear();
            ui->label_register_success->setStyleSheet("color: white;");
            ui->line_register_uname->setStyleSheet("background-color: rgb(61, 56, 70);");
        });
        return;
    }
    // If all checks passed create a new user
    query.prepare("INSERT INTO users (nickname, username, password) VALUES (:nickname, :username, :password);");
    query.bindValue(":nickname", nick);
    query.bindValue(":username", uname);
    query.bindValue(":password", pass);

    if (!query.exec()) {
        qDebug() << "Error inserting user:" << query.lastError().text();
    } else {
        ui->label_register_success->setText("User registered successfully!");
        QTimer::singleShot(2000, this, [this]() {
            // Exit the register page in 2s
            ui->label_register_success->clear();
            on_btn_reg_back_clicked();
        });
    }
}

void MainWindow::on_line_register_nick_returnPressed() {
    on_btn_new_user_clicked();
}

void MainWindow::on_line_register_uname_returnPressed() {
    on_btn_new_user_clicked();
}


void MainWindow::on_line_register_pass_returnPressed() {
    on_btn_new_user_clicked();
}


void MainWindow::on_line_register_pass2_returnPressed() {
    on_btn_new_user_clicked();
}

void MainWindow::on_action_delete_user_triggered() {
    bool confirm = QMessageBox::question(this, "Confirm Deletion",
                                         "Are you sure you want to delete this user?",
                                         QMessageBox::Yes | QMessageBox::No) == QMessageBox::Yes;
    if (confirm) {
        QSqlQuery query;
        // Make sure the dependencies work
        query.prepare("DELETE FROM users WHERE id = :uid");
        query.bindValue(":uid", curr_user_id);
        if (!query.exec()) {
            qDebug() << "Error deleting user:" << query.lastError().text();
        } else {
            QTimer::singleShot(1000, this, [this]() {
                // Exit the dashboard page in 1s
                on_btn_logout_clicked();
            });
        }
    }
}

void MainWindow::on_btn_logout_clicked() {
    // Reset the current user
    delete curr_user;
    curr_user = NULL;
    curr_user_id = 0;
    ui->accounts_list->clear();  // Clear the accounts list
    ui->stackedWidget->setCurrentIndex(0);  // Get to the login page
}

void MainWindow::on_action_new_account_triggered() {
    // Create a dialog window (pop-up)
    QDialog dialog(this);
    dialog.setWindowTitle("New Account");
    dialog.setModal(true);
    dialog.setMinimumSize(400, 200);

    // Create widgets
    QLineEdit *name_input = new QLineEdit(&dialog);
    QLineEdit *coef_input = new QLineEdit(&dialog);
    QPushButton *confirm_button = new QPushButton("Create", &dialog);
    QPushButton *cancel_button = new QPushButton("Cancel", &dialog);

    // Layout setup
    QFormLayout *form_layout = new QFormLayout(&dialog);
    form_layout->addRow(tr("&Name:"), name_input);
    form_layout->addRow(tr("&Coefficient:"), coef_input);
    form_layout->addWidget(cancel_button);
    form_layout->addWidget(confirm_button);
    form_layout->setFormAlignment(Qt::AlignHCenter | Qt::AlignCenter);
    form_layout->setLabelAlignment(Qt::AlignHCenter);
    form_layout->setHorizontalSpacing(35);
    form_layout->setVerticalSpacing(15);

    dialog.setLayout(form_layout);

    // Connect buttons
    connect(confirm_button, &QPushButton::clicked, [&]() {
        QString name = name_input->text();
        double coef = coef_input->text().toDouble();

        if (name.isEmpty() || coef <= 0) {
            QMessageBox::warning(&dialog, "Error", "Please enter valid data!");
            return;
        }

        // Insert into the database
        QSqlQuery query;
        query.prepare("INSERT INTO accounts (name, owner_id, coef) VALUES (:name, :owner_id, :coef)");
        query.bindValue(":name", name);
        query.bindValue(":owner_id", curr_user_id);
        query.bindValue(":coef", coef);

        if (query.exec()) {
            qDebug() << "New account created!";
            query.prepare("UPDATE users SET num_acc = num_acc + 1 WHERE id = :uid");
            query.bindValue(":uid", curr_user_id);
            if (query.exec()) {
                qDebug() << "Num_acc updated!";

                // Update the data stored in memory
                curr_user->num_accounts++;
                curr_user->get_accounts();
                curr_user->populate_accounts_list(ui->accounts_list);
                dialog.accept();
            } else {
                QMessageBox::critical(&dialog, "Error", "Failed to update num_acc.");
            }
        } else {
            QMessageBox::critical(&dialog, "Error", "Failed to create account.");
        }
    });

    connect(cancel_button, &QPushButton::clicked, &dialog, &QDialog::reject);

    // Execute the dialog
    dialog.exec();
}

void MainWindow::delete_account(QListWidgetItem *item) {
    bool confirm = QMessageBox::question(this, "Confirm Deletion",
                                         "Are you sure you want to delete this account?",
                                         QMessageBox::Yes | QMessageBox::No) == QMessageBox::Yes;
    if (confirm) {
        QString acc_name = item->text().split(" - ").first();
        QSqlQuery query;
        // First get the ID of the account
        query.prepare("SELECT id FROM accounts WHERE owner_id = :uid and name = :acc_name;");
        query.bindValue(":uid", curr_user_id);
        query.bindValue(":acc_name", acc_name);
        if (!query.exec()) {
            qDebug() << "Error executing query:" << query.lastError().text();
            return;
        }
        if (!query.next()) {
            qDebug() << "Error executing query:" << query.lastError().text();
            return;
        }
        // At this point we should have got the ID
        unsigned acc_id = query.value(0).toUInt();
        query.prepare("DELETE FROM accounts WHERE id = :acc_id");
        query.bindValue(":acc_id", acc_id);
        if (!query.exec()) {
            qDebug() << "Error executing query:" << query.lastError().text();
            return;
        }
        qDebug() << "Account deleted";

        // With great power comes great responsibility
        query.prepare("UPDATE users SET num_acc = num_acc - 1 WHERE id = :uid");
        query.bindValue(":uid", curr_user_id);
        if (!query.exec()) {
            qDebug() << "Error executing query:" << query.lastError().text();
            return;
        }
        curr_user->num_accounts--;
        qDebug() << "Num_acc updated";

        // Update the UI list
        curr_user->get_accounts();
        curr_user->populate_accounts_list(ui->accounts_list);
    }
}

void MainWindow::change_coefficient(QListWidgetItem *item) {
    QString acc_name = item->text().split(" - ").first();
    QSqlQuery query;
    // First get the ID of the account
    query.prepare("SELECT id FROM accounts WHERE owner_id = :uid and name = :acc_name;");
    query.bindValue(":uid", curr_user_id);
    query.bindValue(":acc_name", acc_name);
    if (!query.exec()) {
        qDebug() << "Error executing query:" << query.lastError().text();
        return;
    }
    if (!query.next()) {
        qDebug() << "Error executing query:" << query.lastError().text();
        return;
    }
    // At this point we should have got the ID
    unsigned acc_id = query.value(0).toUInt();

    // Then get the current coefficient
    query.prepare("SELECT coef FROM accounts WHERE id = :acc_id;");
    query.bindValue(":acc_id", acc_id);
    if (!query.exec()) {
        qDebug() << "Error executing query:" << query.lastError().text();
        return;
    }
    if (!query.next()) {
        qDebug() << "Error executing query:" << query.lastError().text();
        return;
    }
    double curr_coef = query.value(0).toDouble();

    // Create a dialog window (pop-up)
    QDialog dialog(this);
    dialog.setWindowTitle("Change coefficient");
    dialog.setModal(true);
    dialog.setMinimumSize(400, 200);

    // Create widgets
    QLabel *curr_coef_label = new QLabel(QString::number(curr_coef));
    QLineEdit *coef_input = new QLineEdit(&dialog);
    QPushButton *confirm_button = new QPushButton("Change coefficient", &dialog);
    QPushButton *cancel_button = new QPushButton("Cancel", &dialog);

    // Layout setup
    QFormLayout *form_layout = new QFormLayout(&dialog);
    form_layout->addRow(tr("&Current coefficient:"), curr_coef_label);
    form_layout->addRow(tr("&Desired coefficient:"), coef_input);
    form_layout->addWidget(cancel_button);
    form_layout->addWidget(confirm_button);

    form_layout->setFormAlignment(Qt::AlignHCenter | Qt::AlignCenter);
    form_layout->setLabelAlignment(Qt::AlignHCenter);
    form_layout->setHorizontalSpacing(35);
    form_layout->setVerticalSpacing(15);

    dialog.setLayout(form_layout);

    // Connect buttons
    connect(confirm_button, &QPushButton::clicked, [&]() {
        double desired_coef = coef_input->text().toDouble();

        if (desired_coef <= 0) {
            QMessageBox::warning(&dialog, "Error", "Coefficient can't be less than or equal to 0!");
            return;
        }

        // Update into the database
        query.prepare("UPDATE accounts SET coef = :coef WHERE id = :acc_id");
        query.bindValue(":coef", desired_coef);
        query.bindValue(":acc_id", acc_id);
        if (!query.exec()) {
            qDebug() << "Error executing query:" << query.lastError().text();
            return;
        }
        curr_user->get_accounts();
        qDebug() << "Coefficient modified";
    });

    connect(cancel_button, &QPushButton::clicked, &dialog, &QDialog::reject);

    dialog.exec();
}

void MainWindow::on_accounts_list_itemDoubleClicked(QListWidgetItem *item) {
    // Create a context menu
    QMenu menu(this);
    menu.setStyleSheet("QMenu {"
                       "border: 1px solid #ccc;"
                        "}"
                        "QMenu::item {"
                        "background-color: transparent;"
                        "}"
                        "QMenu::item:selected {"
                        "background-color: rgb(52, 38, 75);"
                        "}"
                        "QMenu::item:pressed {"
                        "background-color: rgb(129, 61, 156);"
                       "}");

    // Create actions
    QAction *modify_action = new QAction("Change coefficient", &menu);
    QAction *delete_action = new QAction("Delete Account", &menu);

    // Add actions to the menu
    menu.addAction(modify_action);
    menu.addAction(delete_action);

    // Connect actions to slots
    connect(modify_action, &QAction::triggered, this, [=]() {
        change_coefficient(item);
    });

    connect(delete_action, &QAction::triggered, this, [=]() {
        delete_account(item);
    });

    // Show the menu at the cursor position
    menu.exec(QCursor::pos());
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
        curr_user->populate_accounts_list(ui->accounts_list);  // Update the list
        return;
    }
    progressValue++;
    bar->setValue(progressValue);
}

void MainWindow::on_ok_income_clicked() {
    double sum = ui->income_sum->text().toDouble();
    if (sum == 0) {
        return;
    }

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
    curr_user->log_op(INCOME, "income", sum, LOG_FILE);

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
