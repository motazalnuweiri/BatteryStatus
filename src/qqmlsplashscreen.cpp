/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qqmlsplashscreen.h"
#include <QtDeclarative>

/*!
  \class QQMLSplashScreen
  \brief Handles the loading of the splash screen.
*/

/*!
  Constructor.
*/
QQMLSplashScreen::QQMLSplashScreen(QmlApplicationViewer *view)
    : m_View(view)
{
}

/*!
  Loads splash screen, also connects the splash screens hidden signal to this
  objects destroySplashScreen slot, so when the splash screen has animated
  away it will be destroyed.
*/
void QQMLSplashScreen::load(QString splashQmlFile)
{
    //Lock screen orientation to Portrait
    m_View->setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);

    QDeclarativeComponent splashComponent(m_View->engine(), QUrl(splashQmlFile.toLatin1()));

    m_SplashItem = qobject_cast<QDeclarativeItem *>(splashComponent.create());

    m_SplashItem->setWidth(m_View->width());
    m_SplashItem->setHeight(m_View->height());

    connect(m_SplashItem, SIGNAL(hidden()), this, SLOT(destroy()),
            Qt::QueuedConnection);

    m_View->scene()->addItem(m_SplashItem);
}

/*!
  Finish loading the splash screen
*/
void QQMLSplashScreen::finish()
{
    // Begin the hide animation of the splash screen
    QMetaObject::invokeMethod(m_SplashItem, "startHideAnimation");
}

/*!
  Destroys the splash screen.
*/
void QQMLSplashScreen::destroy()
{
    m_View->scene()->removeItem(m_SplashItem);
    delete m_SplashItem;
    m_SplashItem = 0;

    //Unlock screen orientation
    m_View->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
}
