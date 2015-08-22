/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1
//import com.nokia.extras 1.1
import "Components"

// http://doc.qt.digia.com/qtquick-components-symbian-1.1/symbian-components-functional.html
// http://qt-project.org/wiki/How_to_do_dynamic_translation_in_QML

PageStackWindow {
    id: window
    initialPage: MainPage { tools: toolBarLayout }
    LayoutMirroring.enabled: symbian.rightToLeftDisplayLanguage
    LayoutMirroring.childrenInherit: true
    //LayoutMirroring.enabled: LangCode == "ar" ? true : false
    platformInverted: AppSettings.getInvertedStyle()

    AppStyle { id: appStyle }

    QtObject{
        id:dialogLoader

        property Component item: null

        function load(qmlfile){
            item = Qt.createComponent(qmlfile)
            item.createObject(pageStack.currentPage)
        }
    }

    Image {
        source: "Images/PNG/Corner_TopLeft.png"
        LayoutMirroring.enabled: false

        anchors {
            top: parent.top
            topMargin: window.showStatusBar ? appStyle.stateBarHeight : 0
            left: parent.left
        }
    }

    Image {
        source: "Images/PNG/Corner_TopRight.png"
        LayoutMirroring.enabled: false

        anchors {
            top: parent.top
            topMargin: window.showStatusBar ? appStyle.stateBarHeight : 0
            right: parent.right
        }
    }

    Image {
        source: "Images/PNG/Corner_BottomLeft.png"
        LayoutMirroring.enabled: false

        anchors {
            bottom: parent.bottom
            left: parent.left
        }
    }

    Image {
        source: "Images/PNG/Corner_BottomRight.png"
        LayoutMirroring.enabled: false

        anchors {
            bottom: parent.bottom
            right: parent.right
        }
    }

    Connections {
        target: pageStack.currentPage
        ignoreUnknownSignals: true

        onStyleChanged: {
            window.platformInverted = pageStack.currentPage.platformInverted
        }

        onSettingsSaved: {
            initialPage.updateItems()
        }
    }

    Item {
        id: appTitleItem
        anchors.left: parent.left
        width: parent.width - 180
        clip: true
        implicitHeight: appTitleLabel.height

        Label {
            id: appTitleLabel
            maximumLineCount: 1
            text: pageStack.currentPage.title
            visible: showStatusBar

            anchors {
                top: parent.top
                left: parent.left
                leftMargin: 4
            }

//            Behavior on text {
//                PropertyAnimation {
//                    duration: 200
//                    easing.type: Easing.InOutQuad
//                }
//            }
        }

        Rectangle {
            width: 25
            rotation: -90
            visible: appTitleLabel.width > parent.width ? true : false
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#00000000"
                }

                GradientStop {
                    position: 1
                    color: "#000000"
                }
            }
            anchors {
                top: parent.top
                bottom: parent.bottom
                bottomMargin: -40
                right: parent.right
                rightMargin: 60
            }
        }
    }

    Menu {
        id: mainMenu
        platformInverted: window.platformInverted

        content: MenuLayout {

            MenuItemWithIcon {
                id: optionsItem
                text: qsTr("Settings")
                image: appStyle.getImagePath("Images/SVG/Menu_Settings", "svg", platformInverted)
                platformInverted: mainMenu.platformInverted
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            MenuItemWithIcon {
                id: aboutItem
                text: qsTr("About")
                image: appStyle.getImagePath("Images/SVG/Menu_Info", "svg", platformInverted)
                platformInverted: mainMenu.platformInverted
                onClicked: dialogLoader.load("AboutDialog.qml")
            }

            MenuItemWithIcon {
                id: exitItem
                text: qsTr("Exit")
                image: appStyle.getImagePath("Images/SVG/Menu_Exit", "svg", platformInverted)
                platformInverted: mainMenu.platformInverted
                onClicked: {
                    if (HSWidget.isRunning()) {
                        dialogLoader.load("ExitDialog.qml")
                    } else {
                        Qt.quit()
                    }
                }
            }
        }
    }

    ToolBarLayout {
        id: toolBarLayout

        ToolButton {
            id: exitMenu
            platformInverted: window.platformInverted
            iconSource: "toolbar-back"
            onClicked: pageStack.depth <= 1 ? SymbianHelper.hideInBackground() : window.pageStack.pop()

            ToolTipEx {
                text: pageStack.depth <= 1 ? qsTr("Hide") : qsTr("Back")
                platformInverted: parent.platformInverted
            }
        }

        ToolButton {
            id: menu
            platformInverted: window.platformInverted
            iconSource: "toolbar-menu"
            onClicked: mainMenu.open()

            ToolTipEx {
                text: qsTr("Menu")
                platformInverted: parent.platformInverted
            }
        }
    }
}
