#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

//----------------------------------------------------------------------------//

CLIPPER KBDCONTROL()
{
   KBDINFO keyb;
   HKBD hKey = 0;

   KbdGetStatus( ( PKBDINFO) &keyb, hKey );

   _retl( keyb.fsState & 8 );
}

//----------------------------------------------------------------------------//

CLIPPER KBDSHIFT()
{
   KBDINFO keyb;
   HKBD hKey = 0;

   KbdGetStatus( ( PKBDINFO) &keyb, hKey );

   _retl( keyb.fsState & 6 );
}

//----------------------------------------------------------------------------//
