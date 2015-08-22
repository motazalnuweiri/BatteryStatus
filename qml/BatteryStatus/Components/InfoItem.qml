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
    property alias titleFont: titleLabel.font

    property alias value: valueLabel.text
    property alias valueColor: valueLabel.color
    property alias valueFont: valueLabel.font
    property alias valueWrap: valueLabel.wrapMode

    implicitWidth: 200
    implicitHeight: Math.max(image1.implicitHeight, column1.implicitHeight, appStyle.listItemSize)
                    + appStyle.paddingSmall

    Image {
        id: image1

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
    }

    Column {
        id: column1
        spacing: 2
        anchors {
            left: image1.right
            leftMargin: appStyle.paddingSmall
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        Label {
            id: titleLabel
            platformInverted: root.platformInverted
            color: platformInverted ? appStyle.colorTextMidInverted : appStyle.colorTextMid
            font.pixelSize: appStyle.fontSizeSmall
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            anchors { left: parent.left; right: parent.right }
        }

        Label {
            id: valueLabel
            platformInverted: root.platformInverted
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            anchors { left: parent.left; right: parent.right }
        }
    }
}
