#include "FiveOS2.ch"

#define SBM_SETSCROLLBAR   416  // 0x01A0
#define SBM_SETPOS         417  // 0x01A1
#define SBM_QUERYPOS       418  // 0x01A2
#define SBM_SETTHUMBSIZE   422  // 0x01A6

//----------------------------------------------------------------------------//

CLASS TScrollBar FROM TControl

   DATA   lVertical, lReDraw, lIsChild, nMin, nMax, nPgStep
   DATA   bGoUp, bGoDown, bGoTop, bGoBottom, bPageUp, bPageDown, bPos

   METHOD New( nTop, nLeft, nWidth, nHeight, lHorizontal, bGoUp, bGoDown,;
               nMin, nMax, oWnd ) CONSTRUCTOR

   METHOD ReDefine( nId, oDlg, bGoUp, bGoDown, nMin, nMax ) CONSTRUCTOR

   METHOD HandleEvent( nMsg, nLParam1, nLParam2 )

   METHOD Display() VIRTUAL

   METHOD Init( hDlg ) INLINE Super:Init( hDlg ),;
                              ::SetRange( ::nMin, ::nMax )

   METHOD GetPos() INLINE WinSendMsg( ::hWnd, SBM_QUERYPOS )

   METHOD GetRange() INLINE GetScrollRange( ::hWnd )

   METHOD SetRange( nMin, nMax ) INLINE ;
          ::nMin := nMin, ::nMax := nMax,;
          WinSendMsg( ::hWnd, SBM_SETSCROLLBAR, nMin, nMakeLong( nMin, nMax ) )

   METHOD SetPos( nPos ) INLINE WinSendMsg( ::hWnd, SBM_SETPOS, nPos )

   METHOD SetThumbSize( nVisible, nTotal ) INLINE ;
          WinSendMsg( ::hWnd, SBM_SETTHUMBSIZE, nMakeLong( nVisible, nTotal ) )

   METHOD cToChar( nClassName, nControls, nDynData ) INLINE ;
          Super:cToChar( WC_SCROLLBAR, nControls, nDynData )

   METHOD GoUp()   BLOCK { | Self, nPos | nPos := ::GetPos(),;
                                          if( nPos > ::GetRange()[ 1 ],;
                                              ::SetPos( --nPos ), ),;
                          If( ::bGoUp != nil, Eval( ::bGoUp ),) }

   METHOD GoDown() BLOCK { | Self, nPos | nPos := ::GetPos(),;
                                          if( nPos < ::nMax,;
                                              ::SetPos( ++nPos ), ),;
                          If( ::bGoDown != nil, Eval( ::bGoDown ),) }

   METHOD GoTop() INLINE  ::SetPos( ::nMin ),;
                          If( ::bGoTop != nil, Eval( ::bGoTop ),)

   METHOD GoBottom() INLINE  ::SetPos( ::nMax ),;
                             If( ::bGoBottom != nil, Eval( ::bGoBottom ),)

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, lHorizontal, bGoUp, bGoDown,;
            nMin, nMax, oWnd ) CLASS TScrollBar

   DEFAULT nWidth := 80, nHeight := 20, lHorizontal := .t.,;
           nMin := 0, nMax := 10, oWnd := GetWndDefault()

   ::nTop    = nTop
   ::nLeft   = nLeft
   ::nBottom = nTop + nHeight - 1
   ::nRight  = nLeft + nWidth - 1
   ::bGoUp   = bGoUp
   ::bGoDown = bGoDown
   ::nMin    = nMin
   ::nMax    = nMax
   ::oWnd    = If( ! Empty( oWnd:oWndClient ), oWnd:oWndClient, oWnd )
   ::nStyle  = nOr( WS_VISIBLE, WS_TABSTOP,;
                     If( lHorizontal, SBS_HORZ, SBS_VERT ) )

   if ! Empty( oWnd:hWnd )
      ::hWnd = WinCreateWindow( ::oWnd:hWnd, WC_SCROLLBAR, "", ::nStyle,;
                                nLeft, nTop, nWidth, nHeight, ::oWnd:hWnd )
      ::Link()
      oWnd:AddControl( Self )
      ::SetRange( ::nMin, ::nMax )
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, oDlg, bGoUp, bGoDown, nMin, nMax ) CLASS TScrollBar

   DEFAULT nMin := 0, nMax := 10

   ::nId     = nId
   ::oWnd    = oDlg
   ::bGoUp   = bGoUp
   ::bGoDown = bGoDown
   ::nMin    = nMin
   ::nMax    = nMax

   ::oWnd:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nLParam1, nLParam2 ) CLASS TScrollBar

   local nPos

   do case
      case nMsg == FO_SCROLLUP
           nPos = ::GetPos()
           if ::bGoUp != nil
              If( nPos > ::GetRange()[ 1 ], ::SetPos( --nPos ),)
              Eval( ::bGoUp, Self )
           endif

      case nMsg == FO_SCROLLDOWN
           nPos = ::GetPos()
           if ::bGoDown != nil
              If( nPos < ::GetRange()[ 2 ], ::SetPos( ++nPos ),)
              Eval( ::bGoDown, Self )
           endif
   endcase

return nil

//----------------------------------------------------------------------------//
