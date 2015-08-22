/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1
import ".."

Item {
    id: root

    AppStyle { id: appStyle }

    property alias image: image1.source
    property bool platformInverted: false

    property alias title: titleLabel.text
    property alias titleColor: titleLabel.color

    property alias value: valueLabel.text
    property alias valueColor: valueLabel.color

    property bool busyVisible: false

    implicitWidth: 200
    implicitHeight: Math.max(busyVisible ? busyIndicator1.implicitHeight : image1.implicitHeight,
                                           column1.implicitHeight) + appStyle.paddingSmall

    BusyIndicator {
        id: busyIndicator1
        implicitWidth: appStyle.guiImageSizeMedium
        implicitHeight: appStyle.guiImageSizeMedium
        visible: busyVisible
        running: busyVisible
        platformInverted: root.platformInverted

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
    }

    Image {
        id: image1
        visible: !busyVisible
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
    }

    Column {
        id: column1
        spacing: 2
        anchors {
            left: busyVisible ? busyIndicator1.right : image1.right
            leftMargin: appStyle.paddingSmall
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        Label {
            id: titleLabel
            platformInverted: root.platformInverted
            font.pixelSize: appStyle.guiFontSizeSmall
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            anchors { left: parent.left; right: parent.right }
        }

        Label {
            id: valueLabel
            platformInverted: root.platformInverted
            font.pixelSize: appStyle.guiFontSizeXLarge
            font.bold: true
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            anchors { left: parent.left; right: parent.right }
        }
    }
}
