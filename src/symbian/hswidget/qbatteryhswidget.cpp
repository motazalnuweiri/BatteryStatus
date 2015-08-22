/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qbatteryhswidget.h"
#include <eikenv.h>
#include <QFont>
#include <QPainter>
#include <QPixmap>
#include <QImage>
#include <qsymbianhelper.h>
#include "qdevicename.h"
#include <QApplication>
#include <QDebug>

const QString sw_type = "wideimage";
const QString sw_id   = QString("%1_0").arg(APP_UID); //can be any unique string
const QString sw_icon = QString("uid(%1)").arg(APP_UID);

const QString sw_image ("image1");
bool isWait = true;

QHSWidgetStyle::QHSWidgetStyle(QObject *parent) :
    QObject(parent)
{
    widgetSize = QSize(312,82); // Widget Size 4x2 (312,82)
    widgetRect = QRect(0,0,widgetSize.width(), widgetSize.height());

    backgroundImage = QImage(":widget/Images/Background.png");
    batteryLevelImage = QImage(":widget/Images/Battery_Level.png");
    loadingImage = QImage(":widget/Images/Loading.png");

    colorTextNormal = Qt::white;
    colorTextShadow = QColor(0, 0, 0, 120);
    colorLine = QColor(255, 255, 255, 180);
    colorBackRec = QColor(0, 0, 0, 40);

    fontSizeLarge = 38;
    fontSizeMedium = 20;
    fontSizeSmall = 16;

    paddingLarge = 6;
    paddingMedium = 4;
    paddingSmall = 2;
}

QBatteryHSWidget::QBatteryHSWidget(QObject *parent) :
    QObject(parent), iActivate(false), iResume(false), iRunning(false)
{
    const QString sw_name = tr("Battery Status").toUtf8();
    const QString sw_des  = tr("See the real battery level on your home screen").toUtf8();

    iWidget = QHSWidget::create(sw_type, sw_name, sw_id, sw_des, sw_icon, this);

    connect(iWidget, SIGNAL(handleEvent(QHSWidget*, QHSEvent)), this, SLOT(handleEvent(QHSWidget*, QHSEvent) ));
    connect(iWidget, SIGNAL(handleItemEvent(QHSWidget*, QString, QHSItemEvent)), this,
            SLOT(handleItemEvent(QHSWidget*, QString, QHSItemEvent)));

    iStyle = new QHSWidgetStyle(this);

    iPixmap = new QPixmap(iStyle->widgetSize);
    iPixmap->fill(Qt::transparent);

    iWidget->RegisterWidget();

    backgroundOpacity = 0.8;
}

QBatteryHSWidget::~QBatteryHSWidget()
{
    delete iWidget;
    delete iPixmap;
    delete iStyle;
}

void QBatteryHSWidget::RegisterWidget()
{
    iWidget->RegisterWidget();
}

void QBatteryHSWidget::RemoveWidget()
{
    iWidget->RemoveWidget();
}

void QBatteryHSWidget::drawImage(int level, QString levelColor, QString string1, QString string2)
{
    try {
        QImage tmpImage(iStyle->widgetSize, QImage::Format_ARGB32_Premultiplied);
        tmpImage.fill(Qt::transparent);

        QPainter painter(&tmpImage);

        // Set Strings
        QString levelStr = QString("%1%").arg(QString::number(level));
        QString remStr1 = string1;
        QString remStr2 = string2;

        // String Fonts
        QFont bfont;
        bfont.setPixelSize(iStyle->fontSizeLarge);
        bfont.setBold(true);

        QFont mfont;
        mfont.setPixelSize(iStyle->fontSizeMedium);
        mfont.setBold(true);

        QFont sfont;
        sfont.setPixelSize(iStyle->fontSizeSmall);

        // Strings Size
        QFontMetrics bStringSize(bfont);
        QFontMetrics mStringSize(mfont);
        QFontMetrics sStringSize(sfont);

        QRect levelStrRec(iStyle->widgetRect.left() + 28, iStyle->widgetRect.top(),
                          bStringSize.width(levelStr), iStyle->widgetRect.height());

        QRect lineRec(levelStrRec.right() + iStyle->paddingLarge + 2,
                      (iStyle->widgetRect.height() - (bStringSize.height() - iStyle->paddingMedium)) / 2,
                      1, bStringSize.height() - iStyle->paddingMedium);

        QRect remStr1Rec(lineRec.right() + iStyle->paddingLarge + 2,
                         (iStyle->widgetRect.height() - (sStringSize.height() +
                                                         mStringSize.height() + iStyle->paddingSmall)) / 2,
                         sStringSize.width(remStr1), sStringSize.height());

        QRect remStr2Rec(remStr1Rec.left(), remStr1Rec.bottom() + iStyle->paddingSmall,
                         mStringSize.width(remStr2), mStringSize.height());

        // Strings Shadow
        QRect levelStrShadowRec(levelStrRec.left() + 1, levelStrRec.top() + 1,
                                levelStrRec.width(), levelStrRec.height());

        QRect remStr1ShadowRec(remStr1Rec.left() + 1, remStr1Rec.top() + 1,
                               remStr1Rec.width(), remStr1Rec.height());

        QRect remStr2ShadowRec(remStr2Rec.left() + 1, remStr2Rec.top() + 1,
                               remStr2Rec.width(), remStr2Rec.height());

        // Enable Antialiasing
        painter.setRenderHint(QPainter::Antialiasing);
        painter.setRenderHint(QPainter::HighQualityAntialiasing);

        painter.setOpacity(backgroundOpacity);
        painter.drawImage(iStyle->widgetRect, iStyle->backgroundImage);
        painter.setOpacity(1.0);

        painter.fillRect(iStyle->widgetRect.left() + 15, iStyle->widgetRect.top() + 8, 272, 65,
                         iStyle->colorBackRec);

        painter.fillRect(iStyle->widgetRect.left() + 15, iStyle->widgetRect.top() + 8,
                         (level * 272) / 100, 65, QColor(levelColor));

        painter.drawImage(iStyle->widgetRect, iStyle->batteryLevelImage);

        //    QPainterPath path;
        //    path.addText((312-mfontsize.width(levelStr))/2,
        //                 (82+mfontsize.height()-14)/2,
        //                 mfont, levelStr);
        //    painter.setPen(QPen(Qt::black, 0.5, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin));

        // Draw Battrey Level
        painter.setFont(bfont);

        painter.setPen(iStyle->colorTextShadow);
        painter.drawText(levelStrShadowRec, Qt::AlignCenter, levelStr);

        painter.setPen(iStyle->colorTextNormal);
        painter.drawText(levelStrRec, Qt::AlignCenter, levelStr);

        // Draw Line
        //painter.setPen(QPen(lineColor, 1));
        painter.fillRect(lineRec, iStyle->colorLine);
        //painter.drawLine(QPoint(levelStrRec.right()+11,20),QPoint(levelStrRec.right()+11,82-20));

        // Draw Remaining Time
        painter.setFont(sfont);

        painter.setPen(iStyle->colorTextShadow);
        painter.drawText(remStr1ShadowRec, remStr1);

        painter.setPen(iStyle->colorTextNormal);
        painter.drawText(remStr1Rec, remStr1);

        painter.setFont(mfont);

        painter.setPen(iStyle->colorTextShadow);
        painter.drawText(remStr2ShadowRec, remStr2);

        painter.setPen(iStyle->colorTextNormal);
        painter.drawText(remStr2Rec, remStr2);

        painter.end();

        //painter.setBrush(Qt::white);
        //painter.drawText(0,0,312,82, Qt::AlignCenter, mstring);

        //painter.drawPath(path);

        //    painter.setFont(QFont("Courier",18,100));
        //    painter.setPen(QPen(0xffffffff));
        //    painter.drawText( 0,0,312,82, Qt::AlignCenter, text );

        iPixmap->convertFromImage(tmpImage);

    } catch(...) {
        failedImage();
    }
}

void QBatteryHSWidget::drawWaitImage()
{
    try {
        QImage tmpImage(iStyle->widgetSize, QImage::Format_ARGB32_Premultiplied);
        tmpImage.fill(Qt::transparent);

        QPainter painter(&tmpImage);
        QString message(tr("Loading..."));

        QFont mfont;
        mfont.setPixelSize(iStyle->fontSizeMedium);
        mfont.setBold(true);

        QFontMetrics mStringSize(mfont);

        QRect imageRec((iStyle->widgetRect.width() - (iStyle->loadingImage.width() + mStringSize.width(message) + 8)) / 2,
                       (iStyle->widgetRect.height() - iStyle->loadingImage.height()) / 2,
                       iStyle->loadingImage.width(), iStyle->loadingImage.height());

        QRect messageRec(imageRec.right() + iStyle->paddingLarge,
                         (iStyle->widgetRect.height() - mStringSize.height()) / 2,
                         mStringSize.width(message), mStringSize.height());

        if (QSymbianHelper::isRightToLeft()) {
            imageRec.moveLeft(imageRec.left() + messageRec.width() + iStyle->paddingLarge);
            messageRec.moveRight(imageRec.left() - iStyle->paddingLarge);
        }

        QRect messageShadowRec(messageRec.left() + 1, messageRec.top() + 1,
                               messageRec.width(), messageRec.height());

        painter.setRenderHint(QPainter::Antialiasing);
        painter.setRenderHint(QPainter::HighQualityAntialiasing);

        painter.setOpacity(0.6);
        painter.drawImage(iStyle->widgetRect, iStyle->backgroundImage);
        painter.setOpacity(1.0);

        painter.drawImage(imageRec, iStyle->loadingImage);

        painter.setFont(mfont);

        painter.setPen(iStyle->colorTextShadow);
        painter.drawText(messageShadowRec, message);

        painter.setPen(iStyle->colorTextNormal);
        painter.drawText(messageRec, message);

        iPixmap->convertFromImage(tmpImage);

    } catch(...) {
        failedImage();
    }
}

void QBatteryHSWidget::updateWidgetImage()
{
    if (!iPixmap) return;

    try {
        if(iPixmap) {
            iWidget->SetItem(sw_image, iPixmap->toSymbianCFbsBitmap()->Handle());
            // Commit the bitmap to the home screen
            iWidget->PublishWidget();
        }

    } catch (...) {
        failedImage();
        //        delete iPixmap;
        //        iPixmap = 0;
        //        throw;
    }
}

void QBatteryHSWidget::failedImage()
{
    if(iPixmap == NULL)
    {
        iPixmap = new QPixmap(iStyle->widgetSize);
        iPixmap->fill(Qt::transparent);
    }

    drawWaitImage();
    updateWidgetImage();
}

void QBatteryHSWidget::handleEvent(QHSWidget*, QHSEvent aEvent )
{
    try {
        switch (aEvent) {
        case EActivate: {
            iActivate = true;
            iRunning = true;
            QT_TRYCATCH_LEAVING(emit activate());
        }
            break;

        case EDeactivate: {
            iActivate = false;
            iRunning = true;
            QT_TRYCATCH_LEAVING(emit deactivate());
        }
            break;

        case EResume: {
            iResume = true;
            iRunning = true;
            QT_TRYCATCH_LEAVING(emit resume());
        }
            break;

        case ESuspend: {
            iResume = false;
            iRunning = true;
            QT_TRYCATCH_LEAVING(emit suspend());
        }
            break;

        default: {
            iActivate = false;
            iResume = false;
            iRunning = false;
        }
            break;
        }
    } catch (...) { }

    if (isWait) {
        drawWait();
        isWait = false;
    }
}

void QBatteryHSWidget::handleItemEvent(QHSWidget*, QString, QHSItemEvent aEvent)
{
    if (aEvent == ESelect) {
        QSymbianHelper::bringToForeground();
    }
}

void QBatteryHSWidget::update(int level, QString levelColor, QString string1, QString string2)
{
    if (iActivate) {
        // Draw image to iQBitmap
        drawImage(level, levelColor, string1, string2);
        // Update the image to widget
        updateWidgetImage();
    }
}

void QBatteryHSWidget::drawWait()
{
    if (iActivate) {
        drawWaitImage();
        updateWidgetImage();
    }
}

bool QBatteryHSWidget::isActivate()
{
    return iActivate;
}

bool QBatteryHSWidget::isResume()
{
    return iResume;
}

bool QBatteryHSWidget::isRunning()
{
    return iRunning;
}

void QBatteryHSWidget::setBackgroundOpacity(int value)
{
    backgroundOpacity = (float) value / 100;
}
