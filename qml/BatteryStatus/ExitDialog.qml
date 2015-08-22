/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1

QueryDialog {
    id: exitDialog
    titleText: qsTr("Exit")
    icon: "Images/PNG/Msg_Question.png"
    acceptButtonText : qsTr("Exit")
    rejectButtonText : qsTr("Hide")
    platformInverted: AppSettings.getInvertedStyle()
    message : qsTr("The application needs to run in the background to update the home screen widget")

    onAccepted: Qt.quit()
    onRejected: SymbianHelper.hideInBackground()

    // Code for dynamic load
    Component.onCompleted: {
        open()
        isCreated = true
    }

    property bool isCreated: false
    onStatusChanged: {
        if (isCreated && status === DialogStatus.Closed) {
            exitDialog.destroy()
        }
    }
}
