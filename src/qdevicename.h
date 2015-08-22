/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QDEVICENAME_H
#define QDEVICENAME_H

#include <QObject>
#include <QSystemDeviceInfo>

using namespace QtMobility;

class QDeviceName : public QObject
{
    Q_OBJECT
public:
    explicit QDeviceName(QObject *parent = 0);
    ~QDeviceName();

    Q_INVOKABLE bool isE6() const;

private:
    QSystemDeviceInfo *iDeviceInfo;
    
};

#endif // QDEVICENAME_H
