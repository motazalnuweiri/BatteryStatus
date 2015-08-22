#include "qhswidget_impl.h"

extern "C" Q_DECL_EXPORT QHSWidget* getInstance(QString templateType,
                                                QString widgetName,
                                                QString widgetId,
                                                QString widgetDesc,
                                                QString widgetIcon,
                                                QObject *parent = 0)
{ //ordinal 5
    return new QHSWidgetImpl(templateType,
                             widgetName,
                             widgetId,
                             widgetDesc,
                             widgetIcon,
                             parent);
}

QHSWidgetImpl::QHSWidgetImpl(QString templateType,
                             QString widgetName,
                             QString widgetId,
                             QString widgetDesc,
                             QString widgetIcon,
                             QObject *parent) :

    QHSWidget(templateType,
              widgetName,
              widgetId,
              widgetDesc,
              widgetIcon,
              parent),

    iTemplateType(templateType.toStdString()),
    iWidgetName(widgetName.toStdString()),
    iWidgetId(widgetId.toStdString()),
    iWidgetDesc(widgetDesc.toStdString()),
    iWidgetIcon(widgetIcon.toStdString()),
    iWidget(0)
{
  iHsWidgetPublisher = new  Hs::HsWidgetPublisher( this );
}

QHSWidgetImpl::~QHSWidgetImpl()
{
    delete iHsWidgetPublisher;

    const QObjectList& c(children());
    foreach (QObject* child, c)
    {
        QLibrary* lib = qobject_cast<QLibrary*> (child);
        if (lib) lib->unload();
    }
}


void QHSWidgetImpl::RegisterWidget()
{
    try
    {
    iWidget = &iHsWidgetPublisher->getHsWidget( iTemplateType, iWidgetName, iWidgetId );
    } catch (...)
    {
        QString desc = QString::fromStdString(iWidgetDesc);
        QString icon = QString::fromStdString(iWidgetIcon);

        if(desc.isEmpty() && icon.isEmpty())
        {
            iWidget = &iHsWidgetPublisher->createHsWidget(iTemplateType, iWidgetName, iWidgetId);
        }
        else
        {
            iWidget = &iHsWidgetPublisher->createHsWidgetWithDesc(iTemplateType, iWidgetName, iWidgetId,
                                                                  iWidgetDesc, iWidgetIcon);
        }
    }
}

void QHSWidgetImpl::PublishWidget()
{
    if (iWidget)
        iHsWidgetPublisher->publishHsWidget(*iWidget);
}

void QHSWidgetImpl::SetItem(QString item, QString value)
{
    if (iWidget)
        iWidget->setItem( item.toStdString(), value.toStdString() );
}

void QHSWidgetImpl::SetItem(QString item, int value)
{
    if (iWidget)
        iWidget->setItem( item.toStdString(), value );
}

void QHSWidgetImpl::RemoveItem(QString itemName)
{
    try
    {
        if(iWidget)
           iWidget->removeItem( itemName.toStdString() );
    }
    catch (...) {}
}

void QHSWidgetImpl::RemoveWidget()
{
    iHsWidgetPublisher->removeHsWidget( iTemplateType,
                                        iWidgetName, iWidgetId);
    iWidget = 0;
}

void QHSWidgetImpl::handleEvent( std::string aWidgetName,
                             Hs::IHsDataObserver::EEvent aEvent )
{
    if (aWidgetName.compare(iWidgetName) == 0)
        emit QHSWidget::handleEvent(this, (QHSEvent) aEvent);
}

void QHSWidgetImpl::handleItemEvent( std::string aWidgetName,
                                 std::string aTemplateItemName, Hs::IHsDataObserver::EItemEvent aEvent)
{
    if (aWidgetName.compare(iWidgetName) == 0)
        emit QHSWidget::handleItemEvent(this, QString::fromStdString(aTemplateItemName), (QHSItemEvent)aEvent);
}


QString QHSWidgetImpl::WidgetName()
{
    return QString::fromStdString(iWidgetName);
}

