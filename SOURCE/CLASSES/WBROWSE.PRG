#include "FiveOS2.ch"

#define FCF_VERTSCROLL   64  // 0x0040

#define DLGC_SCROLLBAR  128  // 0x0080

extern DBSKIP

static lRegistered := .f.

//----------------------------------------------------------------------------//

CLASS TWBrowse FROM TControl

   DATA   cAlias, cField, uValue1, uValue2
   DATA   bLine, bSkip, bGoTop, bGoBottom, bLogicLen, bChange, bAdd
   DATA   nRowPos, nColPos, nLen, nAt
   DATA   lHitTop, lHitBottom, lMChange
   DATA   aHeaders, aColSizes
   DATA   nClrBackHead, nClrForeHead
   DATA   nClrBackFocus, nClrForeFocus

   METHOD New( nTop, nLeft, nBottom, nRight;
            ,bLine, aHeaders, aColSizes, oWnd, cMsg ) CONSTRUCTOR

   METHOD ReDefine( nId, bLine, oDlg, aHeaders, aColSizes, cField, uVal1,;
                    uVal2, bChange, bLDblClick, bRClick, oFont,;
                    oCursor, nClrFore, nClrBack, cMsg, lUpdate,;
                    cAlias, bWhen, bValid ) CONSTRUCTOR
   
   METHOD LDblClick( nRow, nCol, nKeyFlags )

   METHOD Paint( nMsg, nLParam1, nLParam2 )
   
   METHOD PageDown( nLines )
   METHOD PageUp( nLines )

   METHOD QueryDlgCode() INLINE 0   // DLGC_SCROLLBAR

   METHOD MouseMove( nRow, nCol, nFlags )

   METHOD cToChar( nClassName, nControls, nDynData ) INLINE ;
          Super:cToChar( ::ClassName(), nControls, nDynData )

   METHOD DrawLine( nRow ) INLINE ;
               wBrwLine( ::hWnd, ::hPS, If( nRow == nil, ::nRowPos, nRow ), ;
               Eval( ::bLine ), ::GetColSizes(), ::nColPos,;
               ::nClrText, ::nClrPane,;
               If( ::oFont != nil, ::oFont:hFont, 0 ),;
               ValType( ::aColSizes ) == "B" )

   METHOD DrawSelect() INLINE ;
               wBrwLine( ::hWnd, ::hPS, ::nRowPos, Eval( ::bLine ),;
               ::GetColSizes(), ::nColPos, ::nClrForeFocus,;
               If( ::lFocused, ::nClrBackFocus, CLR_DARKGRAY ),;
               If( ::oFont != nil, ::oFont:hFont, 0 ),;
               ValType( ::aColSizes ) == "B"  )

   METHOD SetFilter( cField, uVal1, uVal2 )

   METHOD Skip
   
   METHOD GetColSizes() INLINE ;
          If( ValType( ::aColSizes ) == "A", ::aColSizes, Eval( ::aColSizes ) )

   
   METHOD KeyChar( nFlags, nRepeat, nScanCode, nChar, nVK )
   
   METHOD Default() 
   
   METHOD GoBottom()
   
   METHOD GoTop()   
   
   METHOD GoRight() 
   
   METHOD GoLeft()  
   
   METHOD GoDown()  
   
   METHOD GoUp()    

   METHOD GotFocus() INLINE Super:GotFocus(),;
                  If( ::nLen > 0 .and. ! Empty( ::cAlias ), ::DrawSelect(),)

   METHOD Init( hDlg )

   METHOD nRowCount() INLINE ;                                        // OS2
          nWRows( ::hWnd, 0, If( ::oFont != nil, ::oFont:hFont, 0 ) ) // - 1

   METHOD VScroll( nLParam1, nLParam2 )
   METHOD HScroll( nLParam1, nLParam2 )

   METHOD LButtonDown( nRow, nCol, nFlags )
   METHOD LButtonUp( nRow, nCol, nKeyFlags )

   METHOD VertLine( nColPos, nColInit )

   METHOD LostFocus() INLINE Super:LostFocus(),;
                   If( ::nLen > 0 .and. ! Empty( ::cAlias ), ::DrawSelect(),)

   METHOD UpStable()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight;
            ,bLine, aHeaders, aColSizes, oWnd, cMsg ) CLASS TWBrowse

   local aPos
   
   DEFAULT bLine = { || {} }, aHeaders = {}, aColSizes = {}

   ::oWnd      = If( oWnd:oWndClient != nil, oWnd:oWndClient, oWnd )
   ::nStyle    = nOr( WS_VISIBLE, WS_TABSTOP, FCF_VERTSCROLL )
   ::nClrPane  = SYSCLR_BUTTONMIDDLE
   ::nClrText  = CLR_BLACK
   ::nClrBackFocus = CLR_DARKCYAN
   ::nClrForeFocus = CLR_WHITE
   ::oCursor   = TCursor():New()
   ::nColPos   = 1
   ::nRowPos   = 1
   ::nLen      = 1           // Eval( ::bLogicLen )
   ::bLine     = bLine
   ::aHeaders  = aHeaders
   ::aColSizes = aColSizes
   ::lFocused  = .f.
   ::lValidating = .f.
   ::lHitTop    = .f.
   ::lHitBottom = .f.
   ::cAlias     = Alias()
   ::bLogicLen  = { || ( ::cAlias )->( RecCount() ) }

   if nTop == nil
      aPos      = WinQryRct( ::oWnd:hWnd )
      ::nTop    = aPos[ 1 ]
      ::nLeft   = aPos[ 2 ]
      ::nBottom = aPos[ 3 ]
      ::nRight  = aPos[ 4 ]
   else
      ::nTop    = nTop
      ::nLeft   = nLeft
      ::nBottom = nBottom
      ::nRight  = nRight
   endif

   if ! lRegistered
      WinRegisterClass( ::ClassName(), nOr( 0, CS_SIZEREDRAW, FCF_VERTSCROLL ) )
      lRegistered = .t.
   endif

   if ! Empty( ::oWnd:hWnd )
      aPos := WinQryRct( ::oWnd:hWnd )
      ::hWnd = WinCreateWindow( ::oWnd:hWnd,;
                                ::ClassName(), "", ::nStyle,;
                                ::nLeft, ::nBottom,;
                                ::nRight - ::nLeft,;
                                ::nTop - ::nBottom,;
                                ::oWnd:hWnd )
      ::Link()
      oWnd:AddControl( Self )

      @ 12, ::nRight - 14 SCROLLBAR ::oVScroll VERTICAL ;
         SIZE 14, ::nTop - ::nBottom - 11 OF Self ;
         RANGE 1, Eval( ::bLogicLen )

      @ ::nBottom, -1 SCROLLBAR ::oHScroll HORIZONTAL ;
         SIZE ::nRight - ::nLeft - 11, 14 OF Self ;
         RANGE 1, Len( ::GetColSizes() )

   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bLine, oDlg, aHeaders, aColSizes, cField, uVal1, uVal2,;
                 bChange, bLDblClick, bRClick, oFont, oCursor,;
                 nClrFore, nClrBack, cMsg, lUpdate, cAlias,; 
                 bWhen, bValid ) CLASS TWBrowse

   local aPos

   DEFAULT bLine = { || {} }, aHeaders = {}, aColSizes = {}

   ::nId           = nId
   ::oWnd          = If( oDlg:oWndClient != nil, oDlg:oWndClient, oDlg )
   ::nStyle        = nOr( WS_VISIBLE, WS_TABSTOP )
   ::nClrPane      = SYSCLR_BUTTONMIDDLE
   ::nClrText      = CLR_BLACK
   ::nClrBackFocus = CLR_DARKCYAN
   ::nClrForeFocus = CLR_WHITE
   ::nColPos       = 1
   ::nRowPos       = 1
   ::nLen          = 1           // Eval( ::bLogicLen )
   ::oCursor       = TCursor():New()
   ::bLine         = bLine
   ::aHeaders      = aHeaders
   ::aColSizes     = aColSizes
   ::lCaptured     = .f.
   ::lDrag         = .f.
   ::lFocused      = .f.
   ::lMChange      = .t.
   ::lValidating   = .f.
   ::lHitTop       = .f.
   ::lHitBottom    = .f.
   ::cAlias        = Alias()
   ::bLogicLen     = { || ( ::cAlias )->( RecCount() ) }

   ::bChange       = bChange
   ::bLDblClick    = bLDblClick
   ::bRClicked     = bRClick

   ::SetFilter( cField, uVal1, uVal2 )

   if ! lRegistered
      WinRegisterClass( ::ClassName(), CS_SIZEREDRAW )
      lRegistered = .t.
   endif

   oDlg:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD Paint( nMsg, nLParam1, nLParam2 ) CLASS TWBrowse

   local n        := 1
   local nLines   := ::nRowCount()
   local nSkipped := 1

   WinFillRect( ::hPS, { ::nTop, ::nLeft, ::nBottom, ::nRight },;
                ::nClrPane, ::hWnd )

   // Draw Headers
   wBrwLine( ::hWnd, ::hPS, 0,;
             ::aHeaders, ::aColSizes, ::nColPos,;
             SYSCLR_ACTIVETITLETEXT, SYSCLR_ACTIVETITLETEXTBGND,, .f. )

   ::Skip( -::nRowPos + 1 )

   while n <= nLines .and. nSkipped == 1
      ::DrawLine( n )
      nSkipped = ::Skip( 1 )
      if nSkipped == 1
         n++
      endif
   end

   ::Skip( ::nRowPos - n )
   ::DrawSelect()

return nil

//----------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TWBrowse

   if ::bSkip != nil
      return Eval( ::bSkip, n )
   endif

return _DBSkipper( n )

//--------------------------------------------------------------------------//

METHOD KeyChar( nFlags, nRepeat, nScanCode, nChar, nVK ) CLASS TWBrowse

   if lAnd( nFlags, KC_KEYUP )  // we only process when key is going down
      return nil
   endif

   do case
      case nVK == VK_UP
           ::GoUp()
           return 0

      case nVK == VK_DOWN
           ::GoDown()
           return 0

      case nVK == VK_LEFT
           ::GoLeft()
           return 0

      case nVK == VK_RIGHT
           ::GoRight()
           return 0

      case nVK == VK_HOME
           ::GoTop()

      case nVK == VK_END
           ::GoBottom()

      case nVK == VK_PAGEUP
           ::PageUp()

      case nVK == VK_PAGEDOWN
           ::PageDown()

      otherwise
           return Super:KeyChar( nFlags, nRepeat, nScanCode, nChar, nVK )
   endcase

return HE_DEFAULT

//--------------------------------------------------------------------------//

METHOD Init( hDlg ) CLASS TWBrowse

   local aPos

   Super:Init( hDlg )

   if ::nTop == nil
      aPos      = WinQryRct( ::oWnd:hWnd )
      ::nTop    = aPos[ 1 ]
      ::nLeft   = aPos[ 2 ]
      ::nBottom = aPos[ 3 ]
      ::nRight  = aPos[ 4 ]
   endif

   // @ 12, ::nRight - 14 SCROLLBAR ::oVScroll VERTICAL ;

   @ 12, ::nRight - 44 SCROLLBAR ::oVScroll VERTICAL ;
      SIZE 14, ::nTop - ::nBottom - 98 OF Self ;
      RANGE 1, Eval( ::bLogicLen )

   @ ::nBottom, -1 SCROLLBAR ::oHScroll HORIZONTAL ;
      SIZE ::nRight - ::nLeft - 41, 14 OF Self ;
      RANGE 1, Len( ::GetColSizes() )

      // SIZE ::nRight - ::nLeft - 11, 14 OF Self

return nil

//--------------------------------------------------------------------------//

METHOD GoUp() CLASS TWBrowse

   local nSkipped
   local nLines := ::nRowCount()

   if ::nLen < 1
      return nil
   endif

   if ! ::lHitTop
      ::DrawLine()
      if ::Skip( -1 ) == -1
         ::lHitBottom = .f.
         if ::nRowPos > 1
            ::nRowPos--
         else
            WBrwScroll( ::hWnd, -1, If( ::oFont != nil, ::oFont:hFont, 0 ) )
         endif
      else
         ::lHitTop = .t.
      endif
      ::DrawSelect()
      ::oVScroll:GoUp()
      if ::bChange != nil
         Eval( ::bChange )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoDown() CLASS TWBrowse

   local nSkipped
   local nLines := ::nRowCount()

   if ::nLen < 1
      return nil
   endif

   if ! ::lHitBottom
      ::DrawLine()
      if ::Skip( 1 ) == 1
         ::lHitTop = .f.
         if ::nRowPos < nLines
            ::nRowPos++
         else
            WBrwScroll( ::hWnd, 1, If( ::oFont != nil, ::oFont:hFont, 0 ) )
         endif
      else
         ::lHitBottom = .t.
      endif
      ::DrawSelect()
      ::oVScroll:GoDown()
      if ::bChange != nil
         Eval( ::bChange )
      endif
   endif

return nil

//---------------------------------------------------------------------------//

METHOD GoLeft()  CLASS TWBrowse

 if ::nColPos > 1
    ::nColPos--
    ::Refresh()           // avoid .f. to repaint scrollbars
    ::oHScroll:GoUp()
 endif

return nil

//---------------------------------------------------------------------------//

METHOD GoRight() CLASS TWBrowse

   if ::nColPos < Len( ::GetColSizes() )
      ::nColPos++
      ::Refresh()  // avoid .f. to repaint controls
      ::oHScroll:GoDown()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoTop() CLASS TWBrowse

   if ::nLen < 1
      return nil
   endif

   if ! ::lHitTop
      Eval( ::bGoTop )
      ::lHitTop = .t.
      ::lHitBottom = .f.
      ::nRowPos = 1
      ::Refresh()              // avoid .f. to repaint scrollbars
      ::oVScroll:GoTop()
      if ::bChange != nil
         Eval( ::bChange )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoBottom() CLASS TWBrowse

   local nSkipped
   local nLines := ::nRowCount()
   local n

   if ::nLen < 1
      return nil
   endif

   if ! ::lHitBottom
      ::lHitBottom = .t.
      ::lHitTop    = .f.

      Eval( ::bGoBottom )

      nSkipped = ::Skip( -( nLines - 1 ) )
      ::nRowPos = 1 - nSkipped

      ::GetDC()
      for n = 1 to -nSkipped
          ::DrawLine( n )
          ::Skip( 1 )
      next
      ::DrawSelect()
      ::ReleaseDC()
      ::oVScroll:GoBottom()
      if ::bChange != nil
         Eval( ::bChange )
      endif
   endif

return nil


//--------------------------------------------------------------------------//

METHOD Default() CLASS TWBrowse

   local n, aFields
   local cAlias := Alias()
   local nElements

   DEFAULT ::aHeaders := {}, ::aColSizes := {}

   if ::bLine == nil
      ::bLine = { || _aFields( cAlias ) }
   endif

   nElements = Len( Eval( ::bLine ) )

   if Len( ::aHeaders ) < nElements              //  == nil
      ::aHeaders = Array( nElements )
      for n = 1 to nElements
          ::aHeaders[ n ] = ( cAlias )->( Field( n ) )
      next
   endif

   if Len( ::GetColSizes() ) < nElements
      aFields = Eval( ::bLine )
      ::aColSizes = Array( nElements )
      for n = 1 to nElements
          ::aColSizes[ n ] := GetTextWidth( 0, Replicate( "B", ;
                                   Max( Len( ::aHeaders[ n ] ), ;
                                        Len( aFields[ n ] ) ) + 1 ) )
      next
   endif

// DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self ;
//    RANGE 1, Eval( ::bLogicLen )

// DEFINE SCROLLBAR ::oHScroll HORIZONTAL OF Self ;
//    RANGE 1, Len( ::GetColSizes() )

   if ::oFont == nil
      ::oFont = ::oWnd:oFont
   endif

return nil

//----------------------------------------------------------------------------//

function _aFields( cAlias )

   local aFld := Array( ( cAlias )->( FCount() ) )
   local n, uVal

   for n = 1 to Len( aFld )
       uVal = ( cAlias )->( FieldGet( n ) )
       if ValType( uVal ) == "N"
          uVal = Str( uVal )
          aFld[ n ] = xPadL( uVal,;
                      GetTextWidth( 0, Replicate( "B", Len( uVal ) ) ) )
       else
          aFld[ n ] = cValToChar( uVal )
       endif
   next

return aFld

//--------------------------------------------------------------------------//

METHOD VScroll( nLParam1, nLParam2 ) CLASS TWBrowse

   local nLines  := ::nRowCount()
   local nLen
   local nWParam := nHiWord( nLParam2 )

   if GetFocus() != ::hWnd
      SetFocus( ::hWnd )
   endif

   do case
      case nWParam == SB_LINEUP
           ::GoUp()

      case nWParam == SB_LINEDOWN
           ::GoDown()

      case nWParam == SB_PAGEUP
           ::PageUp()

      case nWParam == SB_PAGEDOWN
           ::PageDown()

      // case nWParam == SB_TOP
      //     ::GoTop()

      // case nWParam == SB_BOTTOM
      //     ::GoBottom()

      /*
      case nWParam == SB_THUMBPOSITION
           if ::nLen < 1
              return 0
           endif

           ::Skip( nLParam - ::oVScroll:GetPos() )
           ::oVScroll:SetPos( nLParam )

           nLen = Eval( ::bLogicLen )
           if nLParam - ::oVScroll:nMin < nLines
              ::nRowPos = 1
           endif
           if ::oVScroll:nMax - nLParam < Min( nLines, nLen )
              ::nRowPos = Min( nLines, nLen ) - ( ::oVScroll:nMax - nLParam )
           endif
           ::Refresh()           // avoid .f. to repaint controls
           if ::bChange != nil
              Eval( ::bChange )
           endif
        */

      otherwise
           return nil
   endcase

return 0

//----------------------------------------------------------------------------//

METHOD PageDown( nLines ) CLASS TWBrowse

   local nSkipped, n

   DEFAULT nLines := ::nRowCount()

   if ::nLen < 1
      return nil
   endif

   if ! ::lHitBottom
      ::DrawLine()
      nSkipped = ::Skip( ( nLines * 2 ) - ::nRowPos )

      if nSkipped != 0
         ::lHitTop = .f.
      endif

      do case
         case nSkipped == 0 .or. nSkipped < nLines
              if nLines - ::nRowPos < nSkipped
                 ::GetDC()
                 ::Skip( -( nLines ) )
                 for n = 1 to ( nLines - 1 )
                     ::Skip( 1 )
                     ::DrawLine( n )
                 next
                 ::Skip( 1 )
                 ::ReleaseDC()
              endif
              ::nRowPos = Min( ::nRowPos + nSkipped, nLines )
              ::lHitBottom = .t.
              ::oVScroll:GoBottom()

         otherwise
              ::GetDC()
              for n = nLines to 1 step -1
                  ::DrawLine( n )
                  ::Skip( -1 )
              next
              ::ReleaseDC()
              ::Skip( ::nRowPos )
      endcase
      ::DrawSelect()
      if ::bChange != nil
         Eval( ::bChange )
      endif

      if ! ::lHitBottom
         ::oVScroll:SetPos( ::oVScroll:GetPos() + nSkipped - ( nLines - ::nRowPos ) )
      else
         ::oVScroll:GoBottom()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PageUp( nLines ) CLASS TWBrowse

   local nSkipped

   DEFAULT nLines := ::nRowCount()

   nSkipped = ::Skip( -nLines )

   if ::nLen < 1
      return nil
   endif

   if ! ::lHitTop
      if nSkipped == 0
         ::lHitTop = .t.
      else
         ::lHitBottom = .f.
         if -nSkipped < nLines
            ::nRowPos = 1
            ::oVScroll:SetPos( 1 )
         else
            nSkipped = ::Skip( -nLines )
            ::Skip( -nSkipped )
            ::oVScroll:SetPos( ::oVScroll:GetPos() + nSkipped )
         endif

         ::Refresh()
         if ::bChange != nil
            Eval( ::bChange )
         endif
         
      endif
      
      // ::oVScroll:PageUp()

   else
      ::oVScroll:GoTop()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TWBrowse

   local nClickRow, nSkipped
   local nColPos := 0, nColInit := ::nColPos - 1
   local oRect

   if ::lDrag
      return Super:LButtonDown( nRow, nCol, nFlags )
   endif

   if ::nLen < 1
      return nil
   endif

   if ::lMChange .and. AScan( ::GetColSizes(),;
             { | nColumn | nColPos += nColumn,;
                           nColInit++,;
                           nCol >= nColPos - 1 .and. ;
                           nCol <= nColPos + 1 }, ::nColPos ) != 0
      if ! ::lCaptured
         ::lCaptured = .t.
         ::Capture()
         ::VertLine( nColPos, nColInit )
      endif
      return nil
   endif

   ::SetFocus()

   nClickRow = nWRow( ::hWnd, ::hPS, nRow,;
                      If( ::oFont != nil, ::oFont:hFont, 0 ) )

   if nClickRow > 0 .and. nClickRow != ::nRowPos .and. ;
                          nClickRow < ::nRowCount() + 1
      ::DrawLine()
      nSkipped  = ::Skip( nClickRow - ::nRowPos )
      ::nRowPos += nSkipped
      ::oVScroll:SetPos( ::oVScroll:GetPos() + nSkipped )
      ::DrawSelect()
      ::lHitTop = .f.
      ::lHitBottom = .f.
      if ::bChange != nil
         Eval( ::bChange )
      endif
   endif

   Super:LButtonDown( nRow, nCol, nFlags )

return 0

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TWBrowse

   local nColPos := 0

   if ::lDrag
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   if ::lCaptured
      CursorWE()
      ::VertLine( nCol )
      return 0
   endif

   if ::lDrag
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   else
      if ::lMChange .and. AScan( ::GetColSizes(),;
                { | nColumn | nColPos += nColumn,;
                              nCol >= nColPos - 1 .and. ;
                              nCol <= nColPos + 1 }, ::nColPos ) != 0
         CursorWE()
      else
         Super:MouseMove( nRow, nCol, nKeyFlags )
      endif
   endif

return 0

//----------------------------------------------------------------------------//

METHOD SetFilter( cField, uVal1, uVal2 ) CLASS TWBrowse

   DEFAULT uVal2 := uVal1

   ::cField     = cField
   ::uValue1    = uVal1
   ::uValue2    = uVal2

   // Posibility of using FILTERs based on INDEXES!!!

   ::bGoTop     = If( uVal1 != nil, { || ( ::cAlias )->( DbSeek( uVal1, .t. ) ) },;
                                    { || ( ::cAlias )->( DbGoTop() ) } )

   ::bGoBottom  = If( uVal2 != nil, { || ( ::cAlias )->( BrwGoBottom( uVal2 ) ) },;
                                    { || ( ::cAlias )->( DbGoBottom() ) } )

   ::bSkip      = If( uVal1 != nil, BuildSkip( ::cAlias, cField, uVal1, uVal2 ),;
                      { | n | ( ::cAlias )->( _DbSkipper( n ) ) } )

   ::bLogicLen  = If( uVal1 != nil,;
                      { || ( ::cAlias )->( Self:RecCount( uVal1 ) ) },;
                      { || ( ::cAlias )->( RecCount() ) } )

return nil

//----------------------------------------------------------------------------//
// To simulate Filters using INDEXES         -they go extremely fast!-

static function BuildSkip( cAlias, cField, uValue1, uValue2 )

   local bSkipBlock
   local cType := ValType( uValue1 )

   do case
      case cType == "C"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= '" + uValue1 + "' .and." + ;
           cField + "<= '" + uValue2 + "' }" ) ) ) }

      case cType == "D"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= CToD( '" + DToC( uValue1 ) + "') .and." + ;
            cField + "<= CToD( '" + DToC( uValue2 ) + "') }" ) ) ) }

      case cType == "N"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= " + cValToChar( uValue1 ) + " .and." + ;
           cField + "<= " + cValToChar( uValue2 ) + " }" ) ) ) }

      case cType == "L"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= " + cValToChar( uValue1 ) + " .and." + ;
           cField + "<= " + cValToChar( uValue2 ) + " }" ) ) ) }
   endcase

return bSkipBlock

//----------------------------------------------------------------------------//

static function BrwGoTo( n, bWhile )

   local nSkipped := 0, nDirection := If( n > 0, 1, -1 )

   while nSkipped != n .and. Eval( bWhile ) .and. ! EoF() .and. ! BoF()
      DbSkip( nDirection )
      nSkipped += nDirection
   enddo

   do case
      case EoF()
         DbSkip( -1 )
         nSkipped += -nDirection

      case BoF()
         DbGoTo( RecNo() )
         nSkipped++

      case ! Eval( bWhile )
         DbSkip( -nDirection )
         nSkipped += -nDirection
   endcase

return nSkipped

//----------------------------------------------------------------------------//

static function BrwGoBottom( uExpr )

   local lSoftSeek := Set( _SET_SOFTSEEK, .t. )

   if ValType( uExpr ) == "C"
      DbSeek( SubStr( uExpr, 1, Len( uExpr ) - 1 ) + ;
              Chr( Asc( SubStr( uExpr, Len( uExpr ) ) ) + 1 ) )
   else
      DbSeek( uExpr + 1 )
   endif
   DbSkip( -1 )

   Set( _SET_SOFTSEEK, lSoftSeek )

return nil

//----------------------------------------------------------------------------//

METHOD HScroll( nLParam1, nLParam2 ) CLASS TWBrowse

   local nWParam := nHiWord( nLParam2 )

   do case
      case nWParam == SB_LINEUP
           ::GoLeft()

      case nWParam == SB_LINEDOWN
           ::GoRight()

      case nWParam == SB_PAGEUP
           ::GoLeft()

      case nWParam == SB_PAGEDOWN
           ::GoRight()

      /*
      case nWParam == SB_TOP
           ::nColPos = 1
           ::oHScroll:SetPos( 1 )
           ::Refresh()

      case nWParam == SB_BOTTOM
           ::nColPos = Len( ::GetColSizes() )
           ::oHScroll:SetPos( ::nColPos )
           ::Refresh()
      */

      /*
      case nWParam == SB_THUMBPOSITION
           ::nColPos = nLParam
           ::oHScroll:SetPos( nLParam )
           ::Refresh()
      */

      otherwise
           return nil
   endcase

return 0

//----------------------------------------------------------------------------//

METHOD VertLine( nColPos, nColInit ) CLASS TWBrowse

   local oRect

   static nCol, nWidth, nOldPos := 0

   if nColInit != nil
      nCol    = nColInit
      nWidth  = nColPos
      nOldPos = 0
   endif
   if nColPos == nil .and. nColInit == nil   // We have finish draging
      ::aColSizes[ nCol ] -= ( nWidth - nOldPos )
      ::Refresh()
   endif

   oRect = ::GetRect()
   ::GetDC()
   if nOldPos != 0
      WinInvertRect( ::hPS, { nOldPos - 2, 0, nOldPos + 2, oRect:nTop } )
      nOldPos = 0
   endif
   if nColPos != nil .and. ( nColPos - 2 ) > 0
      WinInvertRect( ::hPS, { nColPos - 2, 0, nColPos + 2, oRect:nTop } )
      nOldPos = nColPos
   endif
   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TWBrowse

   if ::lDrag
      return Super:LButtonUp( nRow, nCol, nFlags )
   endif

   if ::lCaptured
      ::lCaptured = .f.
      ReleaseCapture()
      ::VertLine()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LDblClick( nRow, nCol, nFlags ) CLASS TWBrowse

   local nClickRow := nWRow( ::hWnd, ::hPS, nRow,;
                             If( ::oFont != nil, ::oFont:hFont, 0 ) )

   if nClickRow == ::nRowPos
      return Super:LDblClick( nRow, nCol, nFlags )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD UpStable() CLASS TWBrowse

   local nRow   := ::nRowPos
   local nRecNo := ( ::cAlias )->( RecNo() )
   local nRows  := ::nRowCount()
   local n      := 1
   local lSkip  := .t.

   ::nRowPos    = 1
   ::lHitTop    = .f.
   ::lHitBottom = .f.
   ::GoTop()

   while ! ( ::cAlias )->( EoF() )
      if n > nRows
         ( ::cAlias )->( DbGoTo( nRecNo ) )
         ::nRowPos = nRow
         lSkip     = .f.
         exit
      endif
      if nRecNo == ( ::cAlias )->( RecNo() )
         ::nRowPos = n
         exit
      else
         ( ::cAlias )->( DbSkip() )
      endif
      n++
   end

   if lSkip
      ( ::cAlias )->( DbSkip( -::nRowPos ) )
   endif

return nil

//----------------------------------------------------------------------------//
