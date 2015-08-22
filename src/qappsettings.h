/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QAPPSETTINGS_H
#define QAPPSETTINGS_H

#include <QApplication>
#include <QObject>
#include <QSettings>
#include <QDateTime>
#include "commontype.h"

class QAppSettings : public QObject
{
    Q_OBJECT
public:
    explicit QAppSettings(QObject *parent = 0);
    ~QAppSettings();

    Q_INVOKABLE bool getInvertedStyle();
    Q_INVOKABLE void setInvertedStyle(bool value);

    Q_INVOKABLE int getLevelType();
    Q_INVOKABLE void setLevelType(int type);

    Q_INVOKABLE bool getPSM();
    Q_INVOKABLE void setPSM(bool value);

    Q_INVOKABLE int getPSMLevel();
    Q_INVOKABLE void setPSMLevel(int value);

    Q_INVOKABLE double getErrorAverage();
    Q_INVOKABLE void setErrorAverage(double value);

    Q_INVOKABLE int getLastChargerType();
    Q_INVOKABLE void setLastChargerType(int type);

    Q_INVOKABLE QDateTime getLastChargingTime();
    Q_INVOKABLE void setLastChargingTime(QDateTime dateTime);

    Q_INVOKABLE int getLastBatteryLevel();
    Q_INVOKABLE void setLastBatteryLevel(int value);

    Q_INVOKABLE bool getFullNotify();
    Q_INVOKABLE void setFullNotify(bool value);

    Q_INVOKABLE bool getLowNotify();
    Q_INVOKABLE void setLowNotify(bool value);

    Q_INVOKABLE int getNotifyLevel();
    Q_INVOKABLE void setNotifyLevel(int value);

    Q_INVOKABLE int getWidgetOpacity();
    Q_INVOKABLE void setWidgetOpacity(int value);

    Q_INVOKABLE void clear();

private:
    QSettings *iSettings;
};

#endif // QAPPSETTINGS_H
