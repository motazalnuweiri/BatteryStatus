/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

import ".."

InfoItem {
    id: root

    AppStyle { id: appStyle }

    anchors {left: parent.left; right: parent.right}
    titleFont.pixelSize: appStyle.guiFontSizeSmall
    valueFont.pixelSize: appStyle.guiFontSizeMedium
}
