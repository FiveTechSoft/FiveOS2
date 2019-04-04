#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

//----------------------------------------------------------------------------//

CLIPPER CURSORWE()
{
   _retl( WinSetPointer( HWND_DESKTOP,
          WinQuerySysPointer( HWND_DESKTOP, SPTR_SIZEWE, 0 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER CURSORARRO() // W()
{
   _retl( WinSetPointer( HWND_DESKTOP,
          WinQuerySysPointer( HWND_DESKTOP, SPTR_ARROW, 0 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER CURSORIBEA() // M()
{
   _retl( WinSetPointer( HWND_DESKTOP,
          WinQuerySysPointer( HWND_DESKTOP, SPTR_TEXT, 0 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINCREATEC() // URSOR( hWnd, nX, nY, nWidth, nHeight, nShape,
                     //        aRect ) --> lSuccess
{
   RECTL rct;

   if( ISARRAY( 7 ) )
   {
      rct.yTop    = _parnl( 7, 1 );
      rct.xLeft   = _parnl( 7, 2 );
      rct.yBottom = _parnl( 7, 3 );
      rct.xRight  = _parnl( 7, 4 );
   }

   _retl( WinCreateCursor( ( HWND ) _parnl( 1 ),
                           _parnl( 2 ), _parnl( 3 ), _parnl( 4 ), _parnl( 5 ),
                           IF( ISNUM( 6 ), _parnl( 6 ), CURSOR_FLASH ),
                           IF( ISARRAY( 7 ), &rct, 0 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINDESTCUR() // SOR( hWnd )  --> lSuccess
{
   _retl( WinDestroyCursor( ( HWND ) _parnl( 1 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINSHOWCUR() // SOR( hWnd, lShow )  --> lSuccess
{
   _retl( WinShowCursor( ( HWND ) _parnl( 1 ), _parl( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINQUERYCU() // RSORINFO( hWnd ) --> aInfo or nil
{
   CURSORINFO cursor;

   if( WinQueryCursorInfo( ( HWND ) _parnl( 1 ), ( PCURSORINFO ) &cursor ) )
   {
      _reta( 6 );
      _stornl( -1, 1, cursor.hwnd );
      _storni( -1, 2, cursor.y );
      _storni( -1, 3, cursor.x );
      _storni( -1, 4, cursor.cx );
      _storni( -1, 5, cursor.cy );
      _storni( -1, 6, cursor.fs );
   }
   else
      _ret();
}

//----------------------------------------------------------------------------//

CLIPPER GETCARETPO() // INT( hWnd ) --> { nRow, nCol }
{
   CURSORINFO cursor;

   WinQueryCursorInfo( ( HWND ) _parnl( 1 ), ( PCURSORINFO ) &cursor );

   _reta( 2 );
   _storni( cursor.x, -1, 1 );
   _storni( cursor.y, -1, 2 );
}

//----------------------------------------------------------------------------//
