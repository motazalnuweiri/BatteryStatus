/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1
import ".."

ListHeading {
    id: root

    AppStyle { id: appStyle }

    property alias text: label1.text
    anchors { left: parent.left; right: parent.right }

    Label {
        id: label1
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: appStyle.fontSizeSmall
        platformInverted: root.platformInverted
        elide: Text.ElideRight

        anchors {
            left: parent.left
            leftMargin: appStyle.paddingMedium
            right: parent.right
            rightMargin: appStyle.paddingMedium
            verticalCenter: parent.verticalCenter
        }
    }
}
