/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qsymbianapplication.h"

QSymbianApplication::QSymbianApplication(int argc, char** argv) :
    QApplication(argc, argv), iForeground(false)
{
}

bool QSymbianApplication::foreground()
{
    return iForeground;
}

bool QSymbianApplication::symbianEventFilter(const QSymbianEvent *event)
{
    if (event->type() == QSymbianEvent::WindowServerEvent) {
        switch (event->windowServerEvent()->Type()) {
		// fire when press red key
        case KAknUidValueEndKeyCloseEvent: {
		    // return true will canceled the close by red key
            return true;
        }

		// fire when app is focus or in foreground
        case EEventFocusGained: {
            iForeground = true;
            emit foregroundChanged(iForeground);
        }
            break;

		// fire when app lose focus or go to background
        case EEventFocusLost: {
            iForeground = false;
            emit foregroundChanged(iForeground);
        }
            break;
        }
    }
	// fire when close the app from task manager
    else if (event->type() == QSymbianEvent::CommandEvent) {
        if (event->command() == EEikCmdExit) {
		    // return true will canceled the close by task manager
            return true;
        }
    }

    return QApplication::symbianEventFilter(event);
}
