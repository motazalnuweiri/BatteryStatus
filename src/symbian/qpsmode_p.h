/**
* Author: Motaz Alnuweiri
* Email: motaz_alnuweiri@hotmail.com
* Copyright: Copyright (C) 2015 for Motaz Alnuweiri, All rights reserved.
**/

#ifndef PSMMODE_P_H
#define PSMMODE_P_H

#include <psmclientobserver.h>
#include <psmclient.h>
#include <psmsettings.h>
#include <qpsmode.h>

class QPSModePrivate : public CActive, public MPsmClientObserver
{
public:
    static QPSModePrivate* NewL(QPSMode *aPublicAPI = 0);
    ~QPSModePrivate();

public:
    void Enable();
    void Disable();
    bool IsEnable();

public: //From CActive
    /**
    * Implements cancellation of an outstanding request.
    */
    virtual void DoCancel();

    /**
    Handles an active object's request completion event.
    */
    void RunL();

protected:
    void PowerSaveModeChangeError( const TInt aError );
    void PowerSaveModeChanged( const TPsmsrvMode aMode );

private:
    QPSModePrivate(QPSMode *aPublicAPI = 0);  //constructor
    void ConstructL();  //Second phase constructor - connects to socket server and finds protocol

//private:
//    void ErrorConvertToLocal(int err);

private:
    CPsmClient *iPsmClient;
    TInt iActivePsm;

    //pointer to parent object (from constructor). Not owned by this class
    QPSMode *iPublicPSMode;
};

#endif // PSMMODE_P_H
