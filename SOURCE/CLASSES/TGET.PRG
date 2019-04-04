#include "FiveOS2.ch"
#include "Constant.ch"
#include "Set.ch"

#define EM_QUERYSEL        321   // 0x0141
#define EM_SETSEL          322   // 0x0142

#define ES_PASSWORD         32   // 0x020
#define GWL_STYLE          -16

#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8

#define VK_BACK              8
#define VK_ESCAPE           27
#define VK_RETURN           13

//----------------------------------------------------------------------------//

CLASS TGet FROM TControl

   DATA   oGet
   DATA   nClrFocusText, nClrFocusPane
   DATA   nPos
   DATA   lReadOnly, lPassword

   METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
               nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel,;
               cMsg, lUpdate, bWhen, lCenter, lRight, bChanged,;
               lReadOnly ) CONSTRUCTOR

   METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, cPict, bValid,;
                    nClrFore, nClrBack, oFont, oCursor, cMsg,;
                    lUpdate, bWhen, bChanged, lReadOnly ) CONSTRUCTOR

   METHOD Assign() INLINE ::oGet:Assign()

   METHOD cToChar( nClassName, nControls, nDynData ) INLINE ;
          Super:cToChar( WC_ENTRYFIELD, nControls, nDynData )

   METHOD Default()

   METHOD Display() VIRTUAL

   METHOD cGenPrg()

   METHOD GotFocus() INLINE  Super:GotFocus(),;
                             ::oGet:SetFocus(),;
                             ::DispText(),;
                             ::oGet:Pos := ::nPos, ::SetPos( ::nPos ),;
                             CallWindowProc( ::nOldProc, ::hWnd, WM_SETFOCUS ),;
                             If( Set( _SET_INSERT ),;
                             ( WinDestCursor( ::hWnd ),;
                               WinCreateCursor( ::hWnd, 0, 6, ::oFont:nHeight ),;
                               WinShowCursor( ::hWnd, .t. ) ),), 0

   METHOD HandleEvent( nMsg, nWParam, nLParam )
   METHOD Init( hDlg )

   METHOD KeyChar( nFlags, nRepeat, nScanCode, nChar, nVK )

   METHOD LostFocus()

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD cText( cText ) SETGET

   METHOD Refresh() INLINE ::oGet:SetFocus(),;
                           ::oGet:UpdateBuffer(),;
                           WinShowCursor( ::hWnd, .f. ),;
                           ::DispText(),;
                           ::SetPos( 0 ), WinShowCursor( ::hWnd, .t. )

   METHOD Save() INLINE ::oGet:Assign()

   METHOD DispText()
   METHOD GetSel()
   METHOD GetSelPos( @nStart, @nEnd )
   METHOD GetDelSel( nStart, nEnd )

   METHOD EditUpdate()

   METHOD lValid()

   METHOD SetPos( nStart, nEnd ) INLINE ;
                 nEnd := If( nEnd == nil, nStart, nEnd ),;
                 ::SendMsg( EM_SETSEL, nMakeLong( nStart - 1, nEnd - 1 ) ),;
                 ::nPos := nStart

   METHOD VarPut( uValue ) INLINE Eval( ::bSetGet, uValue ), ::Refresh()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly ) CLASS TGet

   DEFAULT nClrFore  := WinQrySysColor( HWND_DESKTOP, COLOR_WINDOWTEXT ),;
           nClrBack  := WinQrySysColor( HWND_DESKTOP, COLOR_WINDOW ),;
           oWnd      := GetWndDefault(),;
           nHeight   := If( oFont != nil, oFont:nHeight, 12 ),;
           lDesign   := .f., lPixel := .f., lUpdate := .f.,;
           lCenter   := .f., lRight := .f.,;
           lReadOnly := .f.

   ::cCaption = If( cPict == nil, cValToChar( Eval( bSetGet ) ), ;
                                  Transform( Eval( bSetGet ), cPict ) )
   ::nTop     = nRow * If( lPixel, 1, GET_CHARPIX_H )	 //13
   ::nLeft    = nCol * If( lPixel, 1, GET_CHARPIX_W )	 // 8
   ::nBottom  = ::nTop + nHeight - 1
   ::nRight   = ::nLeft + If( nWidth == nil, ( 1 + Len( ::cCaption ) ) * 3.5, ;
                                               nWidth - 1 )
   ::oWnd      = oWnd
   ::nStyle    = nOR( WS_VISIBLE, WS_TABSTOP, ES_LEFT,;
                      ES_AUTOSCROLL, ES_MARGIN,;
                      If( lCenter, ES_CENTER, If( lRight, ES_RIGHT, ES_LEFT ) ) )
                      // If( lDesign, WS_THICKFRAME, 0 ),;
                      // If( lCenter .or. lRight, ES_MULTILINE, 0 ),;
   ::nId       = ::GetNewId()
   ::bSetGet   = bSetGet
   ::oGet      = GetNew( 20, 20, bSetGet,, cPict )
   ::bValid    = bValid
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::lPassword = .f.
   ::oFont     = oFont
   ::oCursor   = oCursor
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bChange   = bChanged
   ::nPos      = 0
   ::lReadOnly = lReadOnly

   ::SetColor( nClrFore, nClrBack )

   ::oGet:SetFocus()
   ::cCaption = ::oGet:Buffer
   ::oGet:KillFocus()

   if ! Empty( oWnd:hWnd )
      ::Create( WC_ENTRYFIELD )
      ::Default()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, cPict, bValid, nClrFore,;
                 nClrBack, oFont, oCursor, cMsg, lUpdate, bWhen, bChanged,;
                 lReadOnly ) CLASS TGet

   DEFAULT nClrFore := WinQrySysColor( HWND_DESKTOP, COLOR_WINDOWTEXT ),;
           nClrBack := WinQrySysColor( HWND_DESKTOP, COLOR_WINDOW ),;
           lUpdate  := .f., lReadOnly := .f.

   if Eval( bSetGet ) == nil
      Eval( bSetGet, Space( 30 ) )
   endif

   ::nId       = nId
   ::oWnd      = oWnd
   ::nHelpId   = nHelpId
   ::bSetGet   = bSetGet
   ::oGet      = GetNew( 20, 20, bSetGet,, cPict )
   ::bValid    = bValid
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lPassword = .f.
   ::oFont     = oFont
   ::oCursor   = oCursor
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bChange   = bChanged
   ::nPos      = 0
   ::lReadOnly = lReadOnly

   ::SetColor( nClrFore, nClrBack )

   oWnd:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD Init( hDlg ) CLASS TGet

   Super:Init( hDlg )
   ::oGet:SetFocus()

   // ::lPassword = lAnd( WinQryLong( ::hWnd, GWL_STYLE ), ES_PASSWORD )

   ::DispText()
   ::oGet:KillFocus()

return nil

//---------------------------------------------------------------------------//
// Actualiza texto y y posici¢n del cursor del EDIT en funci¢n del oGet.
// Updates the text and the EDIT cursor position depending the oGet

METHOD EditUpdate() CLASS TGet

   WinShowCursor( ::hWnd, .f. )  // OS2 flicks cursor when changing
                                 // text on a GET
   if ::oGet:HasFocus
      ::DispText()
   endif

   ::SetPos( ::oGet:Pos )
   WinShowCursor( ::hWnd, .t. )

return nil

//---------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TGet

   static nCaretCol := 0
   local nHi, nLo

   do case
      case nMsg == WM_BUTTON1DOWN
           if ::lDrag
              return Super:HandleEvent( nMsg, nWParam, nLParam )
           else
              CallWindowProc( ::nOldProc, ::hWnd, nMsg, nWParam, nLParam )
              nCaretCol = GetCaretPos()[ 1 ]
              ::nPos = nCaretCol
              return 1
           endif

      case nMsg == WM_BUTTON1UP
           if ::lDrag
              return Super:HandleEvent( nMsg, nWParam, nLParam )
           else
              ::GetSelPos( @nLo, @nHi )
              ::oGet:pos = If( nCaretCol <= GetCaretPos()[ 1 ], nHi, nLo ) + 1
              ::nPos = ::oGet:pos
           endif

      /*
      case nMsg == WM_KEYUP
           // Paste from clipboard
           if nWParam == VK_INSERT .and. KbdShift()
               nLo = Len( ::oGet:buffer )
               ::oGet:buffer = Pad( WinGetText( ::hWnd ), nLo )
               ::oGet:pos    = nHiWord( ::SendMsg( EM_GETSEL ) ) + 1
               ::oGet:pos    = Min( nHiWord( ::SendMsg( EM_GETSEL ) ) + 1, nLo )
               ::EditUpdate()  // Many thanks to HMP
           elseif nWParam == VK_UP .or. nWParam == VK_DOWN
               return 1  // We have not processed the key and we don't let
                         // the edit to do it
           endif
       */

       endcase

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD cText( uVal ) CLASS TGet

   if PCount() == 1      // OJO Con Objects 2.0 PCount() es PCount() + 1
      ::oGet:VarPut( uVal )
      ::Refresh()
   endif

return WinGetText( ::hWnd )

//----------------------------------------------------------------------------//

METHOD GetSel() CLASS TGet

   local n      := ::SendMsg( EM_QUERYSEL )
   local nStart := nLoWord( n )
   local nEnd   := nHiWord( n )

return If( nStart != nEnd, SubStr( ::cText, nStart, nEnd - nStart + 1 ), "" )

//----------------------------------------------------------------------------//

METHOD GetSelPos( nStart, nEnd ) CLASS TGet

   local n := ::SendMsg( EM_QUERYSEL )
   nStart  := nLoWord( n )
   nEnd    := nHiWord( n )

return nil

//----------------------------------------------------------------------------//

METHOD GetDelSel( nStart, nEnd ) CLASS TGet

   ::oGet:buffer = Left( ::oGet:buffer, Min( nEnd, nStart ) ) ;
                   + Right( ::oGet:buffer, ;
                            Len( ::oGet:buffer ) - Max( nEnd, nStart ) ) ;
                   + Space( Abs( nStart - nEnd ) )

   ::oGet:Assign()
   ::oGet:Reset()
   ::oGet:pos := Min( nStart, nEnd ) + 1

return nil

//---------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TGet

   if ::lDrag
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   else
      ::oWnd:SetMsg( ::cMsg )        // Many thanks to HMP
      if ::oCursor != nil
         SetCursor( ::oCursor:hCursor )
      else
         CursorIBeam()
      endif
   endif

return nil      // We want standard Get behavior !!!

//---------------------------------------------------------------------------//

METHOD Default() CLASS TGet

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

return nil

//---------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TGet

   local cCode := ""

   cCode += CRLF + "   @ " + Str( ::nTop, 3 ) + ", " + Str( ::nLeft, 3 ) + ;
            " GET oGet SIZE " + Str( ::nRight - ::nLeft + 1, 3 ) + ;
            ", " + Str( ::nBottom - ::nTop + 1, 3 ) + ;
            " PIXEL OF oWnd " + CRLF

return cCode

//---------------------------------------------------------------------------//

METHOD KeyChar( nFlags, nRepeat, nScanCode, nKey, nVK ) CLASS TGet

   local nHi, nLo
   local lAccept
   local bKeyAction := SetKey( nKey )

   if bKeyAction != nil
      Eval( bKeyAction, ProcName( 4 ), ProcLine( 4 ) )
      return 0         // Already processed, API do nothing
   endif

   if ::lReadOnly
      return 0
   endif

   do case
      case nKey == VK_BACK
           ::oGet:BackSpace()
           ::EditUpdate()
           return 1

      case nKey == VK_ESCAPE
           MsgBeep()
           return 0

      case nKey == VK_RETURN .or. nKey == VK_TAB
           ::oWnd:GoNextCtrl( ::hWnd )
           return 0

      case nKey >= 32 .and. nKey < 256
           ::GetSelPos( @nLo, @nHi )
           // Delete selection
           if nHi != nLo
              ::GetDelSel( nLo, nHi )
              ::EditUpdate()
           endif
           if ::oGet:Type == "N" .and. ;
              ( Chr( nKey ) == "." .or. Chr( nKey ) == "," )
              ::oGet:ToDecPos()
           else
              if ::bChange != nil
                 lAccept = Eval( ::bChange, nKey, nFlags, Self )
                 if ValType( lAccept ) == "L" .and. ! lAccept
                    return 0
                 endif
              endif
              if Set( _SET_INSERT )             // many thanks to HMP
                 ::oGet:Insert( Chr( nKey ) )
              else
                 ::oGet:Overstrike( Chr(nKey) )
              end
           endif
           if ::oGet:Rejected()
              MsgBeep()
           else
              ::EditUpdate()
           endif
           if ::oGet:TypeOut .and. ! Set( _SET_CONFIRM )
              ::oWnd:nLastKey = VK_DOWN
              ::oWnd:GoNextCtrl( ::hWnd )
           endif
           return 1

      case nKey == VK_UP .or. nKey == VK_DOWN
           ::oWnd:FocusNext( ::hWnd, nKey == VK_UP )
           return 1   // We have not processed the key and we
                      // don't let the edit to do it

      case nKey == VK_LEFT
           if KbdControl()
              ::oGet:wordLeft()
           else
              ::oGet:left()
           endif
           ::SetPos( ::oGet:pos )
           return 0

      case nKey == VK_RIGHT
           if KbdControl()
              ::oGet:wordRight()
           else
              ::oGet:right()
           endif
           ::SetPos( ::oGet:Pos )
           return 0
                                          // Many thanks to HMP
      case nKey == VK_INSERT .and. ! KbdShift()
           Set( _SET_INSERT, ! Set( _SET_INSERT ) )
           WinDestCursor( ::hWnd )
           if Set( _SET_INSERT )
              WinCreateCursor( ::hWnd, 0, 6, ::oFont:nHeight )
           else
              WinCreateCursor( ::hWnd, 0, 1, ::oFont:nHeight )
           endif
           WinShowCursor( ::hWnd, .t. )
           return 0

      case nKey == VK_HOME
           ::oGet:Home()
           ::SetPos( ::oGet:Pos )
           return 0

      case nKey == VK_END
           ::oGet:End()
           ::SetPos( ::oGet:Pos )
           return 0

      case nKey == VK_DELETE
           if ::lReadOnly
              return 0
           endif

           ::GetSelPos( @nLo, @nHi )

             // Deletes selection
           if nHi != nLo
              ::GetDelSel( nLo, nHi )
              if KbdShift()
                 CallWindowProc( ::nOldProc, ::hWnd, WM_CHAR, nKey, nFlags )
              endif
           else
              ::oGet:Delete()
           endif
           ::EditUpdate()
           return 1
   endcase

return Super:KeyChar( nFlags, nRepeat, nScanCode, nKey, nVK )

//---------------------------------------------------------------------------//

METHOD lValid() CLASS TGet

   if ::oGet:BadDate
      MsgAlert( "Invalid date" )
      return .f.
   endif

return Super:lValid()

//---------------------------------------------------------------------------//

METHOD LostFocus() CLASS TGet

   Super:LostFocus()

   ::oGet:SetFocus()

   if ! ::oGet:BadDate
      ::oGet:Assign()     // for adjust numbers
      ::oGet:UpdateBuffer()
   endif

   WinShowCursor( ::hWnd, .f. )
   ::DispText()

   if ! ::oGet:BadDate
      ::oGet:KillFocus()
   else
      ::oGet:Pos = 1
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DispText() CLASS TGet

   if ::lPassword .and. ::oGet:Type == "C"
      WinSetWindowText( ::hWnd, Replicate( "*", Len( Trim( ::oGet:buffer ) ) ) )
   else
      WinSetWindowText( ::hWnd, ::oGet:buffer )
   endif

return nil

//----------------------------------------------------------------------------//
