#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

//----------------------------------------------------------------------------//

CLIPPER WSay()
{
   HWND hWnd        = ( HWND )_parnl( 1 );
   HPS  hPS         = ( HPS )_parnl( 2 );
   LONG lRow        = _parnl( 3 );
   LONG lCol        = _parnl( 4 );
   PCH  szText      = _parc( 5 );
   LONG lClrFore    = _parnl( 6 );
   LONG lClrBack    = _parnl( 7 );
   PFATTRS fat       = ( PFATTRS )_parnl( 8 );
   BOOL bPixel      = _parl( 9 );
   BOOL bDestroyPS  = FALSE;
   FONTMETRICS fm;
   POINTL ptl;
   LONG lIdOld;

   if( ! hPS )
   {
      bDestroyPS = TRUE;
      hPS = WinGetPS( hWnd );
   }

   if( fat )
   {
      lIdOld = GpiQueryCharSet( hPS );
      GpiCreateLogFont( hPS, 0, 1L, fat );
      GpiSetCharSet( hPS , 1L );
   }

   GpiQueryFontMetrics( hPS, sizeof(FONTMETRICS), &fm );

   GpiSetColor( hPS, lClrFore );
   GpiSetBackColor( hPS, lClrBack );
   GpiSetBackMix( hPS, BM_OVERPAINT );

   ptl.x = bPixel ? lCol: ( fm.lAveCharWidth * lCol );
   ptl.y = bPixel ? lRow: ( fm.lEmHeight * lRow );
   GpiCharStringAt( hPS, &ptl, _parclen( 5 ), szText );

   if( fat )
      GpiSetCharSet( hPS , lIdOld );

   if( bDestroyPS )
      WinReleasePS( hPS );
}
 
//----------------------------------------------------------------------------//

CLIPPER WINDRAWTEX()
{
   HWND hWnd         = _parnl( 1 );
   HDC  hPS          = _parnl( 2 );
   LONG lCount       = _parclen( 4 );
   RECTL rct;
   PCH  pchText      = _parc ( 4 );
   LONG lClrFore     = _parnl( 5 );
   LONG lClrBack     = _parnl( 6 );
   LONG flCmd        = _parnl( 7 );
   BOOL bDestroyPS   = FALSE;

   if( ISARRAY( 3 ) )
   {
      rct.yTop    = _parni( 3, 1 );
      rct.xLeft   = _parni( 3, 2 );
      rct.yBottom = _parni( 3, 3 );
      rct.xRight  = _parni( 3, 4 );
   }
   else
      WinQueryWindowRect( hWnd, &rct );

   if( ! hPS )
   {
      bDestroyPS = TRUE;
      hPS = WinGetPS( hWnd);
   }

   GpiSetColor( hPS, lClrFore );
   GpiSetBackColor( hPS, lClrBack );

   WinDrawText( hPS, lCount, pchText, &rct, lClrFore, lClrBack, flCmd );

   if( bDestroyPS )
      WinReleasePS( hPS );
}

//----------------------------------------------------------------------------//
