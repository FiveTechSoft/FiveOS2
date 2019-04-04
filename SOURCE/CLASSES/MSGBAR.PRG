#include "FiveOS2.ch"

#define MSGBAR_HEIGHT 28

#define BAR_TOP     1
#define BAR_LEFT    2
#define BAR_RIGHT   3
#define BAR_ADJUST  4

static lRegistered := .f.

//----------------------------------------------------------------------------//

CLASS TMsgBar FROM TControl

   DATA   cMsgDef

   METHOD New( oWnd, cMsgDef ) CONSTRUCTOR
   
   METHOD ReDefine( nId, oDlg ) CONSTRUCTOR
   
   METHOD Adjust() INLINE  BarAdjust( ::hWnd,BAR_ADJUST, .t. )
   
   METHOD Paint( nMsg, nLParam1, nLParam2 )
   
   METHOD SetMsg( cText )
   
   METHOD MouseMove() INLINE WinSetPointer( HWND_DESKTOP, ::oCursor:hCursor ),;
                             Super:MouseMove()
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, cMsgDef ) CLASS TMsgBar

   local aPos

   ::nTop         = 0
   ::nLeft        = 0
   ::nBottom      = MSGBAR_HEIGHT
   ::nRight       = 500
   ::cMsgDef      = cMsgDef
   ::oWnd         = If( oWnd:oWndClient != nil, oWnd:oWndClient, oWnd )
   ::oWnd:oMsgBar = Self
   ::nStyle       = nOr( WS_VISIBLE, WS_TABSTOP )
   ::nClrPane     = SYSCLR_BUTTONMIDDLE
   ::nClrText     = CLR_BLACK
   ::oCursor      = TCursor():New()

   if ! lRegistered
      WinRegisterClass( ::ClassName(), nOR( CS_SYNCPAINT, CS_SIZEREDRAW ) )
      lRegistered = .t.
   endif

   if ! Empty( ::oWnd:hWnd )
      aPos := WinQryRct( ::oWnd:hWnd )
      ::hWnd = WinCreateWindow( ::oWnd:hWnd;
      						,::ClassName(), "", ::nStyle;
      						,aPos[2];
    	              ,aPos[3];
      						,aPos[4]-aPos[2];
	                  ,MSGBAR_HEIGHT;
                  ,::oWnd:hWnd )
      ::Link()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, oDlg ) CLASS TMsgBar

   ::nId  = nId
   ::oWnd = oDlg
   ::oWnd:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD Paint( nMsg, nLParam1, nLParam2 ) CLASS TMsgBar

	local aPos

	aPos:= WinQryRct(::hWnd)
	aPos[1] -= 3
	aPos[2] += 3
	aPos[3] += 3
	aPos[4] -= 3
   WinFillRect(::hPS, ,::nClrPane, ::hWnd )
   WinDrawText(::hWnd,::hPs, ,if(Empty(::cMsg),::cMsgDef,::cMsg),::nClrText,::nClrPane,nOr(DT_CENTER,DT_VCENTER))
   Draw3dBox(::hPS,,::hWnd,.f.)
   Draw3dBox(::hPS,aPos,::hWnd,.t.)
   
return 0   

//----------------------------------------------------------------------------//
           
METHOD SetMsg( cText ) CLASS TMsgBar

   if cText != ::cMsg
      ::cMsg := cText
      ::GetPS()
      ::Paint()
      ::ReleasePS()
   endif

return nil

//----------------------------------------------------------------------------//
