#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

BOOL pascal WinPopupMenu( HWND, HWND, HWND, LONG, LONG, ULONG, WORD );

//----------------------------------------------------------------------------//

CLIPPER WINCREATEM() // ENU()
{
   _retnl( ( LONG ) WinCreateMenu( ( HWND ) _parnl( 1 ), ( PVOID ) _parnl( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER MNUITEM()
{
   MENUITEM mit;

   mit.iPosition   = _parni( 3 );
   mit.afStyle     = IF( ISCHAR( 2 ), MIS_TEXT, MIS_SEPARATOR );
   mit.afAttribute = IF( ! _parl( 6 ), MIA_DISABLED, 0 );
   mit.id          = _parni( 5 );
   mit.hwndSubMenu = _parnl( 4 );
   mit.hItem       = 0;

   _retni( ( LONG ) WinSendMsg( ( HWND ) _parnl( 1 ), MM_INSERTITEM,
                                &mit, ( MPARAM ) _parc( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINPOPUPME() // NU( hWndParent, hWndOwner, hMenu, nRow, nCol ) --> lSuccess
{
   _retl( WinPopupMenu( ( HWND ) _parnl( 1 ),
                        ( HWND ) _parnl( 2 ),
                        ( HWND ) _parnl( 3 ),
                        _parni( 4 ), _parni( 5 ), _parnl( 6 ), _parnl( 7 ) ) );
}

//----------------------------------------------------------------------------//
