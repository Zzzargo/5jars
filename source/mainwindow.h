#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTimer>
#include <qprogressbar.h>
#include <QMessageBox>
#include <QFormLayout>
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

    void delete_account(QListWidgetItem *item);

    void change_coefficient(QListWidgetItem *item);

    void on_accounts_list_itemDoubleClicked(QListWidgetItem *item);

    void on_btn_logout_clicked();

    void on_line_username_returnPressed();

    void on_line_password_returnPressed();

    void on_btn_income_clicked();

    void on_ok_income_clicked();

    void on_btn_withdrawal_clicked();

    void on_ok_withdrawal_clicked();

    void on_action_new_account_triggered();

    void on_income_sum_returnPressed();

    void on_withdrawal_sum_returnPressed();

    void on_withdrawal_source_returnPressed();


    void on_btn_register_clicked();

    void on_btn_reg_back_clicked();

    void on_btn_new_user_clicked();

    void on_action_delete_user_triggered();

    void on_line_register_nick_returnPressed();

    void on_line_register_uname_returnPressed();

    void on_line_register_pass_returnPressed();

    void on_line_register_pass2_returnPressed();

private:
    Ui::MainWindow *ui;

    // This is gonna buss
    QSqlDatabase db;
    void connect_database();

    User *curr_user = nullptr;
    unsigned curr_user_id;
    bool auth(const QString& username, const QString& password);

    void update_progress_bar(QProgressBar *bar, int &progressValue, QTimer *timer);
};

#endif // MAINWINDOW_H
