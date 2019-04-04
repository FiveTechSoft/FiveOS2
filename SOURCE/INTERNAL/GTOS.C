#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <os2.h>
#include <ClipApi.h>

// En principio nos hace falta por el Row(), Col(), MaxRow(), MaxCol()

// General Terminal for IBM-OS2

extern LPBYTE _u2Hex( WORD );

extern CLIPCOLOR * _Colors;

static CLIPCOLOR gtColors[ 5 ];

static WORD wCrsRow, wCrsCol;
static WORD wCrsType;

WORD _gtScrDim( LPWORD pwRows, LPWORD pwCols )  { return 0; }

WORD _gtIsColor( void ) { return TRUE; }

//----------------------------------------------------------------------------//

WORD _gtMaxRow( void )
{
   /*
   HWND hDesktop = GetDesktopWindow();
   HDC hDC       = GetDC( hDesktop );
   TEXTMETRIC tm;
   RECT rctDesktop;

   GetWindowRect( hDesktop, &rctDesktop );
   GetTextMetrics( hDC, &tm );
   ReleaseDC( hDesktop, hDC );

   return ( rctDesktop.bottom - rctDesktop.top ) / tm.tmHeight;
   */
   return 0;
}

//----------------------------------------------------------------------------//

WORD _gtMaxCol( void )
{
   /*
   HWND hDesktop = GetDesktopWindow();
   HDC hDC       = GetDC( hDesktop );
   TEXTMETRIC tm;
   RECT rctDesktop;

   GetWindowRect( hDesktop, &rctDesktop );
   GetTextMetrics( hDC, &tm );
   ReleaseDC( hDesktop, hDC );

   return ( rctDesktop.right - rctDesktop.left ) / 8;
   */
   return 0;
}

//----------------------------------------------------------------------------//

WORD _gtSetCursor( WORD wType )
{
   WORD wOldCrs = wCrsType;
 /*
   switch( wType )
   {
      case 0:
           wCrsType = 0;
           HideCaret( GetActiveWindow() );
           break;

      case 1:
           wCrsType = 1;
           ShowCaret( GetActiveWindow() );
           break;
   }
 */
   return wOldCrs;
}

//----------------------------------------------------------------------------//

WORD _gtGetCursor( void ) { return wCrsType; }

//----------------------------------------------------------------------------//

WORD _gtSetPos( WORD wRow, WORD wCol )
{
   wCrsRow = wRow;
   wCrsCol = wCol;
   return 0;
}

//----------------------------------------------------------------------------//

WORD _gtGetPos( WORD * pwRow, WORD * pwCol )
{
   * pwRow = wCrsRow;
   * pwCol = wCrsCol;
   return 0;
}

//----------------------------------------------------------------------------//

WORD _gtSetColor( CLIPCOLOR * pColor )
{
   _bcopy( gtColors, pColor, sizeof( CLIPCOLOR ) * 5 );
   return 0;
}

WORD _gtGetColor( CLIPCOLOR * pColor )
{
   _bcopy( pColor, gtColors, sizeof( CLIPCOLOR ) * 5 );
   return 0;
}

WORD _gtSetBorder( void )  { return 0; }
WORD _gtBeginWrite( void ) { return 0; }
WORD _gtEndWrite( void )   { return 0; }

//----------------------------------------------------------------------------//

WORD _gtScroll( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight, int iLines )
{
   /*
   HWND hWnd = GetActiveWindow();
   HDC  hDC  = GetDC( hWnd );
   TEXTMETRIC tm;
   RECT rct;
   HFONT hFont = GetStockObject( SYSTEM_FIXED_FONT );
   HFONT hOldFont = SelectObject( hDC, hFont );

   GetTextMetrics( hDC, &tm );

   rct.top    = wTop    * tm.tmHeight;
   rct.left   = wLeft   * tm.tmAveCharWidth;
   rct.bottom = wBottom * tm.tmHeight;
   rct.right  = wRight  * tm.tmAveCharWidth;

   SetBkColor( hDC, RGB( ( gtColors[ 0 ].Fore.Attr & 0x80 ) ? gtColors[ 0 ].Back.Red : gtColors[ 0 ].Back.Red / 2,
                         ( gtColors[ 0 ].Fore.Attr & 0x80 ) ? gtColors[ 0 ].Back.Green : gtColors[ 0 ].Back.Green / 2,
                         ( gtColors[ 0 ].Fore.Attr & 0x80 ) ? gtColors[ 0 ].Back.Blue : gtColors[ 0 ].Back.Blue / 2 ) );

   ScrollWindow( hWnd, 0, -iLines, 0, &rct );

   SelectObject( hDC, hOldFont );
   ReleaseDC( hWnd, hDC );

   */
   return 0;
}

//----------------------------------------------------------------------------//

WORD _gtWriteAt( WORD wRow, WORD wCol, LPSTR szText, WORD wLen )
{

   /*
   HWND hWnd = GetActiveWindow();
   HDC  hDC  = GetDC( hWnd );
   TEXTMETRIC tm;
   HFONT hFont = GetStockObject( SYSTEM_FIXED_FONT );
   HFONT hOldFont = SelectObject( hDC, hFont );

   GetTextMetrics( hDC, &tm );

   SetTextColor( hDC, RGB( ( gtColors[ 0 ].Fore.Attr & 0x20 ) ? gtColors[ 0 ].Fore.Red : gtColors[ 0 ].Fore.Red / 2,
                           ( gtColors[ 0 ].Fore.Attr & 0x20 ) ? gtColors[ 0 ].Fore.Green : gtColors[ 0 ].Fore.Green / 2,
                           ( gtColors[ 0 ].Fore.Attr & 0x20 ) ? gtColors[ 0 ].Fore.Blue : gtColors[ 0 ].Fore.Blue / 2 ) );

   SetBkColor( hDC, RGB( ( gtColors[ 0 ].Fore.Attr & 0x80 ) ? gtColors[ 0 ].Back.Red : gtColors[ 0 ].Back.Red / 2,
                         ( gtColors[ 0 ].Fore.Attr & 0x80 ) ? gtColors[ 0 ].Back.Green : gtColors[ 0 ].Back.Green / 2,
                         ( gtColors[ 0 ].Fore.Attr & 0x80 ) ? gtColors[ 0 ].Back.Blue : gtColors[ 0 ].Back.Blue / 2 ) );

   // TextOut( hDC, tm.tmAveCharWidth * wCol, tm.tmHeight * wRow,
   //         szText, wLen );


   wCrsCol += wLen;
   wCrsRow = wRow;

   if( wCrsCol > _gtMaxCol() )
   {
      wCrsCol = 0;
      wCrsRow++;
   }

   SelectObject( hDC, hFont );
   ReleaseDC( hWnd, hDC );
   */


   return 0;
}

//----------------------------------------------------------------------------//

WORD _gtWrite( LPSTR szText, WORD wLen )
{
   _gtWriteAt( wCrsRow, wCrsCol, szText, wLen );
   return 0;
}

//----------------------------------------------------------------------------//

WORD _gtWriteCon( LPSTR szText, WORD wLen )
{
   if( * szText == 13 || * szText == 10 )
   {
      wCrsRow++;
      wCrsCol = 0;
      _gtWrite( szText + 2, wLen - 2 );
   }
   else
      _gtWrite( szText, wLen );

   return 0;
}

//----------------------------------------------------------------------------//

WORD _gtRepChar( WORD wRow, WORD wCol, WORD wChar, WORD wTimes )
{
   BYTE * pString = _xgrab( wTimes + 1 );

   _bset( pString, wChar, wTimes );
   pString[ wTimes ] = 0;

   _gtWriteAt( wRow, wCol, pString, wTimes );
   _xfree( pString );

    return 0;
}

//----------------------------------------------------------------------------//

WORD _gtRectSize( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight, LPWORD wResult ) { return 0; }

//----------------------------------------------------------------------------//

WORD _gtSave( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight, LPBYTE pBuffer )
{
    return 0;
}

//----------------------------------------------------------------------------//

WORD _gtRest( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight, LPBYTE pBuffer )
{
    return 0;
}

//----------------------------------------------------------------------------//

WORD _gtBox( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight, LPSTR szBox )
{
    return 0;
}

//----------------------------------------------------------------------------//

WORD _gtBoxS( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight )
{
    return 0;
}

//----------------------------------------------------------------------------//

WORD _gtBoxD( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight )
{
   return 0;
}

WORD _gtSetSnowFlag( void ) { return 0; }
WORD _gtSetBlink( void ) { return 0; }

WORD _gtModalRead( void ) { return 0; }

WORD _gtFlushCursor( void ) { return 0; }
WORD _gtPreExt( void ) { return 0; }
WORD _gtPostExt( void ) { return 0; }
WORD _gtSetMode( void ) { return 0; }

WORD _gtExit( void ) { return 0; }

WORD _gtInit( void )
{
//    _bcopy( (LPBYTE) gtColors, ( LPBYTE ) _Colors, 5 * sizeof( CLIPCOLOR ) );

    return 0;
}

WORD _gtSLR( void ) { return 0; }

void pascal DISPBEGIN() {}
void pascal DISPEND()   {}
void pascal DISPCOUNT() {}

//----------------------------------------------------------------------------//

void _gtWCreate( LPgtRECT rctCoors, PgtHWND hWnd ) {}

void _gtWCurrent( gtHWND hWnd ) {}

BOOL _gtWVis( gtHWND hWnd, WORD wStatus ) {}

BOOL _gtWFlash( void ) {}

void _gtWApp( PgtHWND hWndApp ) {}

void _gtWPos( gtHWND hWnd, LPgtRECT rctCoors ) {}

void _gtWDestroy( gtHWND hWnd ) {}

//----------------------------------------------------------------------------//

void _gtDispBegin( void ) {}
void _gtDispCount( void ) {}
void _gtDispEnd( void )   {}

//----------------------------------------------------------------------------//
