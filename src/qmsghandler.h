/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QMSGHANDLER_H
#define QMSGHANDLER_H

#include <QApplication>
#include <QFile>
#include <QFileInfo>
#include <QTextStream>
#include <QDateTime>

QString GetAppName()
{
    QString appName = qApp->applicationName();

    if (appName.isEmpty() || appName.isNull()) {
        QFileInfo appFileInfo(qApp->applicationFilePath());
        appName = appFileInfo.bundleName();
    }

    appName = appName.replace(" ", "");

    return appName;
}

void ClearDebugFile()
{
    QFile debugFile("C:/Data/" + GetAppName() + "Debug.txt");

    if(debugFile.exists()) {
        debugFile.remove();
    }
}

void DebugFileHandler(QtMsgType type, const char *msg)
{
    QString nowDateTime = QDateTime::currentDateTime().toString("dd/M/yyyy hh:mm:ss");
    QFile debugFile("C:/Data/" + GetAppName() + "Debug.txt");

    if (debugFile.open(QFile::WriteOnly | QFile::Text | QFile::Append)) {
        QTextStream inStream(&debugFile);

        QString qmsg = QString(msg);

        if (qmsg.startsWith("\n")) {
            qmsg = qmsg.remove(0,2);
            inStream << "\n" + QString("-").repeated(40);
        }

        switch (type) {
        case QtDebugMsg:
            inStream << "\n" + nowDateTime + " |Debug| " + qmsg;
            break;
        case QtWarningMsg:
            inStream << "\n" + nowDateTime + " |Warning| " + qmsg;
            break;
        case QtCriticalMsg:
            inStream << "\n" + nowDateTime + " |Critical| " + qmsg;
            break;
        case QtFatalMsg:
            inStream << "\n" + nowDateTime + " |Fatal| " + qmsg;
            break;
            //abort();
        }

        debugFile.flush();
        debugFile.close();
    }
}

#endif // QMSGHANDLER_H
