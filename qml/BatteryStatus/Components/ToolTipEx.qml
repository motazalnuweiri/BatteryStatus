/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root

    property alias text: toolTip.text
    property alias platformInverted: toolTip.platformInverted

    ToolTip {
        id: toolTip
        target: root.parent
        visible: false
    }

    Connections {
        target: toolTip.target
        ignoreUnknownSignals: true

        onPlatformPressAndHold: toolTip.show()
        onPlatformReleased: toolTip.hide()
    }
}
