/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qpsmode.h"
#include "qpsmode_p.h"

QPSMode::QPSMode(QObject *parent) :
    QObject(parent)//, d_ptr(new PSMModePrivate(this))
{
    d_ptr = q_check_ptr(QPSModePrivate::NewL(this));
}

QPSMode::~QPSMode()
{
    delete d_ptr;
}

void QPSMode::enable()
{
   d_ptr->Enable();
}

void QPSMode::disable()
{
   d_ptr->Disable();
}

bool QPSMode::isEnable()
{
    return d_ptr->IsEnable();
}
