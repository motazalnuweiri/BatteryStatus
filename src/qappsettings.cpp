/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qappsettings.h"

QAppSettings::QAppSettings(QObject *parent) :
    QObject(parent)
{
    iSettings = new QSettings(qApp->organizationName(), qApp->applicationName(), parent);
}

QAppSettings::~QAppSettings()
{
    delete iSettings;
}

bool QAppSettings::getInvertedStyle()
{
    return iSettings->value("Style/Inverted", false).toBool();
}

void QAppSettings::setInvertedStyle(bool value)
{
    iSettings->setValue("Style/Inverted", value);
}

int QAppSettings::getLevelType()
{
    return iSettings->value("Level/Type", CommonType::RealLevel).toInt();
}

void QAppSettings::setLevelType(int type)
{
    iSettings->setValue("Level/Type", type);
}

bool QAppSettings::getPSM()
{
    return iSettings->value("PSMode/Enable", true).toBool();
}

void QAppSettings::setPSM(bool value)
{
    iSettings->setValue("PSMode/Enable", value);
}

int QAppSettings::getPSMLevel()
{
    return iSettings->value("PSMode/Level", 20).toInt();
}

void QAppSettings::setPSMLevel(int value)
{
    iSettings->setValue("PSMode/Level", value);
}

double QAppSettings::getErrorAverage()
{
    return iSettings->value("Charger/ErrorAvrage", 0.08).toDouble();
}

void QAppSettings::setErrorAverage(double value)
{
    iSettings->setValue("Charger/ErrorAvrage", value);
}

int QAppSettings::getLastChargerType()
{
    return iSettings->value("Charger/Type", -2).toInt();
}

void QAppSettings::setLastChargerType(int type)
{
    iSettings->setValue("Charger/Type", type);
}

QDateTime QAppSettings::getLastChargingTime()
{
    return iSettings->value("Charger/Time", NULL).toDateTime();
}

void QAppSettings::setLastChargingTime(QDateTime dateTime)
{
    iSettings->setValue("Charger/Time", dateTime);
}

int QAppSettings::getLastBatteryLevel()
{
    return iSettings->value("Charger/Level", -2).toInt();
}

void QAppSettings::setLastBatteryLevel(int value)
{
    iSettings->setValue("Charger/Level", value);
}

bool QAppSettings::getFullNotify()
{
    return iSettings->value("Notify/Full", true).toBool();
}

void QAppSettings::setFullNotify(bool value)
{
    iSettings->setValue("Notify/Full", value);
}

bool QAppSettings::getLowNotify()
{
    return iSettings->value("Notify/Low", true).toBool();
}

void QAppSettings::setLowNotify(bool value)
{
    iSettings->setValue("Notify/Low", value);
}

int QAppSettings::getNotifyLevel()
{
    return iSettings->value("Notify/Level", 60).toFloat();
}

void QAppSettings::setNotifyLevel(int value)
{
    iSettings->setValue("Notify/Level", value);
}

int QAppSettings::getWidgetOpacity()
{
    return iSettings->value("Widget/Opacity", 80).toInt();
}

void QAppSettings::setWidgetOpacity(int value)
{
    iSettings->setValue("Widget/Opacity", value);
}

void QAppSettings::clear()
{
    iSettings->clear();
}
