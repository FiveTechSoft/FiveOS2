#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

#define LOWORD(l)  ((WORD)(l))
#define HIWORD(l)  ((WORD)((DWORD)(l) >> 16))

//----------------------------------------------------------------------------//

CLIPPER GETSCROLLR() // ANGE()    hScrollBar ---> { nMin, nMax }
{
   LONG lRange = WinSendMsg( ( HWND ) _parnl( 1 ), SBM_QUERYRANGE, 0, 0 );

   _reta( 2 );
   _storni( LOWORD( lRange ), -1, 1 );
   _storni( HIWORD( lRange ), -1, 2 );
}

//----------------------------------------------------------------------------//
