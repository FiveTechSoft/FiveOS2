#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

HAB GetHab( void );

MRESULT EXPENTRY WindowProc( HWND hwnd, USHORT msg, MPARAM mp1, MPARAM mp2 );

void HandleEvent( PCLIPVAR, USHORT, MPARAM, MPARAM );

//----------------------------------------------------------------------------//

CLIPPER WINREGISTE() // RCLASS
{

   _retl( WinRegisterClass( GetHab(),         // OS2 anchor block handle
                            _parc( 1 ),       // Class Name
                            ( PFNWP ) WindowProc,  // Our default Class procedure
                            _parnl( 2 ),      // style
                            _parnl( 3 ) ) );  // extra bytes
                            
}

//----------------------------------------------------------------------------//

CLIPPER WINCREATES() // TDWINDOW()
{
   ULONG lFrame = _parnl( 3 );
   HWND hWndClient,hWndFrame;
   

   _retnl( ( LONG ) hWndFrame = WinCreateStdWindow( ( HWND ) _parnl( 1 ),   // hWndParent
                               _parnl( 2 ),   // style
                               &lFrame,       // lFrame
                               _parc( 4 ),    // cClassName
                               _parc( 5 ),    // cCaption
                               _parnl( 6 ),   // lStyleClient
                               _parnl( 7 ),   // hModule
                               _parnl( 8 ),   // nId
                   ( PHWND ) &hWndClient ) ); // Window identifier

      
   _stornl( ( LONG ) hWndClient, 9 );
}

//----------------------------------------------------------------------------//

MRESULT EXPENTRY WindowProc( HWND hwnd, USHORT msg, MPARAM mp1, MPARAM mp2 )
{
   HPS hps;

   switch( msg )
   {
      case WM_ERASEBACKGROUND:
           return FALSE;

      case WM_PAINT:
           hps = WinBeginPaint( hwnd, 0L, NULL );
           WinEndPaint( hps );
           return 0;

/*      case WM_CLOSE:
           WinAlarm(HWND_DESKTOP,WA_WARNING);
           if (hWndApp == hwnd ){
              WinPostMsg( hwnd, WM_QUIT, 0, 0 );
              return 0;
           }
*/           
    }
    return WinDefWindowProc( hwnd, msg, mp1, mp2 );
}

//----------------------------------------------------------------------------//

CLIPPER WINDEFWIND() // OWPROC( hWnd, nMsg, nLParam1, nLParam2 )
{
   _retnl( ( LONG ) WinDefWindowProc( ( HWND ) _parnl( 1 ),
                             ( USHORT ) _parni( 2 ),
                             ( MPARAM ) _parnl( 3 ),
                             ( MPARAM ) _parnl( 4 ) ) );
}

//----------------------------------------------------------------------------//

MRESULT EXPENTRY WndProc( HWND hWnd, USHORT wMsg, MPARAM mp1, MPARAM mp2 )
{
   CLIPVAR pResult;

   static LPCLIPSYMBOL __WndProc = 0;

   if( __WndProc == 0 )
      __WndProc = _Get_Sym( "__WNDPROC" );

   _PutSym( __WndProc );
   ( ++_tos )->wType = NIL;

   _PutLN( ( LONG ) hWnd );
   _PutQ( wMsg );
   _PutLN( ( LONG ) mp1 );
   _PutLN( ( LONG ) mp2 );
   _xDo( 4 );

   _cAt( _eval, 1, 0xFFFF, ( PCLIPVAR ) &pResult );

   if( pResult.wType == NIL )
      return ( ( PFNWP ) _parnl( -1, 2 ) )( hWnd, wMsg, mp1, mp2 );
   else
      return ( MRESULT ) _parnl( -1, 1 );
}

//----------------------------------------------------------------------------//

CLIPPER GETWNDPROC()
{
   _retnl( ( LONG ) WndProc );
}

//----------------------------------------------------------------------------//

CLIPPER WININVALID() // ATERECT()   hWnd, aRect, lChildren
{
   RECTL rct;

   if( ISARRAY( 2 ) )
   {
      rct.yTop    = _parnl( 2, 1 );
      rct.xLeft   = _parnl( 2, 2 );
      rct.yBottom = _parnl( 2, 3 );
      rct.xRight  = _parnl( 2, 4 );
   }

   _retl( WinInvalidateRect( ( HWND ) _parnl( 1 ), IF( ISARRAY( 2 ), &rct, 0 ),
                             _parl( 3 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINQRYACT() // TIVEWINDOW()
{
   HWND hWndParent = ( HWND ) _parnl( 1 );

   _retnl( ( LONG ) WinQueryActiveWindow(
           IF( hWndParent != 0, hWndParent, HWND_DESKTOP ), 0 ) );
}

//----------------------------------------------------------------------------//

CLIPPER GETACTIVEW() // INDOW( [ hWndParent ] ) --> hWnd
{
   HWND hWndParent = ( HWND ) _parnl( 1 );

   _retnl( ( LONG ) WinQueryActiveWindow(
           IF( hWndParent != 0, hWndParent, HWND_DESKTOP ), 0 ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINSETWIND() // OWTEXT()
{
   _retl( WinSetWindowText( ( HWND ) _parnl( 1 ), _parc( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINSUBCLAS() // SWINDOW()
{
   _retnl( ( LONG ) WinSubclassWindow( ( HWND ) _parnl( 1 ),
                                       ( PFNWP ) _parnl( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINSETPARE() // NT()
{
   _retl( WinSetParent( ( HWND ) _parnl( 1 ), ( HWND ) _parnl( 2 ),
                        _parl( 3 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINSETOWNE() // R()
{
   _retl( WinSetOwner( ( HWND ) _parnl( 1 ), ( HWND ) _parnl( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINPOSTMSG()
{
   _retl( WinPostMsg( ( HWND ) _parnl( 1 ), _parni( 2 ), ( MPARAM ) _parnl( 3 ),
                      ( MPARAM ) _parnl( 4 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINCREATEW() // INDOW()
{
   static LONG lId = 1024;

   _retnl( ( LONG ) WinCreateWindow( ( HWND ) _parnl( 1 ),  // hWndParent
                IF( ISNUM( 2 ), _parnl( 2 ), _parc( 2 ) ),  // szClassName
                                     _parc( 3 ),            // szCaption
                                     _parnl( 4 ),           // nStyle
                                     _parnl( 5 ),           // nLeft
                                     _parnl( 6 ),           // nTop
                                     _parnl( 7 ),           // nWidth
                                     _parnl( 8 ),           // nHeight
                                     ( HWND ) _parnl( 9 ),  // hWndOwner
                  IF( _parnl( 10 ), _parnl( 10 ), HWND_TOP ),  // hWndBehind
                  IF( _parnl( 11 ), _parnl( 11 ), lId++ ),        // nId
                                     ( PVOID ) _parnl( 12 ),      // pCtlData
                                     ( PVOID ) _parnl( 13 ) ) );  // pPresParams
}

//----------------------------------------------------------------------------//

CLIPPER WINUPDATEW() // INDOW()
{
   _retl( WinUpdateWindow( ( HWND ) _parnl( 1 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINBEGINPA() // INT()   hWnd
{
	RECTL rct;
   _retnl( ( LONG ) WinBeginPaint( ( HWND ) _parnl( 1 ),
                                   ( HPS ) _parnl( 2 ),
                                   &rct ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINENDPAIN() // T()
{
   _retl( WinEndPaint( ( HPS ) _parnl( 1 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINQRYSYSC() // OLOR()  hWnd, lType   --> lColor
{
   _retnl( WinQuerySysColor( ( HWND ) _parnl( 1 ), _parnl( 2 ), 0 ) );
}

//--------------------------------------------------------------------------//

CLIPPER WINDRAWBIT()  {  // MAP
	RECTL rct,rctbmp;
	PRECTL prct;
	POINTL ptl;


   if( ! ISARRAY( 3 ) )
		prct=NULL;
   else
   {
      	rct.yTop    = _parnl( 3, 1 );
      	rct.xLeft   = _parnl( 3, 2 );
      	rct.yBottom = _parnl( 3, 3 );
      	rct.xRight  = _parnl( 3, 4 );
      	prct=&rct;
   }
   
   if (_parinfa(4,0) == 2){
   		ptl.x = _parnl( 4, 1 );
   		ptl.y = _parnl( 4, 2 );
		_retl(WinDrawBitmap(     ( HPS ) _parnl( 1 )          	/* Handle of presentation space in which the bit map is drawn */
 				     	, ( HBITMAP ) _parnl( 2 )		   	/* Bit-map handle */                                            
 						,  prct	   						/* Subrectangle of bit map to be drawn */                       
 						,  ( PPOINTL ) &ptl   	   	/* Bit-map destination */                                       
 						, ( LONG ) _parnl( 5 )		   	/* Foreground color */                                          
 						, ( LONG ) _parnl( 6 )		   	/* Background color */                                          
 						, ( ULONG ) ( PCOUNT() > 6 ? _parnl( 7 ) : DBM_IMAGEATTRS )));			   	/* Flags that determine how the bit map is drawn */             
   }else{
      	rctbmp.yTop    = _parni( 4, 1 );
      	rctbmp.xLeft   = _parni( 4, 2 );
      	rctbmp.yBottom = _parni( 4, 3 );
      	rctbmp.xRight  = _parni( 4, 4 );
		_retl(WinDrawBitmap(     ( HPS ) _parnl( 1 )          	/* Handle of presentation space in which the bit map is drawn */
 				     	, ( HBITMAP ) _parnl( 2 )		   	/* Bit-map handle */                                            
 						,  prct	   						/* Subrectangle of bit map to be drawn */                       
 						, ( PPOINTL ) &rctbmp   	   	/* Bit-map destination */                                       
 						, ( LONG ) _parnl( 5 )		   	/* Foreground color */                                          
 						, ( LONG ) _parnl( 6 )		   	/* Background color */                                          
 						, ( ULONG) ( PCOUNT() > 6 ? _parnl( 7 ) :  DBM_STRETCH | DBM_IMAGEATTRS )));			   	/* Flags that determine how the bit map is drawn */             
     	
   }

}													                                            
//--------------------------------------------------------------------------//

CLIPPER WINSETPOS()
{
   _retl( WinSetWindowPos( ( HWND ) _parnl( 1 ), // Window handle
                           ( HWND ) _parnl( 2 ), // Relative window-placement order
                           _parnl( 3 ),          // Window position, x-coordinate
                           _parnl( 4 ),          // Window position, y-coordinate
                           _parnl( 5 ),          // Window size
                           _parnl( 6 ),          // Window size
                           _parnl( 7 ) ) );      // Window-positioning options
}

//--------------------------------------------------------------------------//

CLIPPER WINGETPS()
{
   _retnl( ( LONG ) WinGetPS( ( HWND ) _parnl( 1 ) ) ); /* Window handle */
}

//--------------------------------------------------------------------------//

CLIPPER WINRELPS()
{
   _retl( WinReleasePS( ( HPS ) _parnl( 1 ) ) ); /* Window handle */
}

//--------------------------------------------------------------------------//

CLIPPER NGETSWPFLA()
{
   _retnl( ( ( PSWP ) _parnl( 1 ) )->fs ); /* Window handle */
}

//--------------------------------------------------------------------------//

CLIPPER WINSETCAPT() // URE
{
   _retl( ( BOOL ) WinSetCapture( HWND_DESKTOP, ( HWND ) _parnl( 1 ) ) );
}
                                          
//--------------------------------------------------------------------------//

CLIPPER RELEASECAP() // TURE() --> lSuccess
{
   _retl( ( BOOL ) WinSetCapture( HWND_DESKTOP, ( HWND ) 0 ) );
}
                                          
//--------------------------------------------------------------------------//

CLIPPER ISOVERWND()
{
   POINTL pt;
   RECTL  rct;

   WinQueryWindowRect( ( HWND ) _parnl( 1 ), &rct );
   pt.x = _parni( 2 );
   pt.y = _parni( 3 );

   _retl( WinPtInRect( GetHab() , &rct, &pt ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINDESTROY()      // WINDOW() hWnd -------> lSuccess
{
   _retl( ( LONG ) WinDestroyWindow( ( HWND ) _parnl( 1 ) ));
}

//----------------------------------------------------------------------------//

CLIPPER WINGETTEXT()
{
   BYTE bBuffer[ 255 ];

   WinQueryWindowText( ( HWND ) _parnl( 1 ), 254, bBuffer );
   _retc( bBuffer );
}

//----------------------------------------------------------------------------//

CLIPPER WINSHOWWIN() // DOW( hWnd, lOnOff )  --> lSuccess
{
   _retl( WinShowWindow( ( HWND ) _parnl( 1 ), _parl( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINSETFOCU() // S()  ( hWndDesktop, hWnd ) --> lSuccess
{
   _retl( WinSetFocus( ( HWND ) _parnl( 1 ), ( HWND ) _parnl( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER SETFOCUS()     // to mimic Windows API SetFocus !
{
   WinSetFocus( ( HWND ) HWND_DESKTOP, ( HWND ) _parnl( 1 ) );
}

//----------------------------------------------------------------------------//

CLIPPER GETFOCUS()     // to mimic Windows API GetFocus !
{
   _retnl( ( LONG ) WinQueryFocus( ( HWND ) HWND_DESKTOP, 0 ) );
}

//----------------------------------------------------------------------------//

CLIPPER WBrwScroll()
{
   HWND hWnd   = _parnl( 1 );
   WORD wRows  = _parni( 2 );
   PFATTRS fat = ( PFATTRS ) _parnl( 8 );
   LONG lOldFont;
   HPS hPS     = WinGetPS( hWnd );
   FONTMETRICS fm;

   if( fat )
   {
      lOldFont = GpiQueryCharSet( hPS );
      GpiCreateLogFont( hPS, 0, 1L, fat );
      GpiSetCharSet( hPS , 1L );
   }

   GpiQueryFontMetrics( hPS, sizeof( FONTMETRICS ), &fm );

   WinScrollWindow( hWnd, 0, fm.lMaxBaselineExt * wRows, 0, 0, 0, 0, 0 );
                   //  SW_INVALIDATERGN );

   if( fat )
      GpiSetCharSet( hPS, lOldFont );

   WinReleasePS( hPS );
}

//----------------------------------------------------------------------------//

WORD GetWindowRow( HWND hWnd, HPS hPS, WORD wGraphRow, PFATTRS fat ) // -> wTextRow
{
   FONTMETRICS fm;
   RECTL rct;
   WORD  wRow;
   BOOL  bPSDestroy = FALSE;
   LONG  lOldFont;

   if( ! hPS )
   {
      bPSDestroy = FALSE;
      hPS = WinGetPS( hWnd );
   }

   if( fat )
   {
      lOldFont = GpiQueryCharSet( hPS );
      GpiCreateLogFont( hPS, 0, 1L, fat );
      GpiSetCharSet( hPS , 1L );
   }

   GpiQueryFontMetrics( hPS, sizeof( FONTMETRICS ), &fm );

   WinQueryWindowRect( hWnd, &rct );
   wRow = ( rct.yTop - wGraphRow ) / fm.lMaxBaselineExt;

   if( fat )
      GpiSetCharSet( hPS, lOldFont );

   if( bPSDestroy )
      WinReleasePS( hPS );

   return wRow;
}

//----------------------------------------------------------------------------//

CLIPPER nWRow() // ( hWnd, hPS, nGraphRow, hFont ) --> nTextRow
{
   _retni( GetWindowRow( ( HWND ) _parnl( 1 ),
                         ( HPS )  _parnl( 2 ),
                         _parni( 3 ),
                         ( PFATTRS ) _parnl( 4 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER SETCURSOR()
{
   _retl( WinSetPointer( HWND_DESKTOP, ( HPOINTER ) _parnl( 1 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINQRYLONG() // ( hWnd, nIndex ) --> nLValue
{
   _retnl( WinQueryWindowULong( ( HWND ) _parnl( 1 ), _parnl( 2 ) ) );
}

//----------------------------------------------------------------------------//
