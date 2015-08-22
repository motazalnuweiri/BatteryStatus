/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMobility.feedback 1.1
import ".."

Item {
    id: root

    AppStyle { id: appStyle }

    property alias text: text1.text
    property alias checked: switch1.checked
    property bool platformInverted: false
    implicitHeight: Math.max(text1.implicitHeight, switch1.implicitHeight, appStyle.listItemSize)
                    + appStyle.paddingSmall

    anchors {
        left: parent.left
        leftMargin: appStyle.paddingLarge
        right: parent.right
        rightMargin: appStyle.paddingLarge
    }

    Label {
        id: text1
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        platformInverted: root.platformInverted

        anchors {
            left: parent.left
            right: switch1.left
            rightMargin: appStyle.paddingMedium
            verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        ThemeEffect{ id: swipeEffect; effect: ThemeEffect.CheckBox }

        anchors.fill: parent
        onClicked: {
            swipeEffect.play()
            switch1.checked = !switch1.checked
        }
    }

    Switch {
        id: switch1
        platformInverted: root.platformInverted
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
    }
}
