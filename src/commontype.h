/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef COMMONTYPE_H
#define COMMONTYPE_H

#include <QObject>

class CommonType : public QObject
{
    Q_OBJECT
    Q_ENUMS(LevelType)

public:
    enum LevelType {
        RealLevel = 0,
        SystemLevel = 1
    };
};

#endif // COMMONTYPE_H
