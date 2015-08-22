/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1
import "Components"

CommonDialog {
    id: aboutDialog
    titleText: qsTr("About")
    //titleIcon: "Images/PNG/Msg_Info.png"
    privateCloseIcon: true
    buttonTexts: [qsTr("OK")]
    platformInverted: AppSettings.getInvertedStyle()

    AppStyle { id: appStyle }

    onButtonClicked: accept()

    // Code for dynamic load
    Component.onCompleted: {
        open()
        isCreated = true
    }

    property bool isCreated: false
    onStatusChanged: {
        if (isCreated && status === DialogStatus.Closed) {
            aboutDialog.destroy()
        }
    }

    content: Item {
        height: Math.min(mainColumn.maxHeight, aboutDialog.platformContentMaximumHeight)

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Flickable {
            id: flickable
            width: parent.width
            height: parent.height
            anchors { left: parent.left; top: parent.top }
            contentHeight: mainColumn.maxHeight
            flickableDirection: Flickable.VerticalFlick
            clip: true
            interactive: contentHeight > height

            Column {
                id: mainColumn
                spacing: appStyle.spaceLarge

                property int maxHeight: height + anchors.topMargin

                anchors {
                    top: parent.top
                    topMargin: appStyle.paddingLarge
                    left: parent.left
                    leftMargin: appStyle.paddingLarge
                    right: parent.right
                    rightMargin: appStyle.paddingLarge
                }

                Item {
                    id: infoItem
                    implicitHeight: Math.max(aboutImage.implicitHeight, aboutColumn.implicitHeight)
                    anchors { left: parent.left; right: parent.right }

                    Image {
                        id: aboutImage
                        width: appStyle.guiImageSizeSmall
                        height: appStyle.guiImageSizeSmall
                        source: "Images/PNG/Msg_Info.png"
                        anchors { top: parent.top; left: parent.left }
                    }

                    Column {
                        id: aboutColumn
                        spacing: appStyle.spaceMedium

                        anchors {
                            left: aboutImage.right
                            leftMargin: appStyle.paddingMedium
                            right: parent.right
                            rightMargin: appStyle.paddingMedium
                        }

                        Label {
                            id: aboutTitleLabel
                            text: APPName
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignLeft
                            platformInverted: aboutDialog.platformInverted
                            font { pixelSize: appStyle.fontSizeLarge; bold: true }
                            anchors { left: parent.left; right: parent.right }
                        }

                        Label {
                            id: aboutVersionLabel
                            text: qsTr("Version: <b>%1</b>").arg(APPVersion)
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignLeft
                            platformInverted: aboutDialog.platformInverted
                            font.pixelSize: appStyle.fontSizeSmall
                            anchors { left: parent.left; right: parent.right }
                        }

                        Label {
                            id: aboutAuthorLabel
                            text: qsTr("Developer: <b>Motaz Alnuweiri</b>")
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignLeft
                            platformInverted: aboutDialog.platformInverted
                            font.pixelSize: appStyle.fontSizeSmall
                            anchors { left: parent.left; right: parent.right }
                        }

                        Label {
                            id: aboutPublisherLabel
                            text: qsTr("Publisher: <b>Allstar Software</b>")
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignLeft
                            platformInverted: aboutDialog.platformInverted
                            font.pixelSize: appStyle.fontSizeSmall
                            anchors { left: parent.left; right: parent.right }
                        }
                    }
                }

                LineItem { platformInverted: aboutDialog.platformInverted }

                Column {
                    id: contactMe
                    spacing: appStyle.spaceMedium

                    anchors {
                        left: parent.left
                        leftMargin: appStyle.paddingMedium
                        right: parent.right
                        rightMargin: appStyle.paddingMedium
                    }

                    LinkLabel {
                        id: facebook
                        text: "Motaz Alnuweiri"
                        link: "https://www.facebook.com/motaz.alnuweiri"
                        image: appStyle.getImagePath("Images/PNG/Facebook", "png", false)
                        platformInverted: aboutDialog.platformInverted
                        anchors { left: parent.left; right: parent.right }
                    }

                    LinkLabel {
                        id: email
                        text: qsTr("Email me")
                        link: "mailto:motaz.alnuweiri@hotmail.com"
                        image: appStyle.getImagePath("Images/PNG/Email", "png", false)
                        platformInverted: aboutDialog.platformInverted
                        anchors { left: parent.left; right: parent.right }
                    }
                }

                LineItem { platformInverted: aboutDialog.platformInverted }

                Item {
                    id: copyrightItem
                    implicitHeight: Math.max(copyrightImage.implicitHeight, aboutCopyrightLabel.implicitHeight)
                    anchors { left: parent.left; right: parent.right }

                    Image {
                        id: copyrightImage
                        width: appStyle.guiImageSizeSmall
                        height: appStyle.guiImageSizeSmall
                        source: appStyle.getImagePath("Images/PNG/Copyright", "png", aboutDialog.platformInverted)
                        anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                    }

                    Label {
                        id: aboutCopyrightLabel
                        text: qsTr("Copyright (C) 2015, All Rights Reserved.")
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WordWrap
                        platformInverted: aboutDialog.platformInverted

                        anchors {
                            left: copyrightImage.right
                            leftMargin: appStyle.paddingMedium
                            right: parent.right
                            rightMargin: appStyle.paddingMedium
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }

            }

        }

        ScrollBar {
            id: scrollBar
            height: parent.height
            anchors { top: flickable.top; right: flickable.right }
            flickableItem: flickable
            interactive: false
            orientation: Qt.Vertical
            platformInverted: aboutDialog.platformInverted
        }
    }
}
