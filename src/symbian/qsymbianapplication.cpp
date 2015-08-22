/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qsymbianapplication.h"

QSymbianApplication::QSymbianApplication(int argc, char** argv) :
    QApplication(argc, argv), iForeground(false), iIsRestarting(false)
{
}

bool QSymbianApplication::foreground()
{
    return iForeground;
}

bool QSymbianApplication::isRestarting()
{
    return iIsRestarting;
}

bool QSymbianApplication::symbianEventFilter(const QSymbianEvent *event)
{
    if (event->type() == QSymbianEvent::WindowServerEvent) {
        switch (event->windowServerEvent()->Type()) {
        case KAknUidValueEndKeyCloseEvent: {
            QSymbianHelper::hideInBackground();
            return true;
        }

        case EEventFocusGained: {
            iForeground = true;
            emit foregroundChanged(iForeground);

            if (QSymbianHelper::isHide())
                QSymbianHelper::setHide(false);
        }
            break;

        case EEventFocusLost: {
            iForeground = false;
            emit foregroundChanged(iForeground);
        }
            break;
        }
    }
    else if (event->type() == QSymbianEvent::CommandEvent) {
        if (event->command() == EEikCmdExit) {
            QSymbianHelper::hideInBackground();
            return true;
        }
    }

    return QApplication::symbianEventFilter(event);
}

void QSymbianApplication::restart()
{
    iIsRestarting = true;
    emit aboutToRestart();

    //QProcess::startDetached(qApp->applicationFilePath());
    this->exit(12);
}
