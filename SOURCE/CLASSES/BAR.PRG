#include "FiveOS2.ch"

static lRegistered := .f.

//----------------------------------------------------------------------------//

CLASS TBar FROM TControl

   DATA  nGroups
   DATA  nBtnWidth
   DATA  nBtnHeight
   DATA  nMode

   METHOD New( oWnd ) CONSTRUCTOR
   
   METHOD ReDefine( nId, oDlg ) CONSTRUCTOR
   
   METHOD Adjust() INLINE  BarAdjust( ::hWnd, ::nMode , .f. )
   
   METHOD Paint()

   METHOD MouseMove() INLINE WinSetPointer( HWND_DESKTOP, ::oCursor:hCursor ),;
                             Super:MouseMove()
                             
   METHOD GetBtnLeft( lNewGroup )
   

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd ) CLASS TBar

   local aPos

   ::aControls = {}
   ::oWnd      = If( oWnd <> NIL .and. oWnd:oWndClient != nil, oWnd:oWndClient, oWnd )
   ::oWnd:oBar = Self
   ::nStyle    = nOr( WS_VISIBLE, WS_TABSTOP )
   ::nClrPane  = SYSCLR_BUTTONMIDDLE
   ::nClrText  = CLR_BLACK
   ::nMode     = BAR_TOP
   ::oCursor   = TCursor():New()
   ::nBtnWidth = BTN_WIDTH
   ::nBtnHeight= BTN_HEIGHT
   ::nGroups   = 0
   
   if ! lRegistered
      WinRegisterClass( ::ClassName(), nOR( CS_SYNCPAINT, CS_SIZEREDRAW ) )
      lRegistered = .t.
   endif

   if ! Empty( ::oWnd:hWnd )
      aPos := WinQryRct( ::oWnd:hWnd )
      ::nTop      = aPos[1]
      ::nLeft     = aPos[2]
      ::nBottom   = aPos[1]-BAR_HEIGHT
      ::nRight    = aPos[4]
      ::hWnd = WinCreateWindow( ::oWnd:hWnd;
      						,::ClassName(), "", ::nStyle;
      						,::nLeft;
                        ,::nBottom;
      						,::nRight-::nLeft;
                        ,BAR_HEIGHT;
                        ,::oWnd:hWnd )
      ::Link()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, oDlg ) CLASS TBar

   ::nId  = nId
   ::oWnd = oDlg
   ::oWnd:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TBar

   WinFillRect( ::hPS, 0, ::nClrPane, ::hWnd )
   Draw3dBox( ::hPS, 0, ::hWnd )
    
return 0   

//----------------------------------------------------------------------------//

METHOD GetBtnLeft( lNewGroup ) CLASS TBar

   local nPos := 0

   do case
      case ::nMode == BAR_TOP
           nPos = ( Len( ::aControls ) * ::nBtnWidth ) - 1 + ;
                  If( lNewGroup, ++::nGroups, ::nGroups ) * 15 + 2

   end case

return nPos

//----------------------------------------------------------------------------//
