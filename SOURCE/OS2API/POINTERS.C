#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

//----------------------------------------------------------------------------//

CLIPPER WINQRYSYSP()  // OINTER()    hWnd, nResId, lCreate  --> hCursor
{
   _retnl( ( LONG ) WinQuerySysPointer( ( HWND ) _parnl( 1 ), _parnl( 2 ),
                                        _parl( 3 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINSETPOIN() // TER()   hWnd, hCursor
{
   WinSetPointer( ( HWND ) _parnl( 1 ), ( HPOINTER ) _parnl( 2 ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINLOADPOI() // NTER( hModule, nResId )  --> hCursor
{
   _retnl( ( LONG ) WinLoadPointer( HWND_DESKTOP,
                                    ( HMODULE ) _parnl( 1 ),
                                    ( ULONG ) _parnl( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINDESTPOI() // NTER( hCursor )  --> lSuccess
{
   _retl( WinDestroyPointer( ( HPOINTER ) _parnl( 1 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINDRAWPOI() // NTER( hPS, nRow, nCol, hCursor, nMode )  --> lSuccess
{
   _retl( WinDrawPointer( ( HPS ) _parnl( 1 ),
                          _parni( 2 ), _parni( 3 ), ( HPOINTER ) _parnl( 4 ),
                          _parnl( 5 ) ) );
}

//----------------------------------------------------------------------------//
