/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qglobalnote.h"

QGlobalNote::QGlobalNote(QObject *parent) :
    QObject(parent), pNoteType(GlobalTextNote), pMessage("")
{
}

QGlobalNote::GlobalNoteType QGlobalNote::getNoteType()
{
    return pNoteType;
}

void QGlobalNote::setNoteType(QGlobalNote::GlobalNoteType type)
{
    pNoteType = type;
}

QString QGlobalNote::getMessage()
{
    return pMessage;
}

void QGlobalNote::setMessage(QString message)
{
    pMessage = message;
}

void QGlobalNote::ShowGlobalNoteL()
{
    TPtrC16 aMessage(static_cast<const TUint16*>(pMessage.utf16()), pMessage.length());

    CAknGlobalNote* note = CAknGlobalNote::NewLC();

    emit showing();

    note->ShowNoteL((TAknGlobalNoteType) pNoteType, aMessage);
    CleanupStack::PopAndDestroy(note);
}

void QGlobalNote::show()
{
    ShowGlobalNoteL();
}
