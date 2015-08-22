/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1

MouseArea {
    id: root

    signal swipeLeft
    signal swipeRight
    signal swipeTop
    signal swipeBottom

    property int swipeSize: 60

    property int mouseXStart: 0
    property int mouseXStop: 0

    property int mouseYStart: 0
    property int mouseYStop: 0

    onPressed: {
        mouseXStart = mouseX
        mouseYStart = mouseY
    }

    onMouseXChanged: {
        mouseXStop = mouseX
        mouseYStop = mouseY
    }

    onReleased: {
        var mouseXMove = mouseXStop - mouseXStart
        var mouseYMove = mouseYStop - mouseYStart

        if (mouseXMove !== 0 && Math.abs(mouseXMove) >= swipeSize) {
            if (mouseXMove > 0) {
                if (LayoutMirroring.enabled) {
                    swipeLeft()
                } else {
                    swipeRight()
                }
            } else {
                if (LayoutMirroring.enabled) {
                    swipeRight()
                } else {
                    swipeLeft()
                }
            }
        }

        if (mouseYMove !== 0 && Math.abs(mouseYMove) >= swipeSize) {
            if (mouseYMove > 0) {
                swipeBottom()
            } else {
                swipeTop()
            }
        }

        mouseXStart = 0
        mouseXStop = 0

        mouseYStart = 0
        mouseYStop = 0
    }
}
