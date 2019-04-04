#include "FiveOS2.ch"

#define CMDSRC_PUSHBUTTON   1
#define CMDSRC_MENU         2
#define CMDSRC_ACCELERATOR  3

#define WM_UPDATEFRAME     66  // 0x42
#define FCF_MENU            4

#define WM_MENUSELECT      52  // 0x34

#define SYSCLR_BACKGROUND -24

#define LN_SELECT           1

#define SC_MAXIMIZE     32771  // 0x8003

static lRegistered := .f.

static aWnds := {}

static oWndDefault

//----------------------------------------------------------------------------//

CLASS TWindow

   DATA   hWnd
   DATA   aControls
   DATA   bInit, bMoved, bLClicked, bKeyDown, bPainted, bRClicked
   DATA   bResized, bLDblClick, bWhen, bValid, bKeyChar, bMMoved
   DATA   bGotFocus, bLostFocus, bDropFiles, bDdeInit, bDdeExecute
   DATA   oWnd, oMenu, oIcon, oPopup, oCursor, oWndClient, oVScroll, oHScroll
   DATA   nOldProc, nStyle, nHelpId
   DATA   nTop, nLeft, nBottom, nRight
   DATA   cCaption
   DATA   oMsgBar, oBar, oBrush
   DATA   bResized, bGotFocus, bLostFocus
   DATA   hPS, nPaintCount
   DATA   nClrText, nClrPane
   DATA   oFont, cMsg
   DATA   lFocused, lValidating

   METHOD New( nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu ,oWnd,;
               oIco ) CONSTRUCTOR

   METHOD Activate( cShow, bValid )

   METHOD AddControl( oCtrl ) INLINE ;
                        If( Empty( ::aControls ), ::aControls := {},),;
                        AAdd( ::aControls, oCtrl )

   METHOD Command( nCmd, nType )

   METHOD Create( cClsName )

   METHOD LDblClick( nRow, nCol, nFlags ) INLINE If( ::bLDblClick != nil,;
                                 Eval( ::bLDblClick, nRow, nCol, nFlags ),)

   METHOD LButtonDown( nRow, nCol, nFlags ) INLINE If( ::bLClicked != nil,;
                                 Eval( ::bLClicked, nRow, nCol, nFlags ),)
      
   METHOD LButtonUp( nRow, nCol, nFlags ) VIRTUAL

   METHOD Maximize() INLINE ::PostMsg( WM_SYSCOMMAND, SC_MAXIMIZE )

   METHOD Display() VIRTUAL

   METHOD End() BLOCK ;
      { | Self, lEnd | If( lEnd := ::lValid(), ::PostMsg( WM_CLOSE ),),lEnd }

   METHOD GetRect()

   METHOD HandleEvent( nMsg, nLParam1, nLParam2 )

   METHOD Hide() INLINE WinShowWindow( ::hWnd, .f. )

   METHOD HScroll( nLParam1, nLParam2 )

   METHOD Link()

   METHOD Paint() VIRTUAL       //  Default painting

   METHOD PostMsg( nMsg, nLParam1, nLParam2 ) INLINE ;
                   WinPostMsg( ::hWnd, nMsg, nLParam1, nLParam2 )

   METHOD RButtonDown( nRow, nCol, nFlags ) INLINE If( ::bRClicked != nil,;
                                 Eval( ::bRClicked, nRow, nCol, nFlags ),)

   METHOD Refresh( lChildren ) INLINE WinInvalidateRect( ::hWnd, 0,;
                               If( lChildren != nil, lChildren, .t. ) )

   METHOD Register( nClsStyle )

   METHOD Say( nRow, nCol, cText, nClrFore, nClrBack, oFont, lPixel )

   METHOD SendMsg( nMsg, nLParam1, nLParam2 ) INLINE ;
                       WinSendMsg( ::hWnd, nMsg, nLParam1, nLParam2 )

   METHOD SetColor( nClrFore, nClrBack, oBrush )

   METHOD SetFont() VIRTUAL

   METHOD Show() INLINE WinShowWindow( ::hWnd, .t. )

   METHOD Timer( nTimerId ) INLINE TimerEvent( nTimerId )

   METHOD UnLink() INLINE ;
                   WinSubclassWindow( ::hWnd, ::nOldProc ), ::nOldProc := 0

   METHOD VScroll( nLParam1, nLParam2 )

   METHOD SetFocus() INLINE WinSetFocus( HWND_DESKTOP, ::hWnd )

   METHOD SetMenu( oMenu )

   METHOD SetText( cText ) INLINE ;
                           WinSetWindowText( ::hWnd, cValToChar( cText ) )

   METHOD GetText() INLINE WinGetText( ::hWnd )

   METHOD lValid() INLINE If( ::bValid != nil, Eval( ::bValid ), .t. )
   
   METHOD ReSize( nSizeType, nWidth, nHeight )
   
   METHOD BeginPaint() BLOCK ;      // it has to be BLOCK
          { | Self | ::nPaintCount := 1,;
                          ::hPS := WinBeginPaint( ::hWnd, 0 ) }

   METHOD EndPaint() INLINE ::nPaintCount--,;
                     WinEndPaint( ::hPS ), ::hPS := nil
                          
   
   METHOD Capture( lCapture ) INLINE  ;
         If( lCapture == nil, lCapture := .t., ) ,;
         If( lCapture, WinSetCapture( ::hWnd ), WinSetCapture( 0 ) )
   
   METHOD GetPS() INLINE ;
       If( ::hPS == nil, ::hPS := WinGetPS( ::hWnd ),),;
       If( ::nPaintCount == nil, ::nPaintCount := 1, ::nPaintCount++ ), ::hPS
   
   METHOD ReleasePS() INLINE  If( --::nPaintCount == 0,;
                              If( WinRelPS( ::hPS ), ::hPS := nil,),)

   METHOD GetDC() INLINE ::GetPS()             // Windows API compatibility
   METHOD ReleaseDC() INLINE ::ReleasePS()     //    "     "         "

   METHOD SetMsg( cText )
   
   /*
   METHOD MouseMove( nRow, nCol, nKeyFlags ) INLINE ;
                    If( ::oCursor != nil, SetCursor( ::oCursor:hCursor ),;
                        CursorArrow() ),;
                    ::SetMsg( ::cMsg ),;
                    If( ::bMMoved != nil,;
                        Eval( ::bMMoved, nRow, nCol, nKeyFlags ),), 0
   */
   METHOD MouseMove( nRow, nCol, nFlags ) INLINE ;
                    If( ::oCursor != nil, SetCursor( ::oCursor:hCursor ),;
                        CursorArrow() ),;
                    ::SetMsg( ::cMsg )
   
   METHOD Close() 
   
   METHOD KeyChar( nFlags, nRepeat, nScanCode, nChar, nVK ) ;
                 INLINE If( ::bKeyChar != nil, Eval( ::bKeyChar, nVK ),)
   
   METHOD LostFocus() INLINE ::lFocused := .f.,;
                             If( ::bLostFocus != nil, Eval( ::bLostFocus ),)

   METHOD GotFocus() INLINE ::lFocused := .t.,;
                            If( ::bGotFocus != nil, Eval( ::bGotFocus ),)
   
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu, oWnd,;
            oIco ) CLASS TWindow

   local hWndClient
   
   DEFAULT cTitle := "FiveOS2", nStyle := WS_VISIBLE

   ::nClrText    = CLR_BLACK
   ::nClrPane    = SYSCLR_BACKGROUND
   ::oWndClient  = TWndClient():New( Self )
   ::nStyle      = nStyle
   ::cCaption    = cTitle
   ::lValidating = .f.
   ::oIcon       = oIco
   
   if oWnd != nil
      ::oWnd = If( oWnd:oWndClient != nil, oWnd:oWndClient, oWnd )
   endif

   if ! lRegistered
      ::Register()
      lRegistered = .t.
   endif

   ::hWnd = WinCreateStdWindow( If( ::oWnd != nil , ::oWnd:hWnd ,HWND_DESKTOP),;
                                ::nStyle,;
                                nOr( FCF_TITLEBAR, FCF_SYSMENU,;
                                FCF_SIZEBORDER, FCF_TASKLIST,;
                                FCF_MINMAX, FCF_SHELLPOSITION ),;
                                ::oWndClient:ClassName(), cTitle,,,,;
                                @hWndClient )

   ::oWndClient:hWnd        = hWndClient
   ::oWndClient:lValidating = .f.
   
   if oMenu != nil
      ::SetMenu( oMenu )
   endif

   ::Link()
   ::oWndClient:Link()

   if oIco != nil
      MsgInfo( oIco:hIcon )
      WinSetPointer( ::hWnd, oIco:hIcon )
   endif

   oWndDefault = Self
   
return nil

//----------------------------------------------------------------------------//

METHOD Activate( cShow, bValid ) CLASS TWindow

   ::bValid = bValid

   if cShow != nil
      do case
         case cShow == "MAXIMIZED"
              ::Maximize()

         case cShow == "MINIMIZED"
      endcase
   endif

   WinRun()

return nil

//----------------------------------------------------------------------------//

METHOD Command( nCmd, nType ) CLASS TWindow

   do case
      case nType == CMDSRC_PUSHBUTTON
           WinPostMsg( WinWindowFromID( ::hWnd, nCmd ), FO_CLICK, 0, 0 )

      case nType == CMDSRC_MENU
           if ::oMenu != nil
              ::oMenu:Command( nCmd )
           endif

      case nType == CMDSRC_ACCELERATOR
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nLParam1, nLParam2 ) CLASS TWindow

   local oItem

   do case
      case nMsg == WM_CHAR
           return ::KeyChar( nLoWord( nLParam1 ),;             // fsflags
                             nHiByte( nHiWord( nLParam1 ) ),;  // ucrepeat
                             nLoByte( nHiWord( nLParam1 ) ),;  // ucscancode
                             nLoWord( nLParam2 ),;             // usch
                             nHiWord( nLParam2 ) ;             // usvk
                           )
                    
      case nMsg == WM_SIZE
           ::ReSize()

      case nMsg == WM_SYSCOMMAND
           if nLParam1 == SC_CLOSE
              ::End()
              return 0
           endif

      case nMsg == WM_CLOSE
           return ::Close()
     
//      case nMsg == WM_DESTROY
//           ::Release()
           
//      case nMsg == WM_QUERYENDSESSION
//            return If( ::End(), 1, 0 )
     
      case nMsg == WM_COMMAND
           ::Command( nLoWord( nLParam1 ), nLoWord( nLParam2 ) )

      case nMsg == WM_CONTROL
           if nHiWord( nLParam1 ) == BN_CLICKED .or. ;
              nHiWord( nLParam1 ) == LN_SELECT
              WinSendMsg( WinWindowFromID( ::hWnd, nLoWord( nLParam1 ) ),;
                          FO_CLICK, 0, 0 )
           endif

      case nMsg == WM_VSCROLL
           return ::VScroll( nLParam1, nLParam2 )

      case nMsg == WM_HSCROLL
           return ::HScroll( nLParam1, nLParam2 )

      case nMsg == WM_MOUSEMOVE
           return ::MouseMove(nHiWord(nLParam1),nLoWord(nLParam1),nLoWord(nLParam2))

      case nMsg == WM_MENUSELECT .and. ( ::oMenu != nil .or. ::oPopup != nil )
           if ::oPopup != nil
              oItem = ::oPopup:GetMenuItem( nLoWord( nLParam1 ) )
           else
              oItem = ::oMenu:GetMenuItem( nLoWord( nLParam1 ) )
           endif
           ::SetMsg( If( oItem != nil, oItem:cMsg,) )

      case nMsg == WM_SETFOCUS
           if nLParam2 == 1
              ::GotFocus()
           else
              ::LostFocus()
           endif

      case nMsg == WM_PAINT
           return ::Display()

      case nMsg == WM_BUTTON1DOWN
           return ::LButtonDown( nHiWord( nLParam1 ),;
                                 nLoWord( nLParam1 ), nLoWord( nLParam2 ) )
           
      case nMsg == WM_BUTTON1UP
           return ::LButtonUp( nHiWord( nLParam1 ),;
                               nLoWord( nLParam1 ), nLoWord( nLParam2 ) )

      case nMsg == WM_BUTTON1DBLCLK
           return ::LDblClick( nHiWord( nLParam1 ),;
                               nLoWord( nLParam1 ), nLoWord( nLParam2 ) )

      case nMsg == WM_BUTTON2DOWN
           return ::RButtonDown( nHiWord( nLParam1 ),;
                                 nLoWord( nLParam1 ), nLoWord( nLParam2 ) )
           
      case nMsg == WM_TIMER
           return ::Timer( nLParam1 )

   endcase

return nil

//----------------------------------------------------------------------------//

METHOD HScroll( nLParam1, nLParam2 ) CLASS TWindow

   local hScrollBar := WinWindowFromID( ::hWnd, nLoWord( nLParam1 ) )
   local nCommand   := nHiWord( nLParam2 )

   // OS2 does not provides the thumb position ии??
   // we get it calling TScrollBar::GetPos()

   do case
      case nCommand == SB_LINELEFT
           WinSendMsg( hScrollBar, FO_SCROLLUP )

      case nCommand == SB_LINERIGHT
           WinSendMsg( hScrollBar, FO_SCROLLDOWN )
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD VScroll( nLParam1, nLParam2 ) CLASS TWindow

   local hScrollBar := WinWindowFromID( ::hWnd, nLoWord( nLParam1 ) )
   local nCommand   := nHiWord( nLParam2 )

   // OS2 does not provides the thumb position ии??
   // we get it calling TScrollBar::GetPos()

   do case
      case nCommand == SB_LINEUP
           WinSendMsg( hScrollBar, FO_SCROLLUP )

      case nCommand == SB_LINEDOWN
           WinSendMsg( hScrollBar, FO_SCROLLDOWN )
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD Link() CLASS TWindow

   local nAt := AScan( aWnds, 0 )

   if nAt == 0
      AAdd( aWnds, Self )
      WndListSet( ::hWnd, nAt := Len( aWnds ) )
   else
      aWnds[ nAt ] = Self
      WndListSet( ::hWnd, nAt )
   endif

   ::nOldProc = WinSubclassWindow( ::hWnd, GetWndProc() )

return nil

//----------------------------------------------------------------------------//

METHOD SetMenu( oMenu ) CLASS TWindow

   ::oMenu = oMenu

   WinSetParent( oMenu:hWnd, ::hWnd, .t. )
   WinSetOwner( oMenu:hWnd, ::hWnd )
   WinSendMsg( ::hWnd, WM_UPDATEFRAME, FCF_MENU, 0 )

return nil

//----------------------------------------------------------------------------//

METHOD ReSize( nSizeType, nWidth, nHeight ) CLASS TWindow

   if ::oMsgBar != nil
      ::oMsgBar:Adjust()
   endif

   if ::oBar != nil
	  ::oBar:Adjust()
   endif
   
   if ::bResized != nil
      Eval( ::bResized, nWidth, nHeight )
   endif

return Nil

//----------------------------------------------------------------------------//

METHOD Say( nX, nY, cText, nClrFore, nClrBack, oFont, lPixel ) CLASS TWindow

   DEFAULT nClrFore := ::nClrText,;
           nClrBack := ::nClrPane,;
           oFont    := ::oFont,;
           lPixel   := .f.

   if ValType( nClrFore ) == "C"      //  xBase Color string
      nClrBack = nClrFore
      nClrFore = nGetForeRGB( nClrFore )
      nClrBack = nGetBackRGB( nClrBack )
   endif
   ::GetPS()
   WSay( ::hWnd, ::hPS, nX, nY, cValToChar( cText ), nClrFore, nClrBack,;
         If( oFont != nil, oFont:hFont, 0 ), lPixel )
   ::ReleasePS()

return nil

//----------------------------------------------------------------------------//

METHOD SetMsg( cText ) CLASS TWindow

   if ::oWnd != nil
      ::oWnd:SetMsg( cText )
   else
      if ::oWndClient != nil
         ::oWndClient:SetMsg( cText )
      else
        if ::oMsgBar != nil
           ::oMsgBar:SetMsg( cText )
        endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

function __WndProc( hWnd, nMsg, nLParam1, nLParam2 )

   local oWnd := aWnds[ WndListGet( hWnd ) ]

return { oWnd:HandleEvent( nMsg, nLParam1, nLParam2 ), oWnd:nOldProc }

//----------------------------------------------------------------------------//

function GetWndDefault() ; return oWndDefault
function SetWndDefault( oWnd ) ; oWndDefault := oWnd; return nil

//----------------------------------------------------------------------------//

METHOD Close() CLASS TWindow
  
    if ::hWnd != aWnds[ 1 ]:hWnd
       WinDestroyWindow( ::hWnd )
       return HE_DONE
    endif     
    
return HE_DEFAULT

//----------------------------------------------------------------------------//

METHOD SetColor( nClrFore, nClrBack, oBrush ) CLASS TWindow

   // DEFAULT colors get assigned at :Colors() method
   // because there we _do_ have a hDC already created

   if ValType( nClrFore ) == "C"
      nClrBack = nClrFore                   // It is a dBase Color string
      nClrFore = nGetForeRGB( nClrFore )
      nClrBack = nGetBackRGB( nClrBack )
   endif

   ::nClrText = nClrFore
   ::nClrPane = nClrBack

   if ::oBrush != nil
      ::oBrush:Release()
   endif
   if oBrush != nil
      ::oBrush = oBrush
   else
      ::oBrush = TBrush():New(,nClrBack,)
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetRect() CLASS TWindow

   local aRect := WinQryRct( ::hWnd )

return TRect():New( aRect[ 1 ], aRect[ 2 ], aRect[ 3 ], aRect[ 4 ] )

//----------------------------------------------------------------------------//

METHOD Create( cClsName )  CLASS TWindow

   DEFAULT cClsName := ::ClassName(), ::cCaption := "",;
           ::nTop   := 0, ::nLeft := 0, ::nBottom := 10, ::nRight := 10,;
           ::nId    := 0

           // ::nStyle := WS_OVERLAPPEDWINDOW,;
   /*
   if ::oWnd != nil
      ::nStyle = nOR( ::nStyle, WS_CHILD )
   endif
   */

   if ::nBottom != nil // CW_USEDEFAULT
      ::hWnd = CreateWindow( cClsName, ::cCaption, ::nStyle, ;
                             ::nLeft, ::nTop, ::nRight - ::nLeft + 1, ;
                             ::nBottom - ::nTop + 1, ;
                             If( ::oWnd != nil, ::oWnd:hWnd, 0 ), ;
                             ::nId )
    else
      ::hWnd = CreateWindow( cClsName, ::cCaption, ::nStyle, ;
                             ::nLeft, ::nTop, ::nRight, ::nBottom, ;
                             If( ::oWnd != nil, ::oWnd:hWnd, 0 ), ;
                             ::nId )
    endif

   ::Link()

   if ::oFont != nil
      ::SetFont( ::oFont )
   endif
   
return nil

//----------------------------------------------------------------------------//

METHOD Register( nClsStyle ) CLASS TWindow

   DEFAULT nClsStyle := 0

   WinRegisterClass( ::oWndClient:ClassName(),;
                     nOr( CS_SIZEREDRAW , nClsStyle ), 0 )

return nil

//----------------------------------------------------------------------------//
