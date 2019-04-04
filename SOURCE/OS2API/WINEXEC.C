#define INCL_BASE
#define INCL_WIN
#define INCL_GPI


#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

CLIPPER WinExec(){
   STARTDATA   StartData;    /* Start session data structure */
   ULONG       SessID;       /* Session ID (returned) */
   PID         PID;          /* Process ID (returned) */

   _bset(&StartData,0,sizeof(STARTDATA));
   
   StartData.Length = sizeof(STARTDATA);


   StartData.PgmTitle=_parc( 3 );
           
   StartData.PgmName =_parc( 1 );

   StartData.PgmControl = (PCOUNT() > 1 ? _parni(2) : 0 );
   
   DosStartSession(&StartData, &SessID, &PID);
   
   _retnl(PID);

}

CLIPPER Os2Exec(){
   STARTDATA   StartData;    /* Start session data structure */
   ULONG       SessID;       /* Session ID (returned) */
   PID         PID;          /* Process ID (returned) */

   _bset(&StartData,0,sizeof(STARTDATA));
   
   StartData.Length = sizeof(STARTDATA);


   StartData.PgmTitle=_parc( 3 );

   StartData.PgmName =_parc( 1 );

   StartData.PgmControl = (PCOUNT() > 1 ? _parni(2) : 0 );
   
   DosStartSession(&StartData, &SessID, &PID);
   
   _retnl(PID);

}

