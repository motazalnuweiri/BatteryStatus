/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import ".."

Rectangle {
    id: root

    AppStyle { id: appStyle }

    property bool platformInverted: false

    color: platformInverted ? appStyle.colorLineInverted : appStyle.colorLine
    implicitHeight: 1
    opacity: 0.2
    anchors { left: parent.left; right: parent.right }

    Behavior on height {
        NumberAnimation { duration: 200 }
    }
}
