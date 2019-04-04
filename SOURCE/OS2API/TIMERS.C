#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

HAB GetHab( void );

//----------------------------------------------------------------------------//

CLIPPER WINSTARTTI() // MER( hWnd, idTimer, nInterval )  --> nIdTimer
{
   _retnl( WinStartTimer( GetHab(), ( HWND ) _parnl( 1 ),
                          _parnl( 2 ), _parnl( 3 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINSTOPTIM() // ER( hWnd, nIdTimer ) --> lSuccess
{
   _retl( WinStopTimer( GetHab(), ( HWND ) _parnl( 1 ), _parnl( 2 ) ) );
}

//----------------------------------------------------------------------------//
