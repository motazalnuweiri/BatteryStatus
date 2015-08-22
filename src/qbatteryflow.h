/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QBATTERYFLOW_H
#define QBATTERYFLOW_H

#include <QObject>
#include <QThread>
#include <QSystemBatteryInfo>
#include <QtCore>
#include <QTimer>

using namespace QtMobility;

class QBatteryFlow : public QThread
{
    Q_OBJECT

public:
    explicit QBatteryFlow(QObject *parent = 0);
    ~QBatteryFlow();

    Q_INVOKABLE void startMonitor() const;
    Q_INVOKABLE void stopMonitor() const;
    Q_INVOKABLE int getFlow() const;

protected:
    void run();

signals:
    void flowChanged();

public slots:
    void refreshFlow();
    
private slots:
    void timerTriggered();
    
private:
    QTimer *iTimer;
    int flow;
};

#endif // QBATTERYFLOW_H
