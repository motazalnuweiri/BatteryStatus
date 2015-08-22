/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#include "qpsmode_p.h"

QPSModePrivate* QPSModePrivate::NewL(QPSMode *aPublicAPI)
{
    QPSModePrivate* self = new (ELeave) QPSModePrivate(aPublicAPI);
    // push onto cleanup stack in case self->ConstructL leaves
    CleanupStack::PushL(self);
    // complete construction with second phase constructor
    self->ConstructL();
    CleanupStack::Pop(self);

    return self;
}

QPSModePrivate::QPSModePrivate(QPSMode *aPublicAPI)
 : iPublicPSMode(aPublicAPI), CActive(CActive::EPriorityStandard)
{
    CActiveScheduler::Add(this);
}

void QPSModePrivate::ConstructL()
{
    QT_TRAP_THROWING(iPsmClient = CPsmClient::NewL( *this ));
    iPsmClient->RequestPowerSaveModeNotification();
}

QPSModePrivate::~QPSModePrivate()
{
    Cancel();
    delete iPsmClient;
    iPsmClient = NULL;
}

void QPSModePrivate::Enable()
{
    iPsmClient->CancelPowerSaveModeNotificationRequest();
    iPsmClient->ChangePowerSaveMode(EPsmsrvModePowerSave);
}

void QPSModePrivate::Disable()
{
    iPsmClient->CancelPowerSaveModeNotificationRequest();
    iPsmClient->ChangePowerSaveMode(EPsmsrvModeNormal);
}

bool QPSModePrivate::IsEnable()
{
    TInt err = iPsmClient->PsmSettings().GetCurrentMode(iActivePsm);

    if (err == KErrNone) {
        switch (iActivePsm) {
        case EPsmsrvModeNormal:
            return false;

        case EPsmsrvModePowerSave:
        case EPsmsrvPartialMode:
            return true;

        default:
            return false;
        }
    }
}

void QPSModePrivate::DoCancel()
{
}

void QPSModePrivate::RunL()
{
}

void QPSModePrivate::PowerSaveModeChangeError(const TInt aError)
{
    // ignore error if it is due cancellation of notification request
    if ( aError != KErrCancel ) {
        // new request would cause another completion with this error code (infinitely)
        if ( aError != KErrServerTerminated ) {
            // must be requested after every completion
            iPsmClient->RequestPowerSaveModeNotification();
            QT_TRYCATCH_LEAVING(emit iPublicPSMode->statusChanged());
        }
    }
}

void QPSModePrivate::PowerSaveModeChanged(const TPsmsrvMode aMode)
{
    // must be requested after every completion
    iPsmClient->RequestPowerSaveModeNotification();
    QT_TRYCATCH_LEAVING(emit iPublicPSMode->statusChanged());
}
