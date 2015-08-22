/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QSYMBIANAPPLICATION_H
#define QSYMBIANAPPLICATION_H

#include <QObject>
#include <QtGui/QApplication>
#include <QSymbianEvent>
#include <w32std.h>
#include <eikon.hrh>
#include <avkon.hrh>
#include "qsymbianhelper.h"

class QSymbianApplication : public QApplication
{
    Q_OBJECT
public:
    QSymbianApplication(int argc, char** argv);

    Q_INVOKABLE bool foreground();
    bool isRestarting();

signals:
    void foregroundChanged(bool status);
    void aboutToRestart();

public slots:
    void restart();

protected:
    bool symbianEventFilter(const QSymbianEvent* event);

private:
    bool iForeground;
    bool iIsRestarting;
    
};

#endif // QSYMBIANAPPLICATION_H
