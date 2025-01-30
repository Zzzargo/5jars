#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTimer>
#include "user.h"

QT_BEGIN_NAMESPACE
namespace Ui {
    class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_btn_login_clicked();

private:
    vector <User> users;
    vector <User> read_users(string filename);
    bool auth(string username, string password, vector <User> &users);
    User curr_user;
    void populate_accounts_list();
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
