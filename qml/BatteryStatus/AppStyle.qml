/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1

QtObject {
    id: root

    function getImagePath(name, ext, inverse) {
        return name + (inverse ? "_Inverse" : "") + ".%1".arg(ext)
    }

    // Inverted Style
    property bool invertedStyle: AppSettings.getInvertedStyle()

    // Text Colors
    property color colorTextNormal: platformStyle.colorNormalLight
    property color colorTextMid: platformStyle.colorNormalMid
    property color colorTextDark: platformStyle.colorNormalDark
    property color colorTextLink: platformStyle.colorNormalLink
    property color colorTextSelection: platformStyle.colorTextSelection
    property color colorTextShadow: "#99000000"
    // Text Colors Inverted
    property color colorTextNormalInverted: platformStyle.colorNormalLightInverted
    property color colorTextMidInverted: platformStyle.colorNormalMidInverted
    property color colorTextDarkInverted: platformStyle.colorNormalDarkInverted
    property color colorTextLinkInverted: platformStyle.colorNormalLinkInverted
    property color colorTextSelectionInverted: platformStyle.colorTextSelectionInverted
    property color colorTextShadowInverted: "#99ffffff"

    // GUI Line Color
    property color colorLine: "white"
    // GUI Line Color Inverted
    property color colorLineInverted: "black"

    // GUI Colors
    property color guiColorTop: "#2D5591"
    property color guiColorTopEffect1: "#50ffffff"
    property color guiColorTopEffect2: "#3cffffff"
    property color guiColorBottom: "#444438"
    property color guiColorBottomInverted: "#CCCCCC"
    property color guiColorPSMFill: "#32000000"
    property color guiColorLevelFill: "#28000000"

    // GUI Font Size
//    property int guiFontSizeLarge: 22
//    property int guiFontSizeMedium: 20
//    property int guiFontSizeSmall: 18
    property int fixGUIFontSize: DeviceName.isE6() ? 6 : 0
    property int guiFontSizeXLarge: fontSizeXLarge - fixGUIFontSize
    property int guiFontSizeLarge: fontSizeLarge - fixGUIFontSize
    property int guiFontSizeMedium: fontSizeMedium - fixGUIFontSize
    property int guiFontSizeSmall: fontSizeSmall - fixGUIFontSize

    // GUI Image Sizes
    property int guiImageSizeLarge: 60
    property int guiImageSizeMedium: 54
    property int guiImageSizeSmall: 40
    property int guiImageSizeTiny: 30

    // Font Family
    property string fontFamilyRegular: platformStyle.fontFamilyRegular

    // Font Sizes
    property int fontSizeXLarge: platformStyle.fontSizeLarge + 2
    property int fontSizeLarge: platformStyle.fontSizeLarge
    property int fontSizeMedium: platformStyle.fontSizeMedium
    property int fontSizeSmall: platformStyle.fontSizeSmall
    property int fontSizeSSmall: fontSizeSmall - 2

    // Padding Sizes
    property int paddingLarge: platformStyle.paddingLarge
    property int paddingMedium: platformStyle.paddingMedium
    property int paddingSmall: platformStyle.paddingSmall

    // Disable Opacity
    property real disableOpacity: 0.6

    // Image Sizes
    property int imageSizeLarge: platformStyle.graphicSizeLarge
    property int imageSizeMedium: platformStyle.graphicSizeMedium
    property int imageSizeSmall: platformStyle.graphicSizeSmall
    property int imageSizeTiny: platformStyle.graphicSizeTiny

    // Space Sizes
    property int spaceLarge: 6
    property int spaceMedium: 4
    property int spaceSmall: 2

    // List Item Size
    property int listItemSize: platformStyle.graphicSizeMedium

    // State Bar Height
    property int stateBarHeight: privateStyle.statusBarHeight
}
