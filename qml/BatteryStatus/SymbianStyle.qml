/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1

QtObject {
    id: symbianStyle

    // Platform Colors
    property color colorBackground: platformStyle.colorBackground
    property color colorBackgroundInverted: platformStyle.colorBackgroundInverted
    property color colorChecked: platformStyle.colorChecked
    property color colorDisabledDark: platformStyle.colorDisabledDark
    property color colorDisabledDarkInverted: platformStyle.colorDisabledDarkInverted
    property color colorDisabledLight: platformStyle.colorDisabledLight
    property color colorDisabledLightInverted: platformStyle.colorDisabledLightInverted
    property color colorDisabledMid: platformStyle.colorDisabledMid
    property color colorDisabledMidInverted: platformStyle.colorDisabledMidInverted
    property color colorHighlighted: platformStyle.colorHighlighted
    property color colorHighlightedInverted: platformStyle.colorHighlightedInverted
    property color colorLatched: platformStyle.colorLatched
    property color colorLatchedInverted: platformStyle.colorLatchedInverted
    property color colorNormalDark: platformStyle.colorNormalDark
    property color colorNormalDarkInverted: platformStyle.colorNormalDarkInverted
    property color colorNormalLight: platformStyle.colorNormalLight
    property color colorNormalLightInverted: platformStyle.colorNormalLightInverted
    property color colorNormalLink: platformStyle.colorNormalLink
    property color colorNormalLinkInverted: platformStyle.colorNormalLinkInverted
    property color colorNormalMid: platformStyle.colorNormalMid
    property color colorNormalMidInverted: platformStyle.colorNormalMidInverted
    property color colorPressed: platformStyle.colorPressed
    property color colorPressedInverted: platformStyle.colorPressedInverted
    property color colorTextSelection: platformStyle.colorTextSelection
    property color colorTextSelectionInverted: platformStyle.colorTextSelectionInverted

    // Platform Fonts
    property string fontFamilyRegular: platformStyle.fontFamilyRegular
    property int fontSizeLarge: platformStyle.fontSizeLarge
    property int fontSizeMedium: platformStyle.fontSizeMedium
    property int fontSizeSmall: platformStyle.fontSizeSmall

    // Platform Ggraphics
    property int graphicSizeLarge: platformStyle.graphicSizeLarge
    property int graphicSizeMedium: platformStyle.graphicSizeMedium
    property int graphicSizeSmall: platformStyle.graphicSizeSmall
    property int graphicSizeTiny: platformStyle.graphicSizeTiny

    // Platform Paddings
    property int paddingLarge: platformStyle.paddingLarge
    property int paddingMedium: platformStyle.paddingMedium
    property int paddingSmall: platformStyle.paddingSmall

    // Platform Border
    property int borderSizeMedium: platformStyle.borderSizeMedium
}
