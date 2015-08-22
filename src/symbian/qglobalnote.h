/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QGLOBALNOTE_H
#define QGLOBALNOTE_H

#include <QObject>
#include <QTimer>
#include <QDebug>
#include <aknglobalnote.h>

class QGlobalNote : public QObject
{
    Q_OBJECT

    Q_PROPERTY(GlobalNoteType noteType READ getNoteType WRITE setNoteType)
    Q_PROPERTY(QString message READ getMessage WRITE setMessage)

    Q_ENUMS(GlobalNoteType)

public:
    explicit QGlobalNote(QObject *parent = 0);

    enum GlobalNoteType {
        GlobalInformationNote = 1,
        GlobalWarningNote,
        GlobalConfirmationNote,
        GlobalErrorNote,
        GlobalChargingNote,
        GlobalWaitNote,
        GlobalPermanentNote,
        GlobalNotChargingNote,
        GlobalBatteryFullNote,
        GlobalBatteryLowNote,
        GlobalRechargeBatteryNote,
        CancelGlobalNote,
        GlobalTextNote,
        GlobalBatteryFullUnplugNote = 105,
        GlobalUnplugChargerNote
    };

public:
    GlobalNoteType getNoteType();
    void setNoteType(GlobalNoteType type);

    QString getMessage();
    void setMessage(QString message);

private:
    void ShowGlobalNoteL();

public slots:
    void show();

signals:
    void showing();

private:
    QString pMessage;
    GlobalNoteType pNoteType;
    
};

#endif // QGLOBALNOTE_H
