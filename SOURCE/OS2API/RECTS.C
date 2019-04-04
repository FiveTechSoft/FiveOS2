#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

//----------------------------------------------------------------------------//

CLIPPER WINQRYRCT()     //  hWnd  -->  { nTop, nLeft, nBottom, nRight }
{
   RECTL rct;

   WinQueryWindowRect( (HWND)_parnl( 1 ), &rct );

   _reta( 4 );
   _storni( rct.yTop,    -1, 1 );
   _storni( rct.xLeft,   -1, 2 );
   _storni( rct.yBottom, -1, 3 );
   _storni( rct.xRight,  -1, 4 );
}

//----------------------------------------------------------------------------//

CLIPPER WININVERTR() // ECT( hDC, { nTop, nLeft, nBottom, nRight } ) --> lSuccess
{
   RECTL rct;

   rct.xLeft   = _parni( 2, 1 );
   rct.yBottom = _parni( 2, 2 );
   rct.xRight  = _parni( 2, 3 );
   rct.yTop    = _parni( 2, 4 );

   _retl( WinInvertRect( ( HPS ) _parnl( 1 ), &rct ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINFILLREC() // T( hPS, aRect, lColor, hWnd ) --> lSuccess
{
   RECTL rct;
   HPS   hPS = _parnl( 1 );

   // GpiCreateLogColorTable(hPS=_parnl(1), 0L, LCOLF_RGB, 0L, 0L, (PLONG)NULL );

   if( ! ISARRAY( 2 ) )
      WinQueryWindowRect( ( HWND ) _parnl( 4 ), &rct );
   else
   {
      rct.yTop    = _parni( 2, 1 );
      rct.xLeft   = _parni( 2, 2 );
      rct.yBottom = _parni( 2, 3 );
      rct.xRight  = _parni( 2, 4 );
   }

   _retl( WinFillRect( hPS, &rct, _parnl( 3 ) ) );
}

//----------------------------------------------------------------------------//
