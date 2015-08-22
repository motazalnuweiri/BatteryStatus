/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QAPPDEBUG_H
#define QAPPDEBUG_H

#include <QObject>
#include <QFile>
#include <QFileInfo>
#include <QTextStream>
#include <QDateTime>
#include <QApplication>

class QAppDebug : public QObject
{
    Q_OBJECT

public:
    static void debug(QString text) {
        QString debugFile = getAppName() + "Debug.txt";
        QString nowDateTime = QDateTime::currentDateTime().toString("dd/M/yyyy hh:mm:ss");
        QString tempText = QString("%1  |  %2").arg(nowDateTime, text);

        writeEngine(debugFile, tempText);
    }

    static void log(QString text) {
        QString logFile = getAppName() + "Log.log";
        QString nowDateTime = QDateTime::currentDateTime().toString("dd/M/yyyy hh:mm:ss");
        QString tempText = QString("%1  |  %2").arg(nowDateTime, text);

        writeEngine(logFile, tempText);
    }

    static void debugLine() {
        QString debugFile = getAppName() + "Debug.txt";
        QString tempText = "---------------------------------------------";

        writeEngine(debugFile, tempText);
    }

    static void logLine() {
        QString logFile = getAppName() + "Log.log";
        QString tempText = "---------------------------------------------";

        writeEngine(logFile, tempText);
    }

    static void clearDebug() {
        QString debugFile = getAppName() + "Debug.txt";
        clearEngine(debugFile);
    }

    static void logLine() {
        QString logFile = getAppName() + "Log.log";
        clearEngine(logFile);
    }

private:
    static void writeEngine(QString fileName, QString text) {
        fileName = fileName.replace(" ", "");
        fileName = "C:/Data/" + fileName;

        QFile file(fileName);

        if (file.open(QFile::WriteOnly | QFile::Text | QFile::Append)) {
            QTextStream inStream(&file);
            inStream << "\n" << text;
            file.flush();
            file.close();
        }
    }

    static void clearEngine(QString fileName) {
        fileName = fileName.replace(" ", "");
        fileName = "C:/Data/" + fileName;

        QFile file(fileName);

        if (file.open(QFile::WriteOnly | QFile::Text)) {
            QTextStream inStream(&file);
            inStream << "";
            file.flush();
            file.close();
        }
    }

    static QString getAppName() {
        QString appName = qApp->applicationName();
        if (appName.isEmpty() || appName.isNull()) {
            QFileInfo appFileInfo(qApp->applicationFilePath());
            return appFileInfo.bundleName();
        } else {
            return appName;
        }
    }
};

#endif // QAPPDEBUG_H
