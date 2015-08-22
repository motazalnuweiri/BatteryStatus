/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef PSMMODE_H
#define PSMMODE_H

#include <QObject>
#include <QTimer>

class QPSModePrivate;

class QPSMode : public QObject
{
    Q_OBJECT
public:
    explicit QPSMode(QObject *parent = 0);
    virtual ~QPSMode();

    Q_INVOKABLE void enable();
    Q_INVOKABLE void disable();
    Q_INVOKABLE bool isEnable();

signals:
    void statusChanged();

private:
    QPSModePrivate *d_ptr;
    friend class QPSModePrivate;
};

#endif // PSMMODE_H
