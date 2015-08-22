/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1
import Qt.labs.components 1.1
import CommonType 1.0
import "Components"

Page {
    id: settingsPage
    tools: toolBarLayout

    AppStyle { id: appStyle }

    property string title: qsTr("Settings")
    property bool platformInverted

    signal accepted
    signal rejected
    signal settingsSaved
    signal styleChanged

    function loadSettings() {
        switchListItem1.checked = AppSettings.getPSM()
        sliderListItem1.value = AppSettings.getPSMLevel()
        switchListItem2.checked = AppSettings.getFullNotify()
        switchListItem3.checked = AppSettings.getLowNotify()
        sliderListItem2.value = AppSettings.getNotifyLevel()
        sliderListItem3.value = AppSettings.getWidgetOpacity()

        switch (AppSettings.getLevelType())
        {
        case CommonType.RealLevel:
            levelRadioListItem1.checked = true
            break

        case CommonType.SystemLevel:
            levelRadioListItem2.checked = true
            break
        }

        if (AppSettings.getInvertedStyle())
        {
            styleRadioListItem2.checked = true
        }
        else
        {
            styleRadioListItem1.checked = true
        }

        platformInverted = AppSettings.getInvertedStyle()
    }

    function saveSettings() {
        AppSettings.setPSM(switchListItem1.checked)
        AppSettings.setPSMLevel(sliderListItem1.value)
        AppSettings.setFullNotify(switchListItem2.checked)
        AppSettings.setLowNotify(switchListItem3.checked)
        AppSettings.setNotifyLevel(sliderListItem2.value)
        AppSettings.setWidgetOpacity(sliderListItem3.value)

        var levelType

        if (levelRadioListItem1.checked)
        {
            levelType = CommonType.RealLevel
        }
        else if (levelRadioListItem2.checked)
        {
            levelType = CommonType.SystemLevel
        }

        AppSettings.setInvertedStyle(styleRadioListItem2.checked)
        AppSettings.setLevelType(levelType)
    }

    function changeStyle() {
        if (settingsPage.status !== PageStatus.Active)
            return

        settingsPage.platformInverted = styleRadioListItem2.checked
        styleChanged()
    }

    onAccepted: {
        saveSettings()
        settingsSaved()
    }

    onRejected: {
        loadSettings()
        styleChanged()
    }

    Component.onCompleted: {
        loadSettings()
    }

    onStatusChanged: {
        if (status === PageStatus.Inactive) {
            settingsPage.destroy()
        }
    }

    ToolBarLayout {
        id: toolBarLayout

        ToolButton {
            id: saveToolButton
            flat: false
            text: qsTr("Save")
            platformInverted: settingsPage.platformInverted

            onClicked: {
                accepted()
                pageStack.pop()
            }
        }

        ToolButton {
            id: cancelToolButton
            flat: false
            text: qsTr("Cancel")
            platformInverted: settingsPage.platformInverted

            onClicked: {
                rejected()
                pageStack.pop()
            }
        }
    }

    Flickable {
        id: mainFlickable
        clip: true
        contentHeight: mainColumn.implicitHeight
        anchors {
            top: parent.top
            //topMargin: appStyle.paddingMedium
            bottom: parent.bottom
            bottomMargin: appStyle.paddingMedium
            left: parent.left
            right: parent.right
        }

        Column {
            id: mainColumn
            clip: true
            spacing: appStyle.spaceLarge
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
            }

            HeadingListItem {
                text: qsTr("Style")
                platformInverted: settingsPage.platformInverted
            }

            CheckableGroup{  id: styleRadioGroup }

            RadioListItem {
                id: styleRadioListItem1
                text: qsTr("Dark")
                exclusiveGroup: styleRadioGroup
                platformInverted: settingsPage.platformInverted
                onCheckedChanged: changeStyle()
            }

            LineItem { platformInverted: settingsPage.platformInverted }

            RadioListItem {
                id: styleRadioListItem2
                text: qsTr("Light")
                exclusiveGroup: styleRadioGroup
                platformInverted: settingsPage.platformInverted
                onCheckedChanged: changeStyle()
            }

            HeadingListItem {
                text: qsTr("Battery Level")
                platformInverted: settingsPage.platformInverted
            }

            CheckableGroup{ id: levelRadioGroup }

            RadioListItem {
                id: levelRadioListItem1
                text: qsTr("Real level")
                exclusiveGroup: levelRadioGroup
                platformInverted: settingsPage.platformInverted
            }

            LineItem { platformInverted: settingsPage.platformInverted }

            RadioListItem {
                id: levelRadioListItem2
                text: qsTr("System level")
                exclusiveGroup: levelRadioGroup
                platformInverted: settingsPage.platformInverted
            }

            HeadingListItem {
                text: qsTr("Power Saving")
                platformInverted: settingsPage.platformInverted
            }

            SwitchListItem {
                id: switchListItem1
                text: qsTr("Auto enable")
                platformInverted: settingsPage.platformInverted
            }

            LineItem {
                height: switchListItem1.checked ? implicitHeight : 0
                platformInverted: settingsPage.platformInverted
            }

            SliderListItem {
                id: sliderListItem1
                height: switchListItem1.checked ? implicitHeight : 0
                opacity: switchListItem1.checked ? 1.0 : 0.0
                text: qsTr("Auto enable level:")
                maxValue: 100
                miniValue: 5
                stepSize: 5
                platformInverted: settingsPage.platformInverted
            }

            HeadingListItem {
                text: qsTr("Notifications")
                platformInverted: settingsPage.platformInverted
            }

            SwitchListItem {
                id: switchListItem2
                text: qsTr("Battery fully charged")
                platformInverted: settingsPage.platformInverted
            }

            LineItem { platformInverted: settingsPage.platformInverted }

            SwitchListItem {
                id: switchListItem3
                text: qsTr("Battery low")
                platformInverted: settingsPage.platformInverted
            }

            LineItem {
                height: (switchListItem2.checked + switchListItem3.checked) ? implicitHeight : 0
                platformInverted: settingsPage.platformInverted
            }

            SliderListItem {
                id: sliderListItem2
                height: (switchListItem2.checked + switchListItem3.checked) ? implicitHeight : 0
                opacity: (switchListItem2.checked + switchListItem3.checked) ? 1.0 : 0.0
                text: qsTr("Sound level:")
                maxValue: 100
                miniValue: 0
                stepSize: 10
                platformInverted: settingsPage.platformInverted
            }

            HeadingListItem {
                text: qsTr("Home Screen Widget")
                platformInverted: settingsPage.platformInverted
            }

            SliderListItem {
                id: sliderListItem3
                text: qsTr("Background opacity:")
                maxValue: 100
                miniValue: 0
                stepSize: 10
                platformInverted: settingsPage.platformInverted
            }

            HeadingListItem {
                text: qsTr("Repair")
                platformInverted: settingsPage.platformInverted
            }

            Column {
                id: itemList1
                //implicitHeight: Math.max(itemlList1Text.implicitHeight, resetButton.implicitHeight)
                spacing: appStyle.paddingLarge

                anchors {
                    left: parent.left
                    leftMargin: appStyle.paddingMedium
                    right: parent.right
                    rightMargin: appStyle.paddingMedium
                }

                Label {
                    id: itemlList1Label
                    text: qsTr("Reset application data")
                    anchors.left: parent.left
                    platformInverted: settingsPage.platformInverted
                }

                Button {
                    id: resetButton
                    width: parent.width - (appStyle.paddingLarge * 4)
                    text: qsTr("Reset")
                    anchors.horizontalCenter: parent.horizontalCenter
                    platformInverted: settingsPage.platformInverted
                    onClicked: dialogLoader.load("ResetDialog.qml")
                }
            }
        }
    }

    ScrollBar {
        id: scrollBar
        flickableItem: mainFlickable
        policy: Symbian.ScrollBarWhenScrolling
        interactive: false
        platformInverted: settingsPage.platformInverted

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
    }
}
