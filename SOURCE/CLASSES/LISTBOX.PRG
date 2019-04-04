#include "FiveOS2.ch"
#include "Constant.ch"

#define LIT_END           -1

#define COLOR_WINDOW       5
#define COLOR_WINDOWTEXT   8

//----------------------------------------------------------------------------//

CLASS TListBox FROM TControl

   DATA   aItems
   DATA   lOwnerDraw, nBmpSize
   DATA   cFileSpec

   METHOD New( nRow, nCol, bSetGet, aItems, nWidth, nHeight, bChange,;
               oWnd, bValid, nClrFore, nClrBack, lPixel, lDesign,;
               bLDblClicked, oFont, cMsg, lUpdate, bWhen ) CONSTRUCTOR

   METHOD ReDefine( nId, bSetGet, aItems, bChange,  oWnd, nHelpId,;
                    lOwnerDraw, nBmpSize, bValid, cFileSpec,;
                    nClrFore, nClrBack, bLDblClicked, cMsg,;
                    lUpdate, bWhen ) CONSTRUCTOR

   METHOD cToChar( nClassName, nControls, nDynData ) INLINE ;
          Super:cToChar( If( Empty( nClassName ), WC_LISTBOX, nClassName ),;
                         nControls, nDynData )

   METHOD cGenPrg()

   METHOD Click() INLINE ::Change()

   METHOD Display() VIRTUAL

   METHOD Init( hDlg ) INLINE  Super:Init( hDlg ),;
                               ::Default()

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD GoTop()    INLINE ::Select( 1 )
   METHOD GoBottom() INLINE ::Select( Len( ::aItems ) )

   METHOD Select( nItem ) INLINE ::SendMsg( LM_SELECTITEM, nItem - 1, 1 ),;
                                 ::Change()

   METHOD Set( cNewItem )

   METHOD SetItems( aItems ) INLINE ::Reset(), ::aItems := aItems,;
                                    ::Default(),;
                                    ::SendMsg( LM_SELECTITEM, 0 ),;
                                    ::Change()

   METHOD Add( cItem, nAt )
   METHOD Modify( cItem, nAt )
   METHOD Insert( cItem, nAt )
   METHOD Del( nAt )
   METHOD GetItem( nItem ) VIRTUAL // INLINE  LbxGetItem( ::hWnd, nItem )

   METHOD Len() INLINE  ::SendMsg( LM_QUERYITEMCOUNT )

   METHOD LostFocus()

   METHOD Reset() INLINE Eval( ::bSetGet,;
                         If( ValType( Eval( ::bSetGet ) ) == "N", 0, "" ) ),;
                         ::SendMsg( LM_DELETEALL )

   METHOD Change()

   METHOD FillMeasure( nPInfo ) VIRTUAL // INLINE  LbxMeasure( nPInfo, ::nBmpSize )

   METHOD DrawItem( nPStruct ) VIRTUAL // INLINE  LbxDrawItem( nPStruct, ::aItems )

   METHOD GetPos() BLOCK ;             // it has to be a BLOCK
      { | Self, nPos | nPos := ::SendMsg( LM_QUERYSELECTION ),;
                       If( nPos == -1, 0, nPos + 1 ) }

   METHOD Default()

   METHOD VScroll( nWParam, nLParam ) VIRTUAL  // We request default behaviors

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, aItems, nWidth, nHeight, bChange, ;
            oWnd, bValid, nClrFore, nClrBack, lPixel, lDesign,;
            bLDblClicked, oFont, cMsg, lUpdate, bWhen )  CLASS TListBox

   if nClrFore == nil
      // nClrBack := GetSysColor( COLOR_WINDOW )
   endif

   DEFAULT aItems   := {}, nWidth := 40, nHeight := 40,;
           lPixel   := .f., lDesign := .f., lUpdate := .f.,;
           oWnd     := GetWndDefault()
           // nClrFore := GetSysColor( COLOR_WINDOWTEXT ),;

   ::cCaption   = ""
   ::nTop       = nRow * If( lPixel, 1, LST_CHARPIX_H )		//14
   ::nLeft      = nCol * If( lPixel, 1, LST_CHARPIX_W )	  // 8
   ::nBottom    = ::nTop  + nHeight - 1
   ::nRight     = ::nLeft + nWidth - 1
   ::aItems     = aItems
   ::bSetGet    = bSetGet
   ::bChange    = bChange
   ::bLDblClick = bLDblClicked
   ::oWnd       = oWnd
   ::oFont      = oFont
   ::lOwnerDraw = .f.
   ::nStyle     = nOR( WS_TABSTOP, WS_VISIBLE )
   ::nId        = ::GetNewId()
   ::bValid     = bValid
   ::lDrag      = lDesign
   ::lCaptured  = .f.
   ::cMsg       = cMsg
   ::lUpdate    = lUpdate
   ::bWhen      = bWhen

   ::SetColor( nClrFore, nClrBack )

   if ! Empty( oWnd:hWnd )
      ::Create( WC_LISTBOX )
      ::Default()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, aItems, bChange, oWnd, nHelpId,;
                 lOwnerDraw, nBmpSize, bValid, cFileSpec, nClrFore,;
                 nClrBack, bLDblClicked, cMsg, lUpdate, bWhen ) CLASS TListBox

   if nClrFore == nil
      // nClrBack := GetSysColor( COLOR_WINDOW )
   endif

   DEFAULT aItems   := {}, nBmpSize := 30,;
           lUpdate  := .f., lOwnerDraw := .f.
           // nClrFore := GetSysColor( COLOR_WINDOWTEXT ),;

   ::nId        = nId
   ::hWnd       = 0
   ::aItems     = aItems
   ::bSetGet    = bSetGet
   ::bChange    = bChange
   ::bLDblClick = bLDblClicked
   ::oWnd       = oWnd
   ::nHelpId    = nHelpId
   ::lOwnerDraw = lOwnerDraw
   ::nBmpSize   = nBmpSize
   ::bValid     = bValid
   ::cFileSpec  = cFileSpec
   ::lDrag      = .f.
   ::lCaptured  = .f.
   ::cMsg       = cMsg
   ::lUpdate    = lUpdate
   ::bWhen      = bWhen

   ::SetColor( nClrFore, nClrBack )

   /*
   if lOwnerDraw
      AEval( ::aItems, ;
             { | cBitmap, n | ::aItems[ n ] := ReadBitmap( 0, cBitmap ) } )
   endif
   */

   oWnd:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD Set( cNewItem ) CLASS TListBox

   local nAt := AScan( ::aItems,;
                       { | cItem | Upper( AllTrim( cItem ) ) == ;
                                   Upper( AllTrim( cNewItem ) ) } )

   if nAt != 0
      ::Select( nAt - 1 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TListBox

   local nAt := ::SendMsg( LM_QUERYSELECTION )

   Super:LostFocus()

   if nAt != -1
      if ValType( Eval( ::bSetGet ) ) == "N"
         Eval( ::bSetGet, nAt + 1 )
      else
         Eval( ::bSetGet, ::aItems[ nAt + 1 ] )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Add( cItem, nAt ) CLASS TListBox

   DEFAULT nAt := Len( ::aItems )

   if nAt == Len( ::aItems )
      AAdd( ::aItems, cItem )
      ::SendMsg( LM_INSERTITEM, LIT_END, cItem )
   else
      ASize( ::aItems, Len( ::aItems ) + 1 )
      AIns( ::aItems, nAt + 1 )
      ::aItems[ nAt + 1 ] = cItem
      ::SendMsg( LM_INSERTITEM, LIT_END, cItem )
   endif

   ::SendMsg( LM_SELECTITEM, nAt, 1 )

return nil

//----------------------------------------------------------------------------//

METHOD Modify( cItem, nAt ) CLASS TListBox

   if nAt == nil
      if ( nAt := ::SendMsg( LM_QUERYSELECTION ) ) != -1
         nAt++
      endif
   endif

   if nAt > 0
      ::aItems[ nAt ] = cItem
      ::SendMsg( LM_DELETEITEM, nAt - 1 )
      ::SendMsg( LM_INSERTITEM, nAt - 1, cItem )
      ::SendMsg( LM_SELECTITEM, nAt - 1, 1 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Insert( cItem, nAt ) CLASS TListBox

   if nAt == nil
      if ( nAt := ::SendMsg( LM_QUERYSELECTION ) ) != -1
         nAt++
      endif
   endif

   if nAt > 0
      ASize( ::aItems, Len( ::aItems ) + 1 )
      AIns( ::aItems, nAt )
      ::aItems[ nAt ] = cItem
      ::SendMsg( LM_INSERTITEM, nAt - 1, cItem )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Del( nAt ) CLASS TListBox

   if nAt == nil
      if ( nAt := ::SendMsg( LM_QUERYSELECTION ) ) != -1
         nAt++
      endif
   endif

   if nAt > 0
      ADel( ::aItems, nAt )
      ASize( ::aItems, Len( ::aItems ) - 1 )
      ::SendMsg( LM_DELETEITEM, nAt - 1 )
      ::SendMsg( LM_SELECTITEM, Min( nAt, Len( ::aItems ) ) - 1, 1 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Change() CLASS TListBox

   if ValType( Eval( ::bSetGet ) ) == "N"
      Eval( ::bSetGet, ::SendMsg( LM_QUERYSELECTION ) + 1 )
   else
      Eval( ::bSetGet, ::aItems[ ::SendMsg( LM_QUERYSELECTION ) + 1 ] )
   endif

   if ::bChange != nil
      Eval( ::bChange, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TListBox

   local nAt
   local cStart := Eval( ::bSetGet )
   local aFiles

   DEFAULT cStart := ""

   if ! ::lOwnerDraw
      if ! Empty( ::cFileSpec )
         aFiles = Directory( ::cFileSpec )
         for nAt = 1 to Len( aFiles )
            AAdd( ::aItems, aFiles[ nAt ][ 1 ] )
         next
         ASort( ::aItems )
      endif

      AEval( ::aItems,;
             { | cItem, nAt | If( cItem == nil, ::aItems[ nAt ] := "",),;
                              ::SendMsg( LM_INSERTITEM, LIT_END,;
                              If( cItem == nil, "", cItem ) ) } )

      if ValType( cStart ) != "N"
         nAt = AScan( ::aItems, { | cItem | Upper( AllTrim( cItem ) ) == ;
                                    Upper( AllTrim( cStart ) ) } )
      else
         nAt = cStart
      endif

      if nAt != 0
         ::SendMsg( LM_SELECTITEM, nAt - 1, 1 )
      endif
   else
      AEval( ::aItems, { | cItem | ::Add( "Testing..." ) } )
   endif

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TListBox

   local nResult := Super:MouseMove( nRow, nCol, nKeyFlags )

return If( ::lDrag, nResult, nil )    // We want standard behavior !!!

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TListBox

   local cCode := ""
   local n

   cCode += CRLF + "   @ " + Str( ::nTop, 3 ) + ", " + Str( ::nLeft, 3 ) + ;
            " LISTBOX oLbx ITEMS { "

   for n = 1 to Len( ::aItems )
      if n > 1
         cCode += ", "
      endif
      cCode += '"' + ::aItems[ n ] + '"'
   next

   cCode += " } ;" + CRLF + ;
            "      SIZE " + Str( ::nRight - ::nLeft + 1, 3 ) + ", " + ;
            Str( ::nBottom - ::nTop + 1, 3 ) + " PIXEL OF oWnd" + CRLF

return cCode

//----------------------------------------------------------------------------//
