/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMobility.systeminfo 1.2
//import com.nokia.extras 1.1
import QtMobility.feedback 1.1
import QtMultimediaKit 1.1
import PSMode 1.0
import GlobalNote 1.0
import CBatteryInfo 1.0
import CommonType 1.0
import "Components"

Page {
    id: mainPage
    //orientationLock: PageOrientation.LockPortrait
    //property bool isMirroring: symbian.rightToLeftDisplayLanguage

    property string title: APPName
    property bool platformInverted
    property bool isCharging
    property bool psmEnabled: false

    signal updateItems

    AppStyle { id: appStyle }

    onUpdateItems: {
        cBatteryInfo.levelType = AppSettings.getLevelType()
        player.volume = (AppSettings.getNotifyLevel() / 100)
        HSWidget.setBackgroundOpacity(AppSettings.getWidgetOpacity())
        platformInverted = AppSettings.getInvertedStyle()
        psmEnabled = false

        refreshApp()
    }

    Audio {
        id: player
        volume: notifyLevel

        function playSound(file) {
            if (file !== "") {
                stopSound()
                source = file
                play()
            }
        }

        function stopSound() {
            if (playing) stop()
        }
    }

    PSMode {
        id: psmode
        onStatusChanged: {
            checkPSM()
        }
    }

    GlobalNote {
        id: batteryFullGlobalNote
        noteType: GlobalNote.GlobalBatteryFullUnplugNote
        onShowing: player.playSound("file:///" + AppPath + "/Sounds/Battery_Full.aac")
    }

    GlobalNote {
        id: batteryLowGlobalNote
        noteType: GlobalNote.GlobalBatteryLowNote
        onShowing: player.playSound("file:///" + AppPath + "/Sounds/Battery_Low.aac")
    }

    GlobalNote {
        id: batteryVeryLowGlobalNote
        noteType: GlobalNote.GlobalRechargeBatteryNote
        onShowing: player.playSound("file:///" + AppPath + "/Sounds/Battery_VeryLow.aac")
    }

    CBatteryInfo {
        id: cBatteryInfo

        onLevelChanged: {
            if (!(psmode.isEnable() || isCharging() || psmEnabled)) {
                if (AppSettings.getPSM() && (getLevel() <= AppSettings.getPSMLevel())) {
                    psmode.enable()
                    psmEnabled = true
                }
            }
        }

        onFullChargedNotify: {
            console.debug("QML::onFullChargedNotify")

            if (AppSettings.getFullNotify()) {
                batteryFullGlobalNote.show()
                console.debug("batteryFullGlobalNote.show()")
            }
        }

        onLowNotify: {
            if (AppSettings.getLowNotify()) {
                batteryLowGlobalNote.show()
            }
        }

        onVeryLowNotify: {
            if (AppSettings.getLowNotify()) {
                batteryVeryLowGlobalNote.show()
            }
        }

        onChargingChanged: {
            if (cBatteryInfo.isCharging()) {
                if (psmode.isEnable()) {
                    psmode.disable()
                    psmEnabled = false
                }
            }
        }
    }

    Connections {
        target: QApp

        onForegroundChanged: {
            checkMonitorFlow()

            if (QApp.foreground()) {
                refreshApp()
                monitorApp.start()

                if (!DeviceName.isE6()) {
                    checkOrientation()
                    monitorOrientation.start()
                }

            } else {
                monitorApp.stop()

                if (!DeviceName.isE6())
                    monitorOrientation.stop()
            }
        }

        //onAboutToQuit: {
        //    // Do something...
        //}
    }


    Connections {
        target: HSWidget

        onActivate: {
            refreshWidget()
        }

        onResume: {
            checkMonitorFlow()
            refreshWidget()
            monitorHSWidget.start()
        }

        onSuspend: {
            checkMonitorFlow()
            monitorHSWidget.stop()
        }
    }

    //    Connections {
    //        target: screen
    //        onCurrentOrientationChanged: {
    //            checkOrientation()
    //            refreshApp()
    //        }
    //    }

    //    function isAppActive() {
    //        //return symbian.foreground
    //        return Qt.application.active
    //    }

    function checkMonitorFlow() {
        cBatteryInfo.monitorFlow = (HSWidget.isResume() || QApp.foreground())
    }

    function checkPSM() {
        psmSwitch.checked = psmode.isEnable()
    }

    function isLandscape() {
        //return (screen.currentOrientation === Screen.Landscape)
        if (mainPage.width != 0 && mainPage.height != 0)
            return (mainPage.width > mainPage.height)

        return false
    }

    function e6ScreenLayout() {
        guiTop.anchors.bottom = mainPage.bottom
        guiTop.anchors.right = undefined
        guiTop.width = 300

        guiBottom.anchors.top = mainPage.top
        guiBottom.anchors.topMargin = 0
        guiBottom.anchors.left = guiTop.right
        guiBottom.anchors.leftMargin = 1
    }

    function checkOrientation() {
        var landscape = isLandscape()

        guiTop.anchors.right = landscape ? undefined : mainPage.right
        guiTop.anchors.bottom = landscape ? mainPage.bottom : undefined
        guiTop.width = landscape ? guiTop.implicitWidth : undefined
        guiTop.height = landscape ? undefined : guiTop.implicitHeight

        guiBottom.anchors.left = landscape ? guiTop.right : mainPage.left
        guiBottom.anchors.leftMargin = landscape ? 1 : 0
        guiBottom.anchors.top = landscape ? mainPage.top : guiTop.bottom
        guiBottom.anchors.topMargin = landscape ? 0 : 1
    }

    function refreshWidget() {
        HSWidget.update(cBatteryInfo.getLevel(), cBatteryInfo.getLevelColor(),
                        cBatteryInfo.getRemainingString(), cBatteryInfo.getRemainingTime())
    }

    function refreshApp() {
        isCharging = cBatteryInfo.isCharging()

        batteryPercentText.text = "%1%".arg(cBatteryInfo.getLevel())

        batteryLevelProgress.width = (cBatteryInfo.getLevel() * batteryLevelRec.width) / 100
        batteryLevelProgress.color = cBatteryInfo.getLevelColor()

        batteryTimeInfoItem.title = cBatteryInfo.getRemainingString()
        batteryTimeInfoItem.value = cBatteryInfo.getRemainingTime()
        //batteryTimeInfoItem.valueColor = cBatteryInfo.getLevelColor()
        batteryTimeInfoItem.busyVisible = cBatteryInfo.isCharging()

        if (batteryTabButton.checked) {
            batteryInfoItem1.value = "%1 %3 / <b>%2 %3</b>".arg(cBatteryInfo.getCapacity())
                                     .arg(cBatteryInfo.getFullCapacity()).arg(cBatteryInfo.getEnergyUnit())
            chargerInfoItem1.title = cBatteryInfo.isCharging() ? qsTr("Type") : qsTr("Last Type Used")
            batteryInfoItem2.value = "%1 V".arg(cBatteryInfo.getVoltage())
            batteryInfoItem3.value = "%1 mA".arg(cBatteryInfo.getFlow()).replace("-", "+ ")
        }

        if (chargerTabButton.checked) {
            chargerInfoItem1.value = cBatteryInfo.isCharging() ?
                                     cBatteryInfo.getChargerType() : cBatteryInfo.getLastChargerType()
            chargerInfoItem1.title = cBatteryInfo.isCharging() ? qsTr("Type") : qsTr("Last Type Used")
            var lastLevel = cBatteryInfo.getLastLevel()
            var lastLevelStr = lastLevel === -2 ? "" : " (%2%)".arg(lastLevel)
            chargerInfoItem2.value = cBatteryInfo.isCharging() ?
                                     cBatteryInfo.getChargingTime() :
                                     "%1%2".arg(cBatteryInfo.getLastChargingTime()).arg(lastLevelStr)
        }
    }

    Component.onCompleted: {
        checkMonitorFlow()
        checkPSM()
        refreshApp()
        refreshWidget()
        updateItems()

        if (HSWidget.isResume())
            monitorHSWidget.start()

        if (DeviceName.isE6()) {
            e6ScreenLayout()
        } else {
            checkOrientation()
        }

        if (QApp.foreground()) {
            monitorApp.start()

            if (!DeviceName.isE6())
                monitorOrientation.start()
        }
    }

    Timer {
        id: monitorApp
        interval: 100
        repeat: true
        onTriggered: refreshApp()
    }

    Timer {
        id: monitorHSWidget
        interval: 100
        repeat: true
        onTriggered: refreshWidget()
    }

    Timer {
        id: monitorOrientation
        interval: 100
        repeat: true
        onTriggered: checkOrientation()
    }

    Item {
        id: guiTop
        implicitWidth: 310
        implicitHeight: 274
        height: 300

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Rectangle {
//            gradient: Gradient {
//                GradientStop {
//                    position: 0
//                    color: "#597db1"
//                }

//                GradientStop {
//                    position: 1
//                    color: "#274A7E"
//                }
//            }

            color: appStyle.guiColorTop
            anchors.fill: parent

            Rectangle {
                height: 60

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: appStyle.guiColorTopEffect1
                    }

                    GradientStop {
                        position: 0.02
                        color: appStyle.guiColorTopEffect2
                    }

                    GradientStop {
                        position: 1
                        color: "transparent"
                    }
                }
            }
        }

//        BorderImage {
//            //opacity: mainPage.platformInverted ? 0.200 : 0.500
//            //source: privateStyle.imagePath("qtg_fr_pushbutton_normal", false)
//            source: appStyle.getImagePath("Images/PNG/Top_Back", "png", false)
//            anchors.fill: parent
//            border { left: 20; top: 20; right: 19; bottom: 20 }
//        }

        Item {
            id: batteryLevelImages
            height: 100
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: true
            anchors {
                top: parent.top
                topMargin: 14
                right: parent.right
                rightMargin: 14
                left: parent.left
                leftMargin: 14
            }

            Rectangle {
                id: batteryLevelRec
                height: 92
                color: appStyle.guiColorLevelFill
                anchors {
                    verticalCenter: batteryLevelImages.verticalCenter
                    left: imageLeft.right
                    right: imageRight.left
                }

                Rectangle {
                    id: batteryLevelProgress
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                    }

                    Behavior on width {
                        NumberAnimation { duration: 100 }
                    }
                }
            }

            Image {
                id: imageLeft
                source: appStyle.getImagePath("Images/PNG/Battery_Level_Left", "png", false)
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
            }

            Image {
                id: imageCenter
                source: appStyle.getImagePath("Images/PNG/Battery_Level_Center", "png", false)
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: imageLeft.right
                    right: imageRight.left
                }
            }

            Image {
                id: imageRight
                source: appStyle.getImagePath("Images/PNG/Battery_Level_Right", "png", false)
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }
            }
        }

        Text {
            id: batteryPercentText
            color: appStyle.colorTextNormal
            text: "---%"
            styleColor: appStyle.colorTextShadow
            style: Text.Raised
            horizontalAlignment: Text.AlignHCenter
            font { bold: true; pixelSize: 48 }
            anchors {
                horizontalCenter: batteryLevelImages.horizontalCenter
                horizontalCenterOffset: -8
                verticalCenter: batteryLevelImages.verticalCenter
            }
        }

        Item {
            id: timeInfoItem

            anchors {
                top: batteryLevelImages.bottom
                topMargin: 10
                right: parent.right
                rightMargin: 14
                left: parent.left
                leftMargin: 14
                bottom: psmItemGroup.top
                bottomMargin: 10
            }

            TimeInfoItem {
                id: batteryTimeInfoItem
                anchors.bottomMargin: 14
                image: appStyle.getImagePath("Images/PNG/Battery_Time", "png", false)
                title: qsTr("Remaining Time")
                value: "--"
                platformInverted: false

                anchors {
                    right: parent.right
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        Item {
            id: psmItemGroup
            implicitHeight: psmItem.height + 16
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Rectangle {
                id: psmRectangle
                anchors.fill: parent
                implicitHeight: parent.implicitHeight / 2
                color: appStyle.guiColorPSMFill
//                gradient: Gradient {
//                    GradientStop {
//                        position: 0
//                        color: appStyle.guiColorGradient5
//                    }

//                    GradientStop {
//                        position: 1
//                        color: appStyle.guiColorGradientEmpty
//                    }
//                }
            }

            Item {
                id: psmItem
                implicitHeight: Math.max(psmSwitch.implicitHeight,
                                         psmText.implicitHeight, psmImage.implicitHeight)
                anchors {
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }

                Image {
                    id: psmImage
                    source: appStyle.getImagePath("Images/PNG/PSM", "png", false)
                    anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                }

                Label {
                    id: psmText
                    //platformInverted: mainPage.platformInverted
                    text: qsTr("Power Saving")
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight

                    anchors {
                        left: psmImage.right
                        leftMargin: 10
                        right: psmSwitch.left
                        rightMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                }

                Switch {
                    id: psmSwitch
                    platformInverted: mainPage.platformInverted
                    anchors { right: parent.right; verticalCenter: parent.verticalCenter }

                    onClicked: {
                        if (checked) {
                            if (!psmode.isEnable())
                                psmode.enable()
                        } else {
                            if (psmode.isEnable())
                                psmode.disable()
                        }
                    }
                }
            }
        }
    }

    Item {
        id: guiBottom
        x: 10
        anchors.topMargin: 1
        anchors {
            top: guiTop.bottom
            //topMargin: 14
            bottom: parent.bottom
            //bottomMargin: 10
            left: parent.left
            //leftMargin: 10
            right: parent.right
            //rightMargin: 10
        }

        Item {
            id: guiTab
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            Rectangle {
                anchors.fill: parent
                color: mainPage.platformInverted ? appStyle.guiColorBottomInverted : appStyle.guiColorBottom
            }

//            BorderImage {
//                opacity: mainPage.platformInverted ? 0.250 : 0.550
//                source: privateStyle.imagePath("qtg_fr_pushbutton_normal", false)
//                anchors.fill: parent
//                border { left: 20; top: 20; right: 20; bottom: 20 }
            //            }

            ButtonRow {
                id: tabButtonsRow
                x: 14
                y: -42
                height: batteryTabButton.height
                anchors.topMargin: 14
                focus: true

                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: 14
                    right: parent.right
                    rightMargin: 14
                }

                Button {
                    id: batteryTabButton
                    iconSource: appStyle.getImagePath("Images/PNG/Tab_Battery", "png", platformInverted)
                    platformInverted: mainPage.platformInverted
                    anchors { top: parent.top; bottom: parent.bottom }

                    ToolTipEx {
                        text: qsTr("Battery")
                        platformInverted: parent.platformInverted
                    }
                }

                Button {
                    id: chargerTabButton
                    platformInverted: mainPage.platformInverted
                    iconSource: appStyle.getImagePath("Images/PNG/Tab_Charger", "png", platformInverted)
                    anchors { top: parent.top; bottom: parent.bottom }

                    ToolTipEx {
                        text: qsTr("Charger")
                        platformInverted: parent.platformInverted
                    }
                }

                onCheckedButtonChanged: {
                    if(mainPage.status !== PageStatus.Active) return

                    if(checkedButton === batteryTabButton)
                    {
                        guiTab.showBatteryTab()
                    }
                    else
                    {
                        guiTab.showChargerTab()
                    }
                }
        }

            Item {
                id: tapGroup
                clip: true
                anchors {
                    top: tabButtonsRow.bottom
                    topMargin: 14
                    bottom: parent.bottom
                    bottomMargin: 10
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }

                Column {
                    id: batteryInfoColumn
                    width: parent.width
                    spacing: appStyle.spaceSmall
                    anchors {top: parent.top; bottom: parent.bottom}

                    GUIInfoItem {
                        id: batteryInfoItem1
                        title: qsTr("Capacity")
                        value: "--"
                        image: appStyle.getImagePath("Images/PNG/Tab_Battery_Capacity", "png", platformInverted)
                        platformInverted: mainPage.platformInverted
                    }

                    LineItem { platformInverted: mainPage.platformInverted }

                    GUIInfoItem {
                        id: batteryInfoItem2
                        title: qsTr("Voltage")
                        value: "--"
                        image: appStyle.getImagePath("Images/PNG/Tab_Battery_Voltage", "png", platformInverted)
                        platformInverted: mainPage.platformInverted
                    }

                    LineItem { platformInverted: mainPage.platformInverted }

                    GUIInfoItem {
                        id: batteryInfoItem3
                        title: qsTr("Consump")
                        value: "--"
                        image: appStyle.getImagePath("Images/PNG/Tab_Battery_Consump", "png", platformInverted)
                        platformInverted: mainPage.platformInverted
                    }
                }

                Column {
                    id: chargerInfoColumn
                    x: parent.width + 10
                    width: parent.width
                    opacity: 0
                    spacing: appStyle.spaceSmall
                    anchors {top: parent.top; bottom: parent.bottom}

                    GUIInfoItem {
                        id: chargerInfoItem1
                        value: "--"
                        image: appStyle.getImagePath("Images/PNG/Tab_Charger_Type", "png", platformInverted)
                        title: isCharging ? qsTr("Type") : qsTr("Last Type Used")
                        platformInverted: mainPage.platformInverted
                    }

                    LineItem { platformInverted: mainPage.platformInverted }

                    GUIInfoItem {
                        id: chargerInfoItem2
                        valueWrap: 1
                        value: "--"
                        image: appStyle.getImagePath("Images/PNG/Tab_Charger_Time", "png", platformInverted)
                        title: isCharging ? qsTr("Started Time") : qsTr("Last Time Charged")
                        platformInverted: mainPage.platformInverted
                    }
                }
            }

            SwipeArea {
                id: swipeArea1

                anchors {
                    top: tabButtonsRow.bottom
                    topMargin: 14
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                ThemeEffect{ id: swipeEffect; effect: ThemeEffect.Flick }

                onSwipeLeft: {
                    if (!chargerTabButton.checked) {
                        swipeEffect.play()
                        tabButtonsRow.checkedButton = chargerTabButton
                    }
                }

                onSwipeRight: {
                    if (!batteryTabButton.checked) {
                        swipeEffect.play()
                        tabButtonsRow.checkedButton = batteryTabButton
                    }
                }
            }


            function showBatteryTab() {
                state = 'BatteryTab'
            }

            function showChargerTab() {
                state = 'ChargerTab'
            }

            states: [
                State {
                    name: "BatteryTab"
                    //when: batteryTabButton.checked

                    PropertyChanges {
                        target: batteryInfoColumn
                        x: 0
                        opacity: 1.0
                    }

                    PropertyChanges {
                        target: chargerInfoColumn
                        x: tapGroup.width + 10
                        opacity: 0.0
                    }
                },

                State {
                    name: "ChargerTab"
                    //when: chargerTabButton.checked

                    PropertyChanges {
                        target: batteryInfoColumn
                        x: -tapGroup.width + 10
                        opacity: 0.0
                    }

                    PropertyChanges {
                        target: chargerInfoColumn
                        x: 0
                        opacity: 1.0
                    }
                }
            ]

            transitions: Transition {
                NumberAnimation { properties: "x"; easing.type: Easing.OutExpo; duration: 500 }
                NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 500 }
            }
        }
    }
}
