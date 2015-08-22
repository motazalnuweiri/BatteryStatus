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

    property alias text:  sliderLabel.text
    property alias maxValue: slider.maximumValue
    property alias miniValue: slider.minimumValue
    property alias stepSize: slider.stepSize
    property alias value: slider.value
    property bool platformInverted: false

    implicitHeight: sliderColumn.implicitHeight + (appStyle.paddingSmall * 2)
    implicitWidth: 360

    anchors {
        left: parent.left
        leftMargin: appStyle.paddingLarge
        right: parent.right
        rightMargin: appStyle.paddingLarge
    }

    Behavior on height {
        NumberAnimation { duration: 200 }
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    Column {
        id: sliderColumn

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        Item {
            id: sliderItem
            implicitHeight: Math.max(sliderLabel.implicitHeight, sliderValueLabel.implicitHeight)
            anchors { left: parent.left;  right: parent.right }

            Label {
                id: sliderLabel
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: appStyle.fontSizeSmall
                platformInverted: root.platformInverted
                anchors {
                    left: parent.left
                    right: sliderValueLabel.left
                    rightMargin: appStyle.paddingMedium
                    verticalCenter: parent.verticalCenter
                }
            }

            Label {
                id: sliderValueLabel
                text: "%1%".arg(slider.value)
                font.bold: true
                font.pixelSize: appStyle.fontSizeSmall
                platformInverted: root.platformInverted
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            }
        }

        Slider {
            id: slider
            LayoutMirroring.enabled: symbian.rightToLeftDisplayLanguage
            inverted: LayoutMirroring.enabled
            platformInverted: root.platformInverted

            anchors {
                left: parent.left
                leftMargin: sliderMinLabel.width + appStyle.paddingSmall
                right: parent.right
                rightMargin: sliderMaxLabel.width + appStyle.paddingSmall
            }

            ThemeEffect { id: slideEffect; effect: ThemeEffect.BasicSlider }

            Label {
                id: sliderMinLabel
                text: parent.minimumValue
                platformInverted: root.platformInverted
                color: platformInverted ? appStyle.colorTextMidInverted : appStyle.colorTextMid
                font.pixelSize: appStyle.fontSizeSSmall
                anchors {
                    left: parent.left
                    leftMargin: - (width + appStyle.paddingSmall)
                    verticalCenter: parent.verticalCenter
                }
            }

            Label {
                id: sliderMaxLabel
                text: parent.maximumValue
                platformInverted: root.platformInverted
                color: platformInverted ? appStyle.colorTextMidInverted : appStyle.colorTextMid
                font.pixelSize: appStyle.fontSizeSSmall
                anchors {
                    right: parent.right
                    rightMargin: - (width + appStyle.paddingSmall)
                    verticalCenter: parent.verticalCenter
                }
            }

            onValueChanged: {
                if (pressed)
                    slideEffect.play()
            }
        }
    }
}
