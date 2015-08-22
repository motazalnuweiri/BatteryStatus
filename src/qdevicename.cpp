/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qdevicename.h"

QDeviceName::QDeviceName(QObject *parent) :
    QObject(parent)
{
    iDeviceInfo = new QSystemDeviceInfo(this);
}

QDeviceName::~QDeviceName()
{
    delete iDeviceInfo;
}

bool QDeviceName::isE6() const
{
    // (Product ID: 0x20023767 for RM-609)
    return (iDeviceInfo->productName().toLower() == "rm-609") ? true : false;
}
