# Author: Motaz Alnuweiri
# Email: motaz_alnuweiri@hotmail.com
# Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.

# Add more folders to ship with the application, here

simulator{
    qml_folder.source = qml/BatteryStatus
    qml_folder.target = qml
    DEPLOYMENTFOLDERS = qml_folder
}

# Additional import path used to resolve QML modules in Creator's code model
#QML_IMPORT_PATH =

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
# symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# http://www.developer.nokia.com/Community/Wiki/Deploying_a_Qt_Application_on_Symbian
# http://doc.qt.digia.com/4.7/qmake-variable-reference.html

#---- Symbian Settings -----------------------------------------

APP_Name =     Battery Status
APP_Vendor =   Motaz Alnuweiri
APP_Version =  1.1.0
#APP_UID =      0xE6FB4418
#APP_UID =      0x20070765 #From Allstar12345

CONFIG(debug, debug|release) {
    # Debug:
    APP_UID = 0xE6FB4418
    Widget_Lib = src/symbian/hswidget/Lib/Debug/BatteryStatusWidget.dll

    # Disable QDebug & QWarning:
    #DEFINES += QT_NO_DEBUG_OUTPUT QT_NO_WARNING_OUTPUT

} else {
    # Release:
    APP_UID = 0x20070765 #From Allstar12345
    Widget_Lib = src/symbian/hswidget/Lib/Release/BatteryStatusWidget.dll

    # Disable QDebug & QWarning:
    DEFINES += QT_NO_DEBUG_OUTPUT QT_NO_WARNING_OUTPUT

    # Or Use this in Source Code:
    ##ifdef QT_DEBUG // QT_DEBUG or QT_NO_DEBUG
    # Insert code here...
    ##endif
}

symbian{
    #Symbian App UID:
    TARGET.UID3 = $$APP_UID

    # App Local Name:
    #TARGET = BatteryStatus_$${TARGET.UID3}

    # App Name:
    DEPLOYMENT.display_name = $$APP_Name

    # App Version:
    VERSION = $$APP_Version

    # Global Variables (To use in the project):
    #DEFINES += "APP_Name=\"'$$APP_Name'\"" #Add "" & '' for string
    #DEFINES += "APP_Vendor=\"'$$APP_Vendor'\""
    DEFINES += APP_Version=\"$$APP_Version\"
    DEFINES += APP_UID=\"$$APP_UID\"
    #DEFINES += RESTART_CODE=12

    #App Icon:
    ICON = BatteryStatus.svg

    ## App Vendor:
    vendorInfo = "%{\"Motaz Alnuweiri\", \"معتز النويري\"}" ":\"Allstar Software\""
    vendorInfoPKG.pkg_prerules = vendorInfo
    DEPLOYMENT += vendorInfoPKG

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

    #TARGET.EPOCSTACKSIZE = 0x14000
    TARGET.EPOCHEAPSIZE = 0x20000 0x2000000

    # -- Symbian Libarrys: --
    # Libs for PSMode
    LIBS += -lpsmclient

    # Libs for App Switcher:
    LIBS += -lapgrfx -lcone -lws32
    LIBS += -lavkon -leikcore -leiksrv #CAknAppUi

    # Libs for CFbsBimap:
    LIBS += -lfbscli #-lbitgdi #-laknskins -laknskinsrv -laknswallpaperutils -leikcore

    # Libs for Global Note:
    LIBS += -lavkon -laknnotify -leiksrv

    # Show Note:
#    myNotes = \
#    ";English Note"\
#    "IF LANGUAGE=01"\
#    "    \"languages\mynote_en.txt\" - \"\", FILETEXT, TEXTCONTINUE" \
#    ";Arabic Note"\
#    "ELSEIF LANGUAGE=37"\
#    "    \"languages\mynote_ar.txt\" - \"\", FILETEXT, TEXTCONTINUE" \
#    "endif"

#    myNotesFilesPKG.pkg_prerules.main = myNotes
#    DEPLOYMENT += myNotesFilesPKG

    # Add HSWidget DLL Lib:
    hSWidgetFile.sources = $${Widget_Lib}
    hSWidgetFile.path = !:/sys/bin
    DEPLOYMENT += hSWidgetFile

    # Add Languages Folder:
    languagesFolder.sources = languages/*.qm
    languagesFolder.path = Languages
    DEPLOYMENT += languagesFolder

    # Add Sound Folder:
    soundsFolder.sources = qml/BatteryStatus/Sounds
    DEPLOYMENT += soundsFolder

    # Add Symbian AutoStart Info & File:
#    autoStart = \
#    "SOURCEPATH      ." \
#    "START RESOURCE SymAutoStart.rss" \
#    "END"

#    MMP_RULES += autoStart

#    autoStartFile = "\"$${EPOCROOT}epoc32/data/SymAutoStart.rsc\" - \"!:/private/101f875a/import/[$$APP_UID].rsc\""
#    autoStartFilePKG.pkg_postrules += autoStartFile
#    DEPLOYMENT += autoStartFilePKG

    ### Symbian PKG Settings ####

    ## Clear all existing pkg dependencies, header, vendor id and language line (as these are single language)
    #default_deployment.pkg_prerules =

    ## Define pkg languages  (in this case for English, French and Zulu, in that order)
    #languages = "&EN, AR"

    ## Define the package header. Note that the application name is translatable, and is declared for each
    #packageheader = "$${LITERAL_HASH}{\"Battery Status\", \"حالة البطارية\"}, ($${TARGET.UID3}), 0, 0, 2, TYPE=SA"

    ## Define the language neutral global vendor name.
    #vendorinfo = \
    #"%{\"Motaz Alnuweiri\", \"معتز النويري\"}" \
    #":\"Motaz Alnuweiri\""

    ## Define the dependencies. As above, you need strings for each translation of the dependency and in the same order as
    #dependencyinfo = \
    #"; Default HW/platform dependencies" \
    #"[0x20022E6D],0,0,0,{\"S60ProductID\",\"S60ProductID\"}" \
    #"[0x20032DE7],0,0,0,{\"S60ProductID\",\"S60ProductID\"}"

    ## Define the Qt component dependency. The string "Qt" can be used for all translations
    #qtdependency = \
    #"(0x2001E61C), $${QT_MAJOR_VERSION}, $${QT_MINOR_VERSION}, $${QT_PATCH_VERSION}, {\"Qt\",\"Qt\"}" \
    #"(0x200346DE), 1, 0, 0, {\"Qt Quick components for Symbian\",\"Qt Quick components for Symbian\"}" \
    #"(0x2002AC89), 1, 2, 0, {\"QtMobility\",\"QtMobility\"}"

    ## For smart installer, define name string in each language
    #DEPLOYMENT.installer_header = "$${LITERAL_HASH}{\"Battery Status Installer\", \"مثبت حالة البطارية\"},($${TARGET.UID3}),0,0,1"

    ## Define Note
    #mynote = "\"myinstallnote.txt\" - \"\", FILETEXT, TEXTCONTINUE"

    #my_deployment.pkg_prerules = languages packageheader vendorinfo dependencyinfo qtdependency mynote
    #DEPLOYMENT += my_deployment

}


# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# http://doc.qt.digia.com/qtmobility-1.2/quickstart.html
CONFIG += mobility
MOBILITY += systeminfo

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

# Add dependency to Symbian components:
CONFIG += qt-components

# Localize for Symbian:
CONFIG += localize_deployment

# The *.cpp & *.h files which was generated for your project. Feel free to hack it.
SOURCES += src/main.cpp \
    src/qappsettings.cpp \
    src/qbatteryflow.cpp \
    src/symbian/qpsmode.cpp \
    src/symbian/qpsmode_p.cpp \
    src/symbian/qsymbianapplication.cpp \
    src/symbian/hswidget/qbatteryhswidget.cpp \
    src/qcbatteryinfo.cpp \
    src/symbian/qglobalnote.cpp \
    src/qdevicename.cpp \
    src/symbian/qsymbianhelper.cpp

HEADERS += \
    src/qappsettings.h \
    src/qbatteryflow.h \
    src/symbian/qpsmode.h \
    src/symbian/qpsmode_p.h \
    src/symbian/qsymbianapplication.h \
    src/symbian/hswidget/qhswidget.h \
    src/symbian/hswidget/qbatteryhswidget.h \
    src/qcbatteryinfo.h \
    src/symbian/qglobalnote.h \
    src/qdevicename.h \
    src/symbian/qsymbianhelper.h \
    src/qmsghandler.h \
    src/commontype.h \
    src/qsleep.h

# Resources files *.qrc for Qt & qml
RESOURCES += \
    batterystatus.qrc

# Translations files *.ts for Qt & qml
TRANSLATIONS += \
    languages/batterystatus_en.ts \
    languages/batterystatus_ar.ts

# Include other files to the project
OTHER_FILES += \
    qml/BatteryStatus/main.qml \
    qml/BatteryStatus/MainPage.qml \
    qml/BatteryStatus/SettingsPage.qml \
    qml/BatteryStatus/AboutDialog.qml \
    qml/BatteryStatus/Components/SwitchListItem.qml \
    qml/BatteryStatus/Components/SwipeArea.qml \
    qml/BatteryStatus/Components/MenuItemWithIcon.qml \
    qml/BatteryStatus/Components/LineItem.qml \
    qml/BatteryStatus/Components/InfoItem.qml \
    qml/BatteryStatus/Components/HeadingListItem.qml \
    qml/BatteryStatus/AppStyle.qml \
    qml/BatteryStatus/SymbianStyle.qml \
    qml/BatteryStatus/Components/SliderListItem.qml \
    qml/BatteryStatus/ResetDialog.qml \
    qml/BatteryStatus/ExitDialog.qml \
    qml/BatteryStatus/Components/RadioListItem.qml \
    qml/BatteryStatus/Components/ToolTipEx.qml \
    qml/BatteryStatus/Components/TimeInfoItem.qml \
    qml/BatteryStatus/Components/GUIInfoItem.qml \
    qml/BatteryStatus/Components/LinkLabel.qml

# Add Files So You Can Run Lupdate
#{ SOURCES += \
#    qml/BatteryStatus/*.qml \
#    qml/BatteryStatus/Components/*.qml }

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

#Avoid auto screen rotation
#DEFINES += ORIENTATIONLOCK
