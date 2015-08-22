/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1

QueryDialog {
    id: resetDialog
    titleText: qsTr("Reset Application Data")
    icon: "Images/PNG/Msg_Warning.png"
    platformInverted: window.platformInverted
    acceptButtonText : qsTr("Yes")
    rejectButtonText : qsTr("No")
    message : qsTr("The application will remove:") + "\n\n" +
              qsTr("Settings") + "\n" +
              qsTr("Data stored") + "\n\n" +
              qsTr("And will restart, Do you want to continue?")

    onAccepted: {
        AppSettings.clear()
        QApp.restart()
    }

    // Code for dynamic load
    Component.onCompleted: {
        open()
        isCreated = true
    }

    property bool isCreated: false
    onStatusChanged: {
        if (isCreated && status === DialogStatus.Closed) {
            resetDialog.destroy()
        }
    }
}
