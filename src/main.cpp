/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QDeclarativeEngine>
#include <QDeclarativeComponent>
#include <QDeclarativeContext>
#include <QtCore>
#include <QtCore/QTranslator>
#include <QtCore/QLocale>
#include <QtCore/QFile>

#ifdef Q_OS_SYMBIAN
 #include <QtGui/QSplashScreen>
 #include <QtGui/QPixmap>
 #include "qpsmode.h"
 #include "qbatteryhswidget.h"
 #include "qsymbianhelper.h"
 #include "qbatteryflow.h"
 #include "qsymbianapplication.h"
 #include "qappsettings.h"
 #include "qcbatteryinfo.h"
 #include "qglobalnote.h"
 #include "qdevicename.h"
#endif

#include "qmsghandler.h"
#include "commontype.h"

// http://doc.qt.digia.com/qtquick-components-symbian-1.1/symbian-components-functional.html
// http://qt-project.org/wiki/How_to_do_dynamic_translation_in_QML
// http://developer.nokia.com/Community/Wiki/Detecting_focus_lost_%26_gained_events_in_Qt_for_Symbian

//#include "main.moc"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    int currentExitCode = 0;

    QScopedPointer<QSymbianApplication> app(new QSymbianApplication(argc, argv));

    // Set App Info:
    app->setApplicationName("Battery Status");
    app->setOrganizationName("Motaz Alnuweiri");
    app->setApplicationVersion(APP_Version);

    // QT_DEBUG or QT_NO_DEBUG
//    #ifdef QT_DEBUG
//        // Install Debug Msgs Handler:
//        ClearDebugFile();
//        qInstallMsgHandler(DebugFileHandler);
//    #endif

    // Install EventFilter in QApplication:
    //app->installEventFilter(new myEventFilter);

    // Set App Splash Screen:
    QSplashScreen *splash = new QSplashScreen(QPixmap(":qml/Images/JPG/Splash_Screen.jpg"),
                                              Qt::WindowStaysOnTopHint);
    splash->show();

    // Check System Language & Load App Translator:
    QString systemLang = QLocale::system().name();
    QTranslator appTranslator;

    systemLang.truncate(2); //truncate(2) to ignore the country code

    if (QFile::exists("Languages/batterystatus_" + systemLang + ".qm")) {
        appTranslator.load("batterystatus_" + systemLang, "Languages");
    } else {
        appTranslator.load("batterystatus_en", "Languages");
    }

    // Install QTranslator to QApplication:
    app->installTranslator(&appTranslator);

    // Hide The App If Deactive:
    if (!app->foreground())
        QSymbianHelper::hideInBackground();

    // Register QSettings:
    QAppSettings appSettings;

    // Register QmlApplicationViewer:
    QmlApplicationViewer *viewer = new QmlApplicationViewer();
    //viewer.setResizeMode(QmlApplicationViewer::SizeRootObjectToView);
    //viewer.setAutoFillBackground(false);
    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);

    // Register App HSWidget:
    QBatteryHSWidget *batteryHSWidget = new QBatteryHSWidget();
    batteryHSWidget->setBackgroundOpacity(appSettings.getWidgetOpacity());

    // Register QDeviceName:
    QDeviceName deviceName;

    // Register Class to QML:
    qmlRegisterType<QPSMode>("PSMode", 1, 0, "PSMode");
    qmlRegisterType<QGlobalNote>("GlobalNote", 1, 0, "GlobalNote");
    qmlRegisterType<QCBatteryInfo>("CBatteryInfo", 1, 0, "CBatteryInfo");
    qmlRegisterType<CommonType>("CommonType", 1, 0, "CommonType");

    // Set Propertys to QML:
    viewer->rootContext()->setContextProperty("APPName", QObject::tr("Battery Status"));
    viewer->rootContext()->setContextProperty("APPVersion", app->applicationVersion());
    viewer->rootContext()->setContextProperty("AppPath", app->applicationDirPath());
    viewer->rootContext()->setContextProperty("SymbianHelper", new QSymbianHelper);
    viewer->rootContext()->setContextProperty("AppSettings", &appSettings);
    viewer->rootContext()->setContextProperty("HSWidget", batteryHSWidget);
    viewer->rootContext()->setContextProperty("DeviceName", &deviceName);
    viewer->rootContext()->setContextProperty("QApp", app->instance());

    viewer->setSource(QUrl(QLatin1String("qrc:qml/main.qml")));
    //viewer.setSource(QUrl::fromLocalFile("qrc:qml/main.qml"));

    // Lock screen orientation in portrait only
    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);

    //viewer.setGeometry(app->desktop()->screenGeometry());
    viewer->showFullScreen();

    // Stop Splash Screen & Delete It:
    splash->finish(viewer);
    splash->deleteLater();

    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);

    // Enter App Event Loop:
    currentExitCode = app->exec();

    // Cleun Pointers:
    delete viewer;
    delete batteryHSWidget;

    // Check If App Is Restarting:
    if(app->isRestarting()) {
        // Workround for my app to restart it self
        QProcess::startDetached(qApp->applicationFilePath());
    }

    return currentExitCode;
}
