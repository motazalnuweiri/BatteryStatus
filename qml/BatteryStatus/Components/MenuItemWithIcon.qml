/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import QtQuick 1.1
import com.nokia.symbian 1.1
import ".."

MenuItem {
    id: root

    AppStyle { id: appStyle }

    property alias image: image1.source
    platformLeftMargin: appStyle.paddingLarge + appStyle.imageSizeSmall + appStyle.paddingMedium

    Image {
        id: image1
        sourceSize.width: appStyle.imageSizeSmall
        sourceSize.height: appStyle.imageSizeSmall
        anchors {
            left: parent.left
            leftMargin: appStyle.paddingLarge
            verticalCenter: parent.verticalCenter
        }
    }
}
