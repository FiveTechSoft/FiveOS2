#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

#define BAR_TOP     1
#define BAR_LEFT    2
#define BAR_RIGHT   3
#define BAR_ADJUST  4

//----------------------------------------------------------------------------//

CLIPPER BarAdjust()
{
   HWND hWnd    = _parnl( 1 );
   BYTE bMode   = _parni( 2 );
   BOOL bMsgBar = _parl( 3 );
   HWND hParent = WinQueryWindow( hWnd , QW_PARENT , 0);
   RECTL rcWnd, rcParent;

   WinQueryWindowRect( hWnd, &rcWnd );
   WinQueryWindowRect( hParent, &rcParent );

   switch( bMode )
   {

      case BAR_ADJUST:
      default:
           WinSetWindowPos( hWnd, HWND_TOP, rcParent.xLeft, ( bMsgBar  ? rcParent.yBottom : rcParent.yTop - ( rcWnd.yTop - rcWnd.yBottom ) )
           		,rcParent.xRight - rcParent.xLeft, rcWnd.yTop - rcWnd.yBottom , SWP_MOVE | SWP_SIZE | SWP_SHOW );
           break;
   }
}

//----------------------------------------------------------------------------//
