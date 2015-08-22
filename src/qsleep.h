/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QSLEEP_H
#define QSLEEP_H

#include <QTime>
#include <QCoreApplication>

static void qSleep(int milliseconds)
{
    QTime crrTime = QTime::currentTime().addMSecs(milliseconds);

    while(QTime::currentTime() < crrTime)
    {
        QCoreApplication::processEvents(QEventLoop::AllEvents, 100);
    }
}

#endif // QSLEEP_H
