#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

// Devuelve el ancho en unidades l¢gicas ( Gr ficas ) de una cadena.
// returns the width of a string in pixels

//----------------------------------------------------------------------------//

CLIPPER GetTextWid() // ( hPS, szText )
{
   HPS   hPS        = _parnl( 1 );
   DWORD dwSize;
   BOOL  bDestroyPS = FALSE;

   if( ! hPS )
   {
      bDestroyPS = TRUE;
      hPS = WinGetPS( WinQueryActiveWindow( HWND_DESKTOP, 0 ) );
   }

   dwSize = WinDrawText( hPS, -1, _parc( 2 ), 0, 0, 0, 0 );

   if( bDestroyPS )
       WinReleasePS( hPS );

   _retni( dwSize );
}

//----------------------------------------------------------------------------//

CLIPPER GETTEXTHEI()  // GHT( hWnd )
{
   FONTMETRICS fm;
   HWND  hWnd = _parnl( 1 );
   HPS   hPS  = WinGetPS( WinQueryActiveWindow( HWND_DESKTOP, 0 ) );

   GpiQueryFontMetrics( hPS, sizeof( FONTMETRICS ), &fm );
   WinReleasePS( hPS );

   _retni( fm.lMaxBaselineExt );
}

//----------------------------------------------------------------------------//
