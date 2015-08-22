Qt Symbian Event Filter:
------------------------

1- Add "qsymbianapplication.cpp" and "qsymbianapplication.h" to your project

2- In "main.cpp" add (#include "qsymbianapplication.h")

3- Replace QApplication with QSymbianApplication

   Like this:
   QScopedPointer<QSymbianApplication> app(new QSymbianApplication(argc, argv));

4- You can register QSymbianApplication as property for QML

   Like this:
   viewer->rootContext()->setContextProperty("QApp", app->instance());
   
   and Use Connections in QML to get signals

   Like this:
       Connections {
        target: QApp

        onForegroundChanged: {
           // Do something
        }

----------------------------------------
Author: Motaz Alnuweiri
Copyright (C) 2014, All rights reserved.
