#-------------------------------------------------
#
# Project created by QtCreator 2011-12-10T22:32:26
#
#-------------------------------------------------

QT       -= gui
DEFINES += HSWIDGETPLUGIN_LIBRARY UID3

CONFIG(debug, debug|release) {
    # Debug:
    LIB_UID = 0xE6FB4417

} else {
    # Release:
    LIB_UID = 0x20070764 #From Allstar12345
}

#TARGET = HSWidgetPlugin$$LIB_UID
TARGET = BatteryStatusWidget

TEMPLATE = lib

SOURCES += qhswidget_impl.cpp

HEADERS += qhswidget.h \
 qhswidget_impl.h

symbian {
    LIBS += -lhswidgetpublisher #that library should be copied to SDK folder

    MMP_RULES += EXPORTUNFROZEN

    TARGET.UID3 = $$LIB_UID

    # Symbian Capabilities:
    #   http://qt-project.org/wiki/Symbian_Capabilities
    #   http://www.developer.nokia.com/Community/Wiki/Capabilities
    #   http://developer.nokia.com/Community/Wiki/Capabilities

    # PSM Mode Capabilitys:
    TARGET.CAPABILITY += PowerMgmt ReadDeviceData WriteDeviceData

    # Other Capabilitys:
    #TARGET.CAPABILITY += ProtServ TrustedUI SurroundingsDD

    # Qt Mobility - System Information Capability:
    # {LocalServices ReadUserData WriteUserData NetworkServices UserEnvironment Location ReadDeviceData}
    TARGET.CAPABILITY += ReadUserData WriteUserData UserEnvironment

    TARGET.EPOCALLOWDLLDATA = 1

#    addFiles.sources = HSWidgetPlugin$${LIB_UID}.dll
#    addFiles.path = !:/sys/bin
#    DEPLOYMENT += addFiles

}


