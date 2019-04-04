#include "FiveOS2.ch"

#define BM_SETSTYLE  WM_USER + 4

//----------------------------------------------------------------------------//

CLASS TButton FROM TControl

   DATA   bAction

   METHOD New( nRow, nCol, cCaption, oWnd, bAction, nWidth, nHeight,;
               nHelpId, oFont, lDefault, lPixel, lDesign, cMsg,;
               lUpdate, bWhen, bValid ) CONSTRUCTOR

   METHOD ReDefine( nId, bAction, oWnd, nHelpId, cMsg,; 
                    lUpdate, bWhen, bValid ) CONSTRUCTOR

   METHOD Click() INLINE If( ::bAction != nil, Eval( ::bAction ),),;
                         Super:Click()

   METHOD cGenPRG()

   METHOD GotFocus() INLINE Super:GotFocus(),;
                            If( ::oWnd:ChildLevel( TDialog() ) == 0,;
                            ::SendMsg( BM_SETSTYLE, BS_DEFAULT, 1 ),)

   METHOD LostFocus() INLINE Super:LostFocus(),;
                             If( ::oWnd:ChildLevel( TDialog() ) == 0,;
                             ::SendMsg( BM_SETSTYLE, BS_PUSHBUTTON, 1 ),)

   METHOD MouseMove( nRow, nCol, nKeyFlags ) INLINE ;  // Standard Behavior
                     Super:MouseMove( nRow, nCol, nKeyFlags ), nil

   METHOD cToChar( nClassName, nControls, nDynData ) INLINE ;
          Super:cToChar( WC_BUTTON, nControls, nDynData )

   METHOD Colors( hDC ) INLINE  0

   METHOD Display() VIRTUAL

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cCaption, oWnd, bAction, nWidth, nHeight, ;
            nHelpId, oFont, lDefault, lPixel, lDesign, cMsg,; 
            lUpdate, bWhen, bValid ) CLASS TButton

   DEFAULT cCaption := "&Button",;
           oWnd     := GetWndDefault(),;
           oFont    := TFont():New( "System", 7, 10 ),;
           nWidth   := ( Len( cCaption ) + 2 ) * oFont:nWidth,;
           nHeight  := oFont:nHeight + Int( oFont:nHeight / 4 ),;
           nHelpId  := 100,;
           lDefault := .f., lPixel := .f., lDesign := .f., lUpdate := .f.

   ::cCaption  = cCaption
   ::nTop      = nRow * If( ! lPixel, ( oFont:nHeight + Int( oFont:nHeight / 4 ) ), 1 )
   ::nLeft     = nCol * If( ! lPixel, oFont:nWidth, 1 )
   ::nBottom   = ::nTop  + nHeight
   ::nRight    = ::nLeft + nWidth
   ::nHelpId   = nHelpId
   ::bAction   = bAction
   ::oWnd      = oWnd
   ::oFont     = oFont
   ::nStyle    = nOR( WS_VISIBLE, WS_TABSTOP,;
                     If( lDefault, BS_DEFAULT, 0 ) )
                     // If( lDesign, WS_THICKFRAME, 0 ) )
   ::nId       = ::GetNewId()
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bValid    = bValid

   if ! Empty( oWnd:hWnd )
      ::Create( WC_BUTTON )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bAction, oWnd, nHelpId, cMsg,; 
                 lUpdate, bWhen, bValid ) CLASS TButton

   ::nId       = nId
   ::bAction   = bAction
   ::hWnd      = 0
   ::nHelpId   = nHelpId
   ::oWnd      = oWnd
   ::lCaptured = .f.
   ::lDrag     = .f.
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bValid    = bValid

   oWnd:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD cGenPRG() CLASS TButton

   local cPrg := ""

   ::CoorsUpdate()

   cPrg += CRLF + ;
           "   @ " + Str( ::nTop, 3 ) + ", " + Str( ::nLeft, 3 ) + ;
           ' BUTTON "' + ::cCaption + '" SIZE ' + ;
           Str( ::nRight - ::nLeft + 1, 3 ) + ", " + ;
           Str( ::nBottom - ::nTop + 1, 3 ) + ;
           " PIXEL OF oWnd ;" + CRLF + ;
           '      ACTION MsgInfo( "Not defined yet!" )' + CRLF

return cPrg

//----------------------------------------------------------------------------//
