/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QCBATTERYINFO_H
#define QCBATTERYINFO_H

#include <QObject>
#include <QSystemBatteryInfo>
#include <QSystemDeviceInfo>
#include <QDateTime>
#include <QTimer>
#include "math.h"
#include "qbatteryflow.h"
#include "qappsettings.h"
#include "commontype.h"

using namespace QtMobility;

class QCBatteryInfo : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool monitorFlow READ monitorFlow WRITE startMonitorFlow)
    Q_PROPERTY(CommonType::LevelType levelType READ levelType WRITE setLevelType)

public:
    explicit QCBatteryInfo(QObject *parent = 0);
    ~QCBatteryInfo();

    void startMonitorFlow(bool on);
    bool monitorFlow();

    void setLevelType(CommonType::LevelType value);
    CommonType::LevelType levelType();

    Q_INVOKABLE int getLevel() const;
    Q_INVOKABLE int getFlow() const;
    Q_INVOKABLE int getCapacity() const;
    Q_INVOKABLE int getFullCapacity() const;
    Q_INVOKABLE float getVoltage() const;
    Q_INVOKABLE bool isCharging() const;
    Q_INVOKABLE QString getLevelColor() const;
    Q_INVOKABLE QString getEnergyUnit() const;
    Q_INVOKABLE QString getRemainingString() const;
    Q_INVOKABLE QString getRemainingTime() const;
    Q_INVOKABLE QString getChargerType() const;
    Q_INVOKABLE QString getChargingTime() const;

    Q_INVOKABLE int getLastLevel() const;
    Q_INVOKABLE QString getLastChargerType() const;
    Q_INVOKABLE QString getLastChargingTime() const;

private:
    int getRoundLevel() const;
    int getRoundCapacity() const;
    QString formatDateTime(long milliseconds, bool charger) const;
    QString formatOldDateTime(QDateTime dateTime) const;
    QString checkChargerType(int type) const;

signals:
    void levelChanged();
    void flowChanged();
    void capacityChanged();

    void fullChargedNotify();
    void lowNotify();
    void veryLowNotify();

    void chargingChanged();

//public slots:

private slots:
    void monitorConnection();
    void onChargingStateChanged(QSystemBatteryInfo::ChargingState);

private:
    QSystemBatteryInfo *iBatteryInfo;
    QSystemDeviceInfo *iDeviceInfo;
    QBatteryFlow *iBatteryFlow;
    QAppSettings *iAppSettings;
    QTimer *iTimer;

    bool tCharging;
    QDateTime tChargingTime;
    int tLastChargerType;

    bool pMonitoringFlow;
    CommonType::LevelType pLevelType;

    float errorAverage;

    int currLevel;
    int currCapacity;

    QDateTime sLastChargingTime;
    int sLastChargerType;
    int sLastBatteryLevel;

    bool nLow;
    bool nVeryLow;
    
};

#endif // QCBATTERYINFO_H
