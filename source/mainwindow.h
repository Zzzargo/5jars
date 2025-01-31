#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTimer>
#include <qlistwidget.h>
#include <qprogressbar.h>
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

    void on_accounts_list_itemDoubleClicked(QListWidgetItem *item);

    void on_btn_logout_clicked();

    void on_line_username_returnPressed();

    void on_line_password_returnPressed();


    void on_btn_income_clicked();

    void on_ok_income_clicked();

private:
    vector <User> users;
    vector <User> read_users(string filename);
    bool auth(string username, string password, vector <User> &users);
    User *curr_user;
    void populate_accounts_list();
    void update_progress_bar(QProgressBar *bar, int &progressValue, QTimer *timer);
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
