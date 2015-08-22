/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QSYMBIANHELPER_H
#define QSYMBIANHELPER_H

#include <QObject>
#include <QApplication>
#include <QDir>
#include <QFile>
#include <QProcess>
#include <QClipboard>
#include <apgtask.h>
#include <eikenv.h>
#include <apgwgnam.h>
#include <aknappui.h>
#include "aknkeylock.h"

class QSymbianHelper : public QObject
{
    Q_OBJECT

public slots:
    static void run(QString process, QStringList arguments = QStringList(""));
    static void kill(QString process);
    static void copy(QString source, QString target);
    static void rename(QString file, QString newName);
    static void remove(QString file);
    static void clipboardCopy(QString text);
    static void restartApp();
    static void lockPhone();
    static void bringToForeground();
    static void sendToBackground();
    static void hideInBackground();
    static void setHide(bool value = true);
    static void setSystem(bool value = true);
    static void setHideFromFSW(bool value = true);
    static bool isHide();
    static bool isSystem();
    static bool isRightToLeft();
};

#endif // QSYMBIANHELPER_H
