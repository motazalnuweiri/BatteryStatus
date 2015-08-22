#ifndef QHSWIDGETIMPL_H
#define QHSWIDGETIMPL_H

#include "qhswidget.h"


#include <QtCore/qglobal.h>
#include <QtCore/qplugin.h>

#include <string> //should be taken from include\stdapis\stlport\string

//these libraries should be copied to SDK folder
#include <hswidgetpublisher.h>
#include <hswidget.h>
#include <hsdataobserver.h>


class QHSWidgetImpl : public QHSWidget, private Hs::IHsDataObserver
{    
Q_OBJECT

public:
    explicit QHSWidgetImpl(QString templateType, QString widgetName, QString widgetId,
                           QString widgetDesc, QString widgetIcon, QObject *parent = 0);
    virtual  ~QHSWidgetImpl();

     void RegisterWidget();
     void PublishWidget();
     void SetItem(QString item, QString value);
     void SetItem(QString item, int value);
     void RemoveItem(QString itemName);
     void RemoveWidget();
     QString WidgetName();

private:
    /**
             * Intended to handle an event that occured on a widget.
             * This would include EActivate, EDeactivate, ESuspend, EReusume.
             * Template is being published when the received event is EActivate or EResume
             *
             * @param aWidgetName Name of the widget that event is envoked for.
             * @param aEvent Event type that has taken place.
             */
    void handleEvent( std::string aWidgetName,
                              Hs::IHsDataObserver::EEvent aEvent);

    /**
             * If the ESelect event was triggerred by the image item it will trigger the
             * content of the widget items to be changed. If the event is triggeted by the
             * text item the publisher application will he sent to foreground.
             * To be noted that if the publisher application is not running the Homescreen
             * application will start the publisher. The subsequent events will be sent to
             * the now running publisher application.
             *
             * @param aWidgetName Name of the widget that event is envoked for.
             * @param aWidgetItemName Name of the item that event is envoked for.
             * @param aEvent Event type that has taken place
             */
    void handleItemEvent( std::string aWidgetName,
                                  std::string aWidgetItemName,
                                  Hs::IHsDataObserver::EItemEvent aEvent);
private:

    /**
     * The Home Screen Publisher API's main class
     */
    Hs::HsWidgetPublisher* iHsWidgetPublisher;

    /**
     * String indicating which template will be used for this widget.
     */
    std::string iTemplateType;

    /**
     * Widget's name. Will be shown to the user when he/she selects a
     * widget to be added to the home screen.
     */
    std::string iWidgetName;

    /**
     * Unique UID identifiying a widget.
     */
    std::string iWidgetId;

    /**
     * Widget's Description. Will be shown to the user when select "Details"
     * in "Add Widget" Menu.
     */
    std::string iWidgetDesc;

    /**
     * Widget's icon that show in "Add Widget" Menu.
     */
    std::string iWidgetIcon;

    Hs::HsWidget* iWidget;
};




#endif // QHSWIDGETIMPL_H
