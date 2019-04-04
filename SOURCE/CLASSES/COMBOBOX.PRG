#include "FiveOS2.ch"

//----------------------------------------------------------------------------//

CLASS TComboBox FROM TListBox

   METHOD New( nRow, nCol, nWidth, nHeight, bSetGet, aItems, oWnd ) CONSTRUCTOR

   METHOD cToChar( nClassName, nControls, nDynData ) INLINE ;
          Super:cToChar( WC_COMBOBOX, nControls, nDynData )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, nWidth, nHeight, bSetGet, aItems, oWnd ) CLASS TComboBox

   local cItem := ""

   DEFAULT nWidth := 80, nHeight := 50, bSetGet := bSETGET( cItem ),;
           aItems := { "" }, oWnd := GetWndDefault()

   ::nTop     = nRow
   ::nLeft    = nCol
   ::nBottom  = nRow + nHeight - 1
   ::nRight   = nCol + nWidth - 1
   ::bSetGet  = bSetGet
   ::aItems   = aItems
   ::oWnd     = If( ! Empty( oWnd:oWndClient ), oWnd:oWndClient, oWnd )
   ::nStyle   = nOr( WS_VISIBLE, WS_TABSTOP, CBS_DROPDOWN )

   if ! Empty( oWnd:hWnd )
      ::hWnd = WinCreateWindow( ::oWnd:hWnd, WC_COMBOBOX, Eval( bSetGet ),;
                          ::nStyle, nRow, nCol, nWidth, nHeight, ::oWnd:hWnd )
      ::Link()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//
