/*
 * <one line to give the library's name and an idea of what it does.>
 * Copyright 2013  Vishesh Handa <me@vhanda.in>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QSortFilterProxyModel>
#include <QListView>
#include <QLineEdit>

namespace Nepomuk2 {
    class ResultsModel;
}
class Sidebar;

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    explicit MainWindow(QWidget* parent = 0, Qt::WindowFlags flags = 0);
    virtual ~MainWindow();

private slots:
    void slotTextChanged(const QString& text);
    void slotSortOrderChanged();
    void slotDateFilterChanged();

private:
    Nepomuk2::ResultsModel* m_model;
    QSortFilterProxyModel* m_sortProxyModel;
    QListView* m_view;

    QLineEdit* m_lineEdit;
    Sidebar* m_sidebar;
};

#endif // MAINWINDOW_H
