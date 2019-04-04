#include "FiveOS2.ch"

#define BM_SETCHECK   293 // 0x0125

#define WS_THICKFRAME   0

//----------------------------------------------------------------------------//

CLASS TCheckBox FROM TControl

   METHOD New( nRow, nCol, cCaption, bSetGet, oWnd, nWidth, nHeight,;
               nHelpTopic, bChange, oFont, bValid, nClrFore, nClrBack,;
               lDesign, lPixel, cMsg, lUpdate, bWhen ) CONSTRUCTOR

   METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, bChange, bValid,;
                    nClrFore, nClrBack, cMsg, lUpdate, bWhen ) CONSTRUCTOR

   METHOD Click()

   METHOD Default()

   METHOD cToChar( nClassName, nControls, nDynData ) INLINE ;
          Super:cToChar( WC_BUTTON, nControls, nDynData )

   METHOD Init( hDlg ) INLINE  Super:Init( hDlg ),;
                  ::SendMsg( BM_SETCHECK, If( Eval( ::bSetGet ), 1, 0 ) )

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD Refresh() INLINE ;
                    ::SendMsg( BM_SETCHECK, If( Eval( ::bSetGet ), 1, 0 ) )

   METHOD cGenPrg()

   METHOD Display() VIRTUAL   // We want standard behavior

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cCaption, bSetGet, oWnd, nWidth, nHeight, nHelpTopic,;
            bChange, oFont, bValid, nClrFore, nClrBack, lDesign, lPixel,;
            cMsg, lUpdate, bWhen ) CLASS TCheckBox

   DEFAULT cCaption   := "~CheckBox",;
           oFont      := TFont():New( "System", 8, 9 ),;
           nWidth     := Len( cCaption ) * oFont:nWidth,;
           nHeight    := oFont:nHeight + Int( oFont:nHeight / 2 ),;
           nHelpTopic := 100,;
           nClrFore   := oWnd:nClrText, nClrBack := oWnd:nClrPane,;
           lPixel     := .f., lDesign := .f., lUpdate := .f.

   if ValType( Eval( bSetGet ) ) != "L"
      Eval( bSetGet, .f. )
   endif

   ::nTop       = nRow * If( lPixel, 1,;
                             ( oFont:nHeight + Int( oFont:nHeight / 2 ) ) )
   ::nLeft      = nCol * If( lPixel, 1, oFont:nWidth ) + If( lPixel, 0, 3 )
   ::nBottom    = ::nTop + nHeight
   ::nRight     = ::nLeft + nWidth // - If( lPixel, 0, 24 )
   ::cCaption   = cCaption
   ::nStyle     = nOR( WS_VISIBLE, BS_AUTOCHECKBOX,;
                       WS_TABSTOP, If( lDesign, WS_THICKFRAME, 0 ) )
   ::nId        = ::GetNewId()
   ::nHelpId    = nHelpTopic
   ::bSetGet    = bSetGet
   ::bChange    = bChange
   ::oWnd       = oWnd
   ::oFont      = oFont
   ::bValid     = bValid
   ::lDrag      = lDesign
   ::lCaptured  = .f.
   ::cMsg       = cMsg
   ::lUpdate    = lUpdate
   ::bWhen      = bWhen

   ::SetColor( nClrFore, nClrBack )

   if ValType( Eval( bSetGet ) ) != "L"
      Eval( bSetGet, .f. )
   endif

   if ! Empty( oWnd:hWnd )
      ::Create( WC_BUTTON )
      ::Default()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Click() CLASS TCheckBox

   if ::bSetGet != nil
      Eval( ::bSetGet, ! Eval( ::bSetGet ) )
   endif

   if ::bChange != nil
      Eval( ::bChange, Eval( ::bSetGet ), Self )
   endif

   Super:Click()           // keep it here, the latest !!!

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, bChange, bValid, nClrFore,;
                 nClrBack, cMsg, lUpdate, bWhen ) CLASS TCheckBox

   DEFAULT nClrFore := oWnd:nClrText, nClrBack := oWnd:nClrPane

   if ValType( Eval( bSetGet ) ) != "L"
      Eval( bSetGet, .f. )
   endif

   ::nId       = nId
   ::bSetGet   = bSetGet
   ::bChange   = bChange
   ::oWnd      = oWnd
   ::nHelpId   = nHelpId
   ::bValid    = bValid
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen

   ::SetColor( nClrFore, nClrBack )

   oWnd:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TCheckBox

   if ::lDrag
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   else
      Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

return nil    //  We want standard behavior  !!!

//----------------------------------------------------------------------------//

METHOD Default() CLASS TCheckBox

   ::SendMsg( BM_SETCHECK, If( Eval( ::bSetGet ), 1, 0 ) )

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD cGenPRG() CLASS TCheckBox

   local cPrg := ""

   ::CoorsUpdate()

   cPrg += CRLF + ;
           "   @ " + Str( ::nTop, 3 ) + ", " + Str( ::nLeft, 3 ) + ;
           ' CHECKBOX lVar PROMPT "' + ::cCaption + '" SIZE ' + ;
           Str( ::nRight - ::nLeft + 1, 3 ) + ", " + ;
           Str( ::nBottom - ::nTop + 1, 3 ) + ;
           " PIXEL OF oWnd " + CRLF

return cPrg

//----------------------------------------------------------------------------//
