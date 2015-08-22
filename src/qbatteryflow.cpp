/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qbatteryflow.h"

QBatteryFlow::QBatteryFlow(QObject *parent) :
    QThread(parent), flow(-1)
{
    this->start();

    iTimer = new QTimer(this);
    iTimer->setInterval(5000);
    connect(iTimer, SIGNAL(timeout()), this, SLOT(timerTriggered()));
}

QBatteryFlow::~QBatteryFlow()
{
    stopMonitor();

    this->quit();
    this->wait();
}

void QBatteryFlow::startMonitor() const
{
    if (!iTimer->isActive())
        iTimer->start();
}

void QBatteryFlow::stopMonitor() const
{
    if (iTimer->isActive())
        iTimer->stop();
}

int QBatteryFlow::getFlow() const
{
    return flow;
}

void QBatteryFlow::run()
{
    try {
        QScopedPointer<QSystemBatteryInfo> batteryInfo(new QSystemBatteryInfo());

        QMutex mutex;
        mutex.lock();

        int tFlow = batteryInfo->currentFlow();

        if (flow != tFlow) {
            flow = (tFlow == 0) ? flow : tFlow;
            emit flowChanged();
        }

        mutex.unlock();
    }
    catch (...) {
        flow = -1;
    }
}

void QBatteryFlow::refreshFlow()
{
    timerTriggered();
}

void QBatteryFlow::timerTriggered()
{
    if (!this->isRunning())
        this->start();
}

