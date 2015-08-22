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

    property alias text: label1.text
    property alias checked: radio1.checked
    property alias exclusiveGroup: radio1.platformExclusiveGroup
    property bool platformInverted: false
    implicitHeight: Math.max(label1.implicitHeight, radio1.implicitHeight, appStyle.listItemSize)
                    + appStyle.paddingSmall

    anchors {
        left: parent.left
        leftMargin: appStyle.paddingLarge
        right: parent.right
        rightMargin: appStyle.paddingLarge
    }

    Label {
        id: label1
        horizontalAlignment: Text.AlignLeft
        platformInverted: root.platformInverted
        elide: Text.ElideRight

        anchors {
            left: parent.left
            right: radio1.left
            rightMargin: appStyle.paddingMedium
            verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        ThemeEffect{ id: swipeEffect; effect: ThemeEffect.CheckBox }

        anchors.fill: parent
        onClicked: {
            swipeEffect.play()
            radio1.checked = true
        }
    }

    RadioButton {
        id: radio1
        platformInverted: root.platformInverted
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
    }
}
