#include "FiveOS2.ch"
#include "Constant.ch"

#define LTGRAY_BRUSH       1
#define TRANSPARENT        1

#define DLGC_BUTTON     8192   // 0x2000

#define COLOR_WINDOW       5
#define COLOR_WINDOWTEXT   8

#define WM_NCHITTEST     132  // 0x84

//----------------------------------------------------------------------------//

CLASS TSay FROM TControl

   DATA   l3D
   DATA   cPicture
   DATA   bGet

   METHOD New( nRow, nCol, bText, oWnd, cPicture, oFont,;
               lCentered, lRight, lBorder, lPixels, nClrText, nClrBack,;
               nWidth, nHeight, lDesign, lUpdate, lShaded, lBox, lRaised ) CONSTRUCTOR

   METHOD ReDefine( nId, bText, oWnd, cPicture, ;
                    nClrText, nClrBack, lUpdate, oFont )  CONSTRUCTOR

   METHOD cToChar( nClassName, nControls, nDynData ) INLINE ;
          Super:cToChar( WC_STATIC, nControls, nDynData )

   METHOD Default()

   METHOD cGenPrg()

   METHOD HandleEvent( nMsg, nLParam1, nLParam2 )

   METHOD Init( hDlg )

   METHOD Refresh() INLINE If( ::bGet != nil, ::SetText( Eval( ::bGet ) ),)

   METHOD SetText( cText ) INLINE ;
                    ::cCaption := If( ::cPicture != nil,;
                                  Transform( cText, ::cPicture ),;
                                  cValToChar( cText ) ),;
                    WinSetWindowText( ::hWnd, ::cCaption )

   METHOD Display() VIRTUAL

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bText, oWnd, cPicture, oFont,;
            lCentered, lRight, lBorder, lPixels, nClrText, nClrBack,;
            nWidth, nHeight, lDesign, lUpdate, lShaded, lBox, lRaised ) CLASS TSay

   DEFAULT lBorder  := .f., lCentered := .f., lRight := .f., lPixels := .f.,;
           oWnd     := GetWndDefault(),;
           nClrText := oWnd:nClrText, nClrBack := oWnd:nClrPane,;
           nHeight  := If( oFont != nil, Abs( oFont:nHeight ), SAY_CHARPIX_H ),;
           lDesign  := .f., bText := { || "" },;
           lUpdate  := .f., lShaded := .f., lBox := .f., lRaised := .f.

   ::l3D       = lShaded .or. lBox .or. lRaised
   ::bGet      = bText
   ::cPicture  = cPicture
   ::cCaption  = If( Empty( cPicture ), cValToChar( Eval( bText ) ),;
                     Transform( Eval( bText ), cPicture ) )

   DEFAULT nWidth := ( If( oFont != nil, Abs( oFont:nWidth ), SAY_CHARPIX_W ) * Len( ::cCaption ) ) - 4	 // 8

   if ! lPixels
      ::nTop  = nRow * If( oFont != nil, Abs( oFont:nHeight ), SAY_CHARPIX_H ) + 2	  // 13
      ::nLeft = nCol * If( oFont != nil, Abs( oFont:nWidth ), SAY_CHARPIX_W )			 // 8
   else
      ::nTop  = nRow
      ::nLeft = nCol
   endif

   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1

   ::oWnd      = oWnd
   ::oFont     = oFont
   ::nId       = ::GetNewId()
   ::nStyle    = nOR( WS_VISIBLE ,;
                 If( lCentered, ES_CENTER, If( lRight, ES_RIGHT, ES_LEFT ) ),;
                 If( lBorder, ES_MARGIN, 0 ), SS_TEXT )
                 // If( lBox,    ES_GRAYRECT,  0 ) )
                 // If( lRaised, SS_WHITERECT, 0 ) )
                 // If( lShaded, SS_BLACKRECT, 0 ),;
                 // If( lDesign, WS_THICKFRAME, 0 ),;
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::lUpdate   = lUpdate

   ::SetColor( nClrText, nClrBack )

   if ! Empty( oWnd:hWnd )
      ::Create( WC_STATIC )
      ::Default()
      if ::l3D
         ::Set3DLook()
      endif
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bText, oWnd, cPicture,;
                 nClrText, nClrBack, lUpdate, oFont ) CLASS TSay

   DEFAULT nClrText := oWnd:nClrText, nClrBack := oWnd:nClrPane,;
           oWnd     := GetWndDefault(),;
           lUpdate  := .f.

   ::l3D       = .f.
   ::nId       = nId
   ::bGet      = bText
   ::cPicture  = cPicture
   ::oFont     = oFont

   if bText != nil
      ::cCaption = If( Empty( cPicture ), cValToChar( Eval( bText ) ),;
                       Transform( Eval( bText ), cPicture ) )
   endif

   ::oWnd      = oWnd
   ::hWnd      = 0
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lUpdate   = lUpdate

   ::SetColor( nClrText, nClrBack )
   oWnd:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD Init( hDlg ) CLASS TSay

   Super:Init( hDlg )

   if ! Empty( ::cCaption )
      WinSetWindowText( ::hWnd, ::cCaption )
   else
      ::cCaption = WinGetText( ::hWnd )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nLParam1, nLParam2 ) CLASS TSay

   if ::lDrag .and. nMsg == WM_NCHITTEST      // To have a standard behavior on Clicks
      return WinDefWindowProc( ::hWnd, nMsg, nLParam1, nLParam2 )
   endif

return Super:HandleEvent( nMsg, nLParam1, nLParam2 )

//----------------------------------------------------------------------------//

METHOD Default() CLASS TSay

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TSay

   local cCode := CRLF + "   @ " + Str( ::nTop, 3 ) + ", " + ;
                  Str( ::nLeft, 3 ) + ' SAY "' + ::cCaption + ;
                  '" SIZE ' + Str( ::nRight - ::nTop, 3 ) + ", " + ;
                  Str( ::nBottom - ::nTop, 3 ) + " PIXEL OF oWnd" + CRLF
return cCode

//----------------------------------------------------------------------------//
