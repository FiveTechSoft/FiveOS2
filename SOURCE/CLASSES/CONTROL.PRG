#include "FiveOS2.ch"

static nId := 100

//----------------------------------------------------------------------------//

CLASS TControl FROM TWindow

   DATA   nId
   DATA   bSetGet, bChange
   DATA   lCaptured, lDrag, lUpdate

   METHOD Init( hDlg )

   METHOD Click() VIRTUAL

   METHOD Release() INLINE ::UnLink(), ::hWnd := 0

   METHOD HandleEvent( nMsg, nLParam1, nLParam2 )
   
   METHOD cToChar( cCtrlClass, nCtl, nLenDynData )

   METHOD GetNewId() INLINE ++nId
   
   METHOD Paint() VIRTUAL   // Standard controls already know how to paint

   METHOD QueryDlgCode( nPtrMsg ) VIRTUAL

   METHOD Click( nRow, nCol, nFlags ) VIRTUAL
   
   METHOD LButtonDown( nRow, nCol, nFlags ) VIRTUAL
      
   METHOD LButtonUp( nRow, nCol, nFlags ) VIRTUAL

   METHOD LostFocus()

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), HE_DONE

   METHOD Register( nClsStyle )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Init( hDlg ) CLASS TControl

   ::hWnd = WinWindowFromId( hDlg, ::nId )

   ::Link()

return nil

//----------------------------------------------------------------------------//

METHOD cToChar( cCtrlClass, nCtl, nLenDynData ) CLASS TControl

   DEFAULT cCtrlClass := ::ClassName(),;
           ::cCaption := "",;
           ::nId      := ::GetNewId(),;
           ::nStyle   := nOR( WS_VISIBLE, WS_TABSTOP )

return cCtrl2Chr( ::nTop, ::nLeft, ::nBottom, ::nRight,;
                  ::nId, ::nStyle, cCtrlClass, ::cCaption, nCtl, nLenDynData )

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nLParam1, nLParam2 )  CLASS TControl

   do case
      case nMsg == WM_PAINT
           return ::Display()
       		
      case nMsg == WM_BUTTON1DOWN
           return ::LButtonDown( nHiWord( nLParam1 ),;
                                 nLoWord( nLParam1 ), nLoWord( nLParam2 ) )
           
      case nMsg == WM_BUTTON1UP
           return ::LButtonUp( nHiWord( nLParam1 ),;
                               nLoWord( nLParam1 ), nLoWord( nLParam2 ) )

      case nMsg == WM_BUTTON2DOWN
           return ::RButtonDown( nHiWord( nLParam1 ),;
                                 nLoWord( nLParam1 ), nLoWord( nLParam2 ) )

      case nMsg == FO_CLICK
           ::Click()

      case nMsg == FO_LOSTFOCUS
           if ! Eval( ::bValid, Self )
              WinSetFocus( HWND_DESKTOP, ::hWnd )
           endif
           ::oWnd:lValidating = .f.

      case nMsg == WM_BUTTON1DBLCLK
           return ::LDblClick( nHiWord( nLParam1 ),;
                               nLoWord( nLParam1 ),;
                               nLoWord( nLParam2 ) )

      case nMsg == WM_MOUSEMOVE
           return ::MouseMove( nHiWord( nLParam1 ),;
                               nLoWord( nLParam1 ),;
                               nLoWord( nLParam2 ) )

      case nMsg == WM_SETFOCUS
           if nLParam2 == 1
              ::GotFocus()
           else
              ::LostFocus()
              if ! ::oWnd:lValidating .and. ! Empty( ::bValid )
                 ::oWnd:lValidating = .t.
                 WinPostMsg( ::hWnd, FO_LOSTFOCUS )
              endif
           endif

      case nMsg == WM_VSCROLL
           return ::VScroll( nLParam1, nLParam2 )

      case nMsg == WM_HSCROLL
           return ::HScroll( nLParam1, nLParam2 )

      case nMsg == WM_QUERYDLGCODE
           return ::QueryDlgCode( nLParam1 )

      case nMsg == WM_CHAR
           return ::KeyChar( nLoWord( nLParam1 ),;             // fsflags
                             nHiByte( nHiWord( nLParam1 ) ),;  // ucrepeat
                             nLoByte( nHiWord( nLParam1 ) ),;  // ucscancode
                             nLoWord( nLParam2 ),;             // usch
                             nHiWord( nLParam2 ) ;             // usvk
                           )

       case nMsg == WM_TIMER
            return ::Timer( nLParam1 )
    endcase

return nil

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TControl

   Super:LostFocus()

   if ! Empty( ::bValid ) .and. ! ::oWnd:lValidating
      ::oWnd:lValidating = .t.
      WinPostMsg( ::hWnd, FO_LOSTFOCUS )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Register( nClsStyle ) CLASS TControl

   DEFAULT nClsStyle := 0

   WinRegisterClass( ::ClassName(),;
                     nOr( CS_SIZEREDRAW , nClsStyle ), 0 )

return nil

//----------------------------------------------------------------------------//
