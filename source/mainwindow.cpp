#include "mainwindow.h"
#include "./ui_login.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::LoginWindow) {
    ui->setupUi(this);
}

MainWindow::~MainWindow() {
    delete ui;
}

void MainWindow::on_btn_login_clicked() {
    QString input_uname = ui->line_username->text();
    QString input_upass = ui->line_password->text();
    if (input_uname == "zargo" && input_upass == "pass") {
        ui->label_auth_success->setText("Success!");
    }
}
