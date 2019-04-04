#include "FiveOS2.ch"

//----------------------------------------------------------------------------//

CLASS TDialog FROM TWindow

   DATA   nLastKey, nResource
   DATA   lCentered
   DATA   bValid

   METHOD ReDefine( nResource, nTop, nLeft, nBottom, nRight, cCaption,;
                    oWnd ) CONSTRUCTOR

   METHOD Activate( bValid, lCentered )

   METHOD HandleEvent( nMsg, nLParam1, nLParam2 )

   METHOD Center() INLINE CenterDialog( ::hWnd )

   METHOD Command( nLParam1, nLParam2 )
   
   METHOD cToChar( hActiveWnd )

   METHOD End( nResult ) BLOCK ;
      { | Self, nResult , lEnd | If( lEnd := ::lValid(), WinDismissDlg( ::hWnd, nResult ),),lEnd }

   METHOD Init( hDlg )

   METHOD DefControl( oControl )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD ReDefine( nResource, nTop, nLeft, nBottom, nRight, cCaption,;
                 oWnd ) CLASS TDialog

   DEFAULT oWnd := GetWndDefault()

   if oWnd == nil
      SetWndDefault( Self )
   endif

   ::nResource   = nResource
   ::aControls   = {}
   ::lCentered   = .f.
   ::oWnd        = oWnd
   ::nTop        = nTop
   ::nLeft       = nLeft
   ::nBottom     = nBottom
   ::nRight      = nRight
   ::cCaption    = cCaption
   ::lValidating = .f.

return nil

//----------------------------------------------------------------------------//

METHOD Activate( bValid, lCentered ) CLASS TDialog

   local hWndDlg

   ::lCentered = lCentered

   if ! Empty( ::nResource )
      WinDlgBox( HWND_DESKTOP ,;
                 If( ::oWnd != nil, ::oWnd:hWnd, HWND_DESKTOP ),;
                 ::nResource, Self )
   else
      WinDlgBoxI( HWND_DESKTOP ,;
                  If( ::oWnd != nil, ::oWnd:hWnd, HWND_DESKTOP ),;
                  ::cToChar(), Self )
   endif
   ::bValid := bValid

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nLParam1, nLParam2 ) CLASS TDialog

   do case
      case nMsg == WM_CHAR
           return .f.

      case nMsg == WM_INITDLG
           ::Init( nLParam1 )
           if ::lCentered
              ::Center()
           endif

      case nMsg == WM_HSCROLL
           return ::HScroll( nLParam1, nLParam2 )

      case nMsg == WM_VSCROLL
           return ::VScroll( nLParam1, nLParam2 )

      case nMsg == WM_PAINT      // total standard behavior
           return .f.

      case nMsg == WM_TIMER
           return ::Timer( nLParam1 )

   endcase

return Super:HandleEvent( nMsg, nLParam1, nLParam2 )

//----------------------------------------------------------------------------//

METHOD Command( nLParam1, nLParam2 ) CLASS TDialog

   WinSendMsg( WinWindowFromID( ::hWnd, nLoWord( nLParam1 ) ), FO_CLICK, 0, 0 )

return .t.

//----------------------------------------------------------------------------//

METHOD DefControl( oControl ) CLASS TDialog

   if Empty( ::aControls )
      ::aControls = {}
   endif

   AAdd( ::aControls, oControl )

return Nil

//----------------------------------------------------------------------------//

METHOD Init( hDlg ) CLASS TDialog

   ::hWnd = hDlg

   AEval( ::aControls, { | oCtrl | oCtrl:Init( hDlg ) } )

return .f.

//----------------------------------------------------------------------------//

METHOD cToChar( hActiveWnd ) CLASS TDialog

   local cResult
   local aControls := ::aControls, aCtl
   local nOff := 0, cFixData := "", n, cDynData := ""

   DEFAULT ::cCaption := ""

   aCtl = cDlg2Chr( Len( aControls ),;
                       ::nTop,;
                       ::nLeft,;
                       ::nBottom,;
                       ::nRight,;
                       ::cCaption, ::nStyle )
   cDynData += aCtl[ 2 ]
   cFixData += aCtl[ 1 ]

   for n = 1 to Len( aControls )
      aCtl:=aControls[ n ]:cToChar( , Len( aControls ), Len( cDynData ) )
      cDynData += aCtl[2]
  	  cFixData += aCtl[1]
   next

   cFixData = i2bin( Len( cDynData ) + Len( cFixData ) ) + SubStr( cFixData, 3 )
   // MemoWrit( "ctochar.tst", cFixData + cDynData )

return cFixData + cDynData

//----------------------------------------------------------------------------//
