#include "FiveOs2.ch"
#include "Constant.ch"

#define BM_GETCHECK         (WM_USER+0)
#define BM_SETCHECK         293 // 0x125
#define LTGRAY_BRUSH          1

#define GCW_HCURSOR       (-12)

//----------------------------------------------------------------------------//

CLASS TRadio FROM TControl

   DATA   lChecked             // to init correctly its state
   DATA   oRadMenu
   DATA   nPos

   METHOD New( nRow, nCol, cCaption, lGroup, lChecked, nPos, oWnd, oRadMenu,;
               nHelpId, nClrText, nClrPane, cMsg, lUpdate, bWhen,;
               nWidth, nHeight ) CONSTRUCTOR

   METHOD Redefine( nID, lChecked, nPos, oDlg, oRadMenu, ;
                    nHelpID, nClrText, nClrPane, cMsg,;
                    lUpdate, bWhen ) CONSTRUCTOR

   METHOD Click()      INLINE  ::oRadMenu:nOption := ::nPos

   METHOD cToChar( nClassName, nControls, nDynData ) INLINE ;
          Super:cToChar( WC_BUTTON, nControls, nDynData )

   METHOD Display() VIRTUAL

   METHOD Init( hDlg ) INLINE  Super:Init( hDlg ),;
                               ::SetCheck( ::lChecked )

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD SetCheck( lOnOff ) INLINE  ::lChecked := lOnOff,;
                             ::SendMsg( BM_SETCHECK, If( lOnOff, 1, 0 ) )

   METHOD lIsChecked() INLINE  ::lChecked := ( ::SendMsg( BM_GETCHECK ) == 1 )

   METHOD Default()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cCaption, lGroup, lChecked, nPos, oWnd, oRadMenu,;
            nHelpId, nClrText, nClrPane, cMsg, lUpdate, bWhen, nWidth,;
            nHeight ) CLASS TRadio

   DEFAULT lChecked := .f., lGroup := .f., nPos := 1,;
           nHelpId := 100, lUpdate := .f.

   ::nTop      = nRow * If( nHeight != nil, nHeight, RAD_CHARPIX_H )  // 13
   ::nLeft     = ( nCol * RAD_CHARPIX_W ) + 4  //  7
   ::nBottom   = ::nTop + If( nHeight != nil, nHeight, 12 )
   ::nRight    = ::nLeft + If( nWidth != nil, nWidth, ( Len( cCaption ) * 7 ) )
   ::cCaption  = cCaption
   ::nStyle    = nOR( WS_VISIBLE, BS_AUTORADIOBUTTON,;
                      If( lGroup, WS_GROUP, 0 ) )
   ::nId       = ::GetNewId()
   ::nHelpId   = nHelpId
   ::lChecked  = lChecked
   ::nPos      = nPos
   ::oWnd      = If( ! Empty( oWnd:oWndClient ), oWnd:oWndClient, oWnd )
   ::oRadMenu  = oRadMenu
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen

   ::SetColor( nClrText, nClrPane )

   if ! Empty( oWnd:hWnd )
      ::hWnd = WinCreateWindow( ::oWnd:hWnd, WC_BUTTON, cCaption, ::nStyle,;
                                nRow, nCol, nWidth, nHeight, ::oWnd:hWnd )
      ::Link()
      ::Default()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return nil

//---------------------------------------------------------------------------//

METHOD Redefine( nID, lChecked, nPos, oDlg, oRadMenu, nHelpID, nClrText,;
                 nClrPane, cMsg, lUpdate, bWhen ) CLASS TRadio

   DEFAULT lChecked := .f., nPos := 1,;
           nHelpId := 100, lUpdate := .f.

   ::nId       = nID
   ::nHelpId   = nHelpId
   ::oWnd      = oDlg
   ::oRadMenu  = oRadMenu
   ::lChecked  = lChecked
   ::nPos      = nPos
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen

   ::SetColor( nClrText, nClrPane )

   oDlg:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TRadio

   local nResult := Super:MouseMove( nRow, nCol, nKeyFlags )

return If( ::lDrag, nResult, nil )    // We want standard behavior !!!

//----------------------------------------------------------------------------//

METHOD Default() CLASS TRadio

   if ::lChecked
      ::SetCheck( .t. )
      ::SetFocus()
   endif

return nil

//----------------------------------------------------------------------------//
