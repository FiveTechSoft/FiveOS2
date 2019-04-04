#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

typedef MRESULT ( EXPENTRY * WNDPROC ) ( HWND, USHORT, MPARAM, MPARAM );

//----------------------------------------------------------------------------//

CLIPPER WINSENDMSG()
{
   _retnl( ( LONG ) WinSendMsg( ( HWND ) _parnl( 1 ), _parni( 2 ),
                   ( MPARAM ) IF( ISCHAR( 3 ), _parc( 3 ), _parnl( 3 ) ),
                   ( MPARAM ) IF( ISCHAR( 4 ), _parc( 4 ), _parnl( 4 ) ) ) );
}


//----------------------------------------------------------------------------//

CLIPPER CALLWINDOW() // PROC( nProc, hWnd, nMsg, nLParam1, nLParam2 ) --> nResult
{
   PFNWP nProc = ( PFNWP ) _parnl( 1 );

   _retnl( ( LONG ) ( nProc )( ( HWND ) _parnl( 2 ),
                      _parni( 3 ),
                      ( MPARAM ) IF( ISCHAR( 4 ), _parc( 4 ), _parnl( 4 ) ),
                      ( MPARAM ) IF( ISCHAR( 5 ), _parc( 5 ), _parnl( 5 ) ) ) );
}

//----------------------------------------------------------------------------//
