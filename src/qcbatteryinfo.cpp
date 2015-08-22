/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qcbatteryinfo.h"
#include <QDebug>
#include "qsleep.h"

QCBatteryInfo::QCBatteryInfo(QObject *parent) :
    QObject(parent)
{
    iBatteryInfo = new QSystemBatteryInfo(this);
    iDeviceInfo = new QSystemDeviceInfo(this);
    iBatteryFlow = new QBatteryFlow(this);
    iTimer = new QTimer(this);
    iAppSettings = new QAppSettings();

    connect(iBatteryInfo, SIGNAL(chargingStateChanged(QSystemBatteryInfo::ChargingState)),
            this, SLOT(onChargingStateChanged(QSystemBatteryInfo::ChargingState)));
    connect(iBatteryFlow, SIGNAL(flowChanged()), this, SIGNAL(flowChanged()));
    connect(iTimer, SIGNAL(timeout()), this, SLOT(monitorConnection()));

    tCharging = isCharging();
    tChargingTime = QDateTime::currentDateTime();
    tLastChargerType = iBatteryInfo->chargerType();

    pLevelType = (CommonType::LevelType) iAppSettings->getLevelType();
    errorAverage = iAppSettings->getErrorAverage();
    sLastChargingTime = iAppSettings->getLastChargingTime();
    sLastChargerType = iAppSettings->getLastChargerType();
    sLastBatteryLevel = iAppSettings->getLastBatteryLevel();

    nLow = !isCharging();
    nVeryLow = !isCharging();

    iTimer->start(1000);

    monitorConnection();
}

QCBatteryInfo::~QCBatteryInfo()
{
    delete iBatteryInfo;
    delete iDeviceInfo;
    delete iBatteryFlow;
    delete iAppSettings;

    iTimer->stop();
    delete iTimer;
}

void QCBatteryInfo::startMonitorFlow(bool on)
{
    pMonitoringFlow = on;

    if (on)
        iBatteryFlow->startMonitor();
    else
        iBatteryFlow->stopMonitor();
}

bool QCBatteryInfo::monitorFlow()
{
    return pMonitoringFlow;
}

void QCBatteryInfo::setLevelType(CommonType::LevelType value)
{
    pLevelType = value;
}

CommonType::LevelType QCBatteryInfo::levelType()
{
    return pLevelType;
}

int QCBatteryInfo::getLevel() const
{
    return currLevel;
}

int QCBatteryInfo::getFlow() const
{
    return iBatteryFlow->getFlow();
}

int QCBatteryInfo::getCapacity() const
{
    return currCapacity;
}

int QCBatteryInfo::getFullCapacity() const
{
    return iBatteryInfo->nominalCapacity();
}

float QCBatteryInfo::getVoltage() const
{
    return (float) iBatteryInfo->voltage() / 1000;
}

bool QCBatteryInfo::isCharging() const
{
    return (iBatteryInfo->chargingState() == QSystemBatteryInfo::Charging);
}

QString QCBatteryInfo::getLevelColor() const
{
    QString green  = "#27a800";
    QString red    = "#c81000";
    QString yellow = "#ff9100";
    QString blue   = "#0080ff";

    if (isCharging())
        return blue;

    int level = getLevel();

    if (level >= 50)
        return green;

    if (level < 50 && level > 20)
        return yellow;

    if (level <= 20)
        return red;
}

QString QCBatteryInfo::getEnergyUnit() const
{
    switch (iBatteryInfo->energyMeasurementUnit()) {
    case QSystemBatteryInfo::UnitmAh:
        return tr("mAh");

    case QSystemBatteryInfo::UnitmWh:
        return tr("mWh");

    default:
        return tr("Unknown");
    }
}

QString QCBatteryInfo::getRemainingString() const
{
    return (isCharging() ? tr("Charging...") : tr("Remaining Time"));
}

QString QCBatteryInfo::getRemainingTime() const
{
    int remainingCapacity = iBatteryInfo->remainingCapacity();
    int flow = iBatteryFlow->getFlow();
    float hours;

    if (flow == 0)
        return tr("Unknown");

    if (isCharging()) {
        hours = (float) abs(getRoundCapacity() - remainingCapacity) / abs(flow);
    } else {
        hours = (float) remainingCapacity / abs(flow);
    }

    return formatDateTime(round(hours * 60 * 60 * 1000), isCharging());
}

QString QCBatteryInfo::getChargerType() const
{
    return checkChargerType(iBatteryInfo->chargerType());
}

QString QCBatteryInfo::getChargingTime() const
{
    return formatOldDateTime(tChargingTime);
}

QString QCBatteryInfo::getLastChargerType() const
{
    return checkChargerType(sLastChargerType);
}

QString QCBatteryInfo::getLastChargingTime() const
{
    return formatOldDateTime(sLastChargingTime);
}

int QCBatteryInfo::getRoundLevel() const
{
    int remainingCapacity = iBatteryInfo->remainingCapacity();
    int calcLevel = (int) (remainingCapacity * 100) / getRoundCapacity();

    return (calcLevel > 100) ? 100 : calcLevel;
}

int QCBatteryInfo::getRoundCapacity() const
{
    int nominalCapacity = iBatteryInfo->nominalCapacity();
    float maxCapacity = (float) (nominalCapacity - (nominalCapacity * errorAverage));

    return round(maxCapacity);
}

int QCBatteryInfo::getLastLevel() const
{
    return sLastBatteryLevel;
}

QString QCBatteryInfo::formatDateTime(long milliseconds, bool charger) const
{
    if (milliseconds <= 0)
        return tr("Unknown");

    //int seconds = (milliseconds / 1000) % 60;
    int minutes = (milliseconds / (1000 * 60)) % 60;
    int hours   = (milliseconds / (1000 * 60 * 60)) % 24;
    int days    = (milliseconds / (1000 * 60 * 60 * 24));

    //var isSeconds = (days == 0 && hours == 0 && minutes == 0)
    bool isMinutes = (days == 0 && hours == 0);
    bool isHours   = (days == 0 && minutes == 0);
    bool isDays    = (hours == 0 && minutes == 0);

    QString minutesStr = "";
    QString hoursStr   = "";
    QString dayStr     = "";

    if (minutes > 0) {
        minutesStr = QString("%1 ").arg(QString::number(minutes));

        if (isMinutes) {
            minutesStr += (minutes == 1) ? tr("Minute") : tr("Minutes");
        } else {
            minutesStr += tr("m");
        }
    }

    if (hours > 0) {
        hoursStr = QString("%1 ").arg(QString::number(hours));

        if (isHours) {
            hoursStr += (hours == 1) ? tr("Hour") : tr("Hours");
        } else {
            hoursStr += tr("h");
        }
    }

    if (days > 0) {
        dayStr = QString("%1 ").arg(QString::number(days));

        if (isDays) {
            dayStr += (days == 1) ? tr("Day") : tr("Days");
        } else {
            dayStr += tr("d");
        }
    }

    minutesStr = (charger && isMinutes && minutes < 5) ? tr("~5 Minutes") : minutesStr;

    QString space1 = (days > 0 && (hours > 0 || minutes > 0)) ? " " : "";
    QString space2 = (hours > 0 && minutes > 0) ? " " : "";

    QString formattedTime = QString("%1%2%3%4%5").arg(dayStr, space1 ,hoursStr, space2, minutesStr);

    return formattedTime;
}

QString QCBatteryInfo::formatOldDateTime(QDateTime dateTime) const
{
    if (dateTime.isNull())
        return tr("Unknown");

    QDateTime newDateTime = QDateTime::currentDateTime();
    long milliseconds = abs(newDateTime.msecsTo(dateTime));

    if (milliseconds < 60000)
        return tr("Now");

    return formatDateTime(milliseconds, false);
}

QString QCBatteryInfo::checkChargerType(int type) const
{
    switch (type) {
    case QSystemBatteryInfo::NoCharger:
        return tr("No Charger");

    case QSystemBatteryInfo::WallCharger:
        return tr("Wall Charger");

    case QSystemBatteryInfo::USBCharger:
        return tr("USB Charger");

    case QSystemBatteryInfo::USB_500mACharger:
        return tr("USB (500 mA) Charger");

    case QSystemBatteryInfo::USB_100mACharger:
        return tr("USB (100 mA) Charger");

    case QSystemBatteryInfo::VariableCurrentCharger:
        return tr("Variable Charger (Bicycle Or Solar)");

    case QSystemBatteryInfo::UnknownCharger:
        return tr("Unknown Charger");

    default:
        return tr("Unknown");
    }
}

void QCBatteryInfo::monitorConnection()
{
    int level = 0;

    switch (pLevelType) {
    default:
    case CommonType::RealLevel:
        level = getRoundLevel();
        break;

    case CommonType::SystemLevel:
        level = iDeviceInfo->batteryLevel();
        break;
    }

    if (level != currLevel) {
        currLevel = level;
        emit levelChanged();
    }

    int capacity = iBatteryInfo->remainingCapacity();
    if (capacity != currCapacity) {
        currCapacity = capacity;
        emit capacityChanged();
    }

    // Notify Battery Low
    bool low = (level <= 20);
    if (nLow && low) {
        nLow = false;
        emit lowNotify();
    }

    // Notify Battery Very Low
    bool veryLow = (level <= 10);
    if (nVeryLow && veryLow) {
        nVeryLow = false;
        emit veryLowNotify();
    }
}

void QCBatteryInfo::onChargingStateChanged(QSystemBatteryInfo::ChargingState state)
{
    iBatteryFlow->refreshFlow();
    emit chargingChanged();

    switch (state) {
    case QSystemBatteryInfo::Charging: {
        tChargingTime = QDateTime::currentDateTime();
        tLastChargerType = iBatteryInfo->chargerType();

        tCharging = true;
        nLow = false;
        nVeryLow = false;
    }
        break;

    case QSystemBatteryInfo::NotCharging: {
        if (tCharging) {
            qDebug() << "QSystemBatteryInfo::NotCharging";

            qDebug() << "Sleeping 100 millsec...";
            qSleep(100);
            qDebug() << "iDeviceInfo->currentPowerState() = " << iDeviceInfo->currentPowerState();

            sLastChargingTime = QDateTime::currentDateTime();
            sLastChargerType = tLastChargerType;
            sLastBatteryLevel = getRoundLevel();

            iAppSettings->setLastChargingTime(sLastChargingTime);
            iAppSettings->setLastChargerType(sLastChargerType);
            iAppSettings->setLastBatteryLevel(sLastBatteryLevel);

            qDebug() << "iDeviceInfo->currentPowerState() = " << iDeviceInfo->currentPowerState();

            // Notify Full Charged
            if (iDeviceInfo->currentPowerState() == QSystemDeviceInfo::WallPower) {
                qDebug() << "emit fullChargedNotify()";
                qDebug() << "Calculate Error Average";

                emit fullChargedNotify();

                // Calculate Error Average
                int nominalCapacity = iBatteryInfo->nominalCapacity();
                int remainingCapacity = iBatteryInfo->remainingCapacity();

                if (nominalCapacity != 0) {
                    errorAverage = (float) ((float) remainingCapacity / nominalCapacity) * 0.1;
                }

                iAppSettings->setErrorAverage(errorAverage);

                qDebug() << "Error Average = " << errorAverage;
            }

            tCharging = false;
            nLow = true;
            nVeryLow = true;
        }
    }
        break;
    }
}
