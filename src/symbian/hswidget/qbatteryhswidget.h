/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef QSAMPLESMHSWIDGET_H
#define QSAMPLESMHSWIDGET_H

#include <QObject>
#include <QPixmap>
#include <QTimer>
#include "qhswidget.h"

class QHSWidgetStyle : public QObject
{
    Q_OBJECT
public:
    explicit QHSWidgetStyle(QObject *parent = 0);

    QSize widgetSize;
    QRect widgetRect;

    QImage backgroundImage;
    QImage batteryLevelImage;
    QImage loadingImage;

    QColor colorTextNormal;
    QColor colorTextShadow;
    QColor colorLine;
    QColor colorBackRec;

    int fontSizeLarge;
    int fontSizeMedium;
    int fontSizeSmall;

    int paddingLarge;
    int paddingMedium;
    int paddingSmall;
};

class QBatteryHSWidget : public QObject
{
    Q_OBJECT
public:
    explicit QBatteryHSWidget(QObject *parent = 0);
    ~QBatteryHSWidget();

    void RegisterWidget();
    void RemoveWidget();

    Q_INVOKABLE bool isActivate();
    Q_INVOKABLE bool isResume();
    Q_INVOKABLE bool isRunning();
    Q_INVOKABLE void setBackgroundOpacity(int value);

private:
    void drawImage(int level, QString levelColor, QString string1, QString string2);
    void drawWaitImage();
    void updateWidgetImage();
    void failedImage();

signals:
    void activate();
    void deactivate();
    void resume();
    void suspend();

private slots:
    void handleEvent(QHSWidget*, QHSEvent aEvent );
    void handleItemEvent(QHSWidget*, QString aTemplateItemName, QHSItemEvent aEvent);

public slots:
    void update(int level, QString levelColor, QString string1, QString string2);
    void drawWait();

private:
    QHSWidget *iWidget;
    QPixmap *iPixmap;
    QHSWidgetStyle *iStyle;

    bool iActivate;
    bool iResume;
    bool iRunning;
    float backgroundOpacity;
};

#endif // QSAMPLESMHSWIDGET_H
