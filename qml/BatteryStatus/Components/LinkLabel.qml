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

    property alias text: titleLabel.text
    property string link: ""
    property alias image: image1.source
    property bool platformInverted: false

    implicitWidth: 200
    implicitHeight: Math.max(image1.isImage ? 0 : image1.height, titleLabel.height)
                             + (appStyle.paddingSmall * 2)

    signal linkClicked

    Rectangle {
        id: backRec
        color: root.platformInverted ? appStyle.colorTextLinkInverted : appStyle.colorTextLink
        anchors.fill: parent
        opacity: 0.0
        radius: 5
        smooth: true

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    Image {
        id: image1
        property bool isImage: source != ""

        anchors {
            left: parent.left
            leftMargin: appStyle.paddingSmall
            verticalCenter: parent.verticalCenter
        }
    }


    Label {
        id: titleLabel
        platformInverted: root.platformInverted
        color: platformInverted ? appStyle.colorTextLinkInverted : appStyle.colorTextLink
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignLeft

        anchors {
            left: image1.isImage ? image1.right : parent.left
            leftMargin: image1.isImage ? appStyle.paddingMedium : appStyle.paddingSmall
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: appStyle.paddingSmall
        }

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    MouseArea {
        anchors.fill: parent

        function linkPressed(){
            privateStyle.play(ThemeEffect.BasicButton)
            backRec.opacity = 1.0
            titleLabel.color = "white"
        }

        function linkCanceled(){
            backRec.opacity = 0.0
            titleLabel.color = root.platformInverted ? appStyle.colorTextLinkInverted : appStyle.colorTextLink
        }

        onPressed: linkPressed()
        onReleased: linkCanceled()
        onCanceled: linkCanceled()
        onExited: linkCanceled()

        onClicked: {
            Qt.openUrlExternally(root.link)
            root.linkClicked()
        }
    }
}
