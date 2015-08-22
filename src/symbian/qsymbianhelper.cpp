/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qsymbianhelper.h"
#include <QTextEdit>
#include <QDialog>

CApaWindowGroupName *wgName;
TApaTask *appTask;
CAknAppUi *appUi;

TInt errappUi;

void regWGName()
{
    wgName = CApaWindowGroupName::NewLC( CEikonEnv::Static()->WsSession(),
                                         CEikonEnv::Static()->RootWin().Identifier() );
}

void unregWGName()
{
    CleanupStack::PopAndDestroy( wgName );
}

void regAppTask()
{
    appTask = new TApaTask( CEikonEnv::Static()->WsSession() );
    appTask->SetWgId( CEikonEnv::Static()->RootWin().Identifier() );
}

void regAppUi()
{
    errappUi = KErrNone;
    TRAPD(errappUi, appUi = dynamic_cast<CAknAppUi*>( CEikonEnv::Static()->AppUi() ));
}

void QSymbianHelper::run(QString process, QStringList arguments)
{
    QProcess tProcess;
    tProcess.start(process, arguments);
}

void QSymbianHelper::kill(QString process)
{
    TPtrC16 symProcess(static_cast<const TUint16*>(process.utf16()));
    TFullName fullName;
    TFindProcess findProcess(symProcess);

    while(findProcess.Next(fullName) == KErrNone)
    {
        RProcess rProcess;
        rProcess.Open(findProcess);
        rProcess.Kill(KErrNone);
        rProcess.Close();
    }
}

void QSymbianHelper::copy(QString source, QString target)
{
    QFile::copy(source, target);
}

void QSymbianHelper::rename(QString file, QString newName)
{
    QDir myDir;
    myDir.rename(file, newName);
}

void QSymbianHelper::remove(QString file)
{
    QDir tDir;
    tDir.remove(file);
}

void QSymbianHelper::clipboardCopy(QString text)
{
    QClipboard *clipboard = qApp->clipboard();
    clipboard->setText(text);
}

void QSymbianHelper::restartApp()
{
    QProcess::startDetached(qApp->applicationFilePath());
    qApp->exit();
}

void QSymbianHelper::lockPhone()
{
    RAknKeyLock keyLock;
    keyLock.Connect();
    keyLock.EnableWithoutNote();
    //keyLock.DisableWithoutNote();
    keyLock.Close();
}

void QSymbianHelper::bringToForeground()
{
    regAppTask();
    appTask->BringToForeground();
}

void QSymbianHelper::sendToBackground()
{
    regAppTask();
    appTask->SendToBackground();
}

void QSymbianHelper::hideInBackground()
{
    regAppUi();
    if(KErrNone == errappUi) {
        appUi->HideInBackground();
    }
}

void QSymbianHelper::setHide(bool value)
{
    regWGName();
    wgName->SetHidden( value ? ETrue : EFalse );
    wgName->SetWindowGroupName( CEikonEnv::Static()->RootWin() );
    unregWGName();
}

void QSymbianHelper::setSystem(bool value)
{
    regWGName();
    wgName->SetSystem( value ? ETrue : EFalse );
    wgName->SetWindowGroupName( CEikonEnv::Static()->RootWin() );
    unregWGName();
}

void QSymbianHelper::setHideFromFSW(bool value)
{
    regAppUi();
    if(KErrNone == errappUi) {
        appUi->HideApplicationFromFSW( value ? ETrue : EFalse );
    }
}

bool QSymbianHelper::isHide()
{
    regWGName();
    bool value = (wgName->Hidden() == TRUE) ? true : false;
    unregWGName();

    return value;
}

bool QSymbianHelper::isSystem()
{
    regWGName();
    bool value = (wgName->IsSystem() == TRUE) ? true : false;
    unregWGName();

    return value;
}

bool QSymbianHelper::isRightToLeft()
{
    switch (User::Language()) {
    // These are the right-to-left UI languages supported in Symbian
    case ELangArabic:
    case ELangHebrew:
    case ELangFarsi:
    case ELangUrdu:
        return true;

    default:
        return false;
    }
}

