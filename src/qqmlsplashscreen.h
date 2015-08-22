/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QQMLSPLASHSCREEN_H
#define QQMLSPLASHSCREEN_H

#include <QObject>
#include "qmlapplicationviewer.h"

class QDeclarativeItem;
class QmlApplicationViewer;
//class QDeclarativeView;

class QQMLSplashScreen : public QObject
{
    Q_OBJECT

public:
    QQMLSplashScreen(QmlApplicationViewer *view);

public:
    void load(QString splashQmlFile);

public slots:
    void finish();
    void destroy();

protected:
    QmlApplicationViewer *m_View; // Not owned
    QDeclarativeItem *m_SplashItem; // Not owned
};

#endif // QQMLSPLASHSCREEN_H
