#include "FiveOS2.ch"

static oLastItem
static hClass

//----------------------------------------------------------------------------//

CLASS TMenu

   DATA   hWnd
   DATA   aItems
   DATA   lPopup

   METHOD New( lPopup, oWnd ) CONSTRUCTOR
   METHOD Add( oMenuItem )

   METHOD Command( nCommand )

   METHOD GetMenuItem( nItemId ) INLINE SearchItem( ::aItems, nItemId )

   METHOD Activate( nRow, nCol, oWnd )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( lPopup, oWnd ) CLASS TMenu

   DEFAULT lPopup := .f.

   ::hWnd   = WinCreateMenu( If( oWnd != nil , oWnd:hWnd, HWND_DESKTOP ) )
   ::aItems = {}
   ::lPopup = lPopup

return nil

//----------------------------------------------------------------------------//

METHOD Add( oMenuItem ) CLASS TMenu

   local bAction := oMenuItem:bAction

   MnuItem( ::hWnd, oMenuItem:cPrompt, Len( ::aItems ),;
            If( ! ValType( bAction ) $ "BU", bAction:hWnd, nil ),;
            oMenuItem:nId, oMenuItem:lActive )

   AAdd( ::aItems, oMenuItem )

return nil

//----------------------------------------------------------------------------//

METHOD Command( nCommand ) CLASS TMenu

   local oMenuItem := ::GetMenuItem( nCommand )

   if oMenuItem != nil
      if ValType( oMenuItem:bAction ) == "B"
         oLastItem = oMenuItem
         Eval( oMenuItem:bAction )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function SearchItem( aItems, nId )

   local n      := 1
   local lFound := .f.
   local oReturn

   if hClass == nil
      hClass = TMenu():ClassH()
   endif

   while n <= Len( aItems ) .and. ! lFound
      if aItems[ n ]:nId == nId
         return aItems[ n ]
      else
         if aItems[ n ]:bAction:ClassH() == hClass
            if aItems[ n ]:bAction:hWnd == nId
               return nil
            else
               oReturn = SearchItem( aItems[ n ]:bAction:aItems, nId )
               if oReturn != nil
                  exit
               endif
            endif
         endif
      endif
      n++
   end

return oReturn

//----------------------------------------------------------------------------//

METHOD Activate( nRow, nCol, oWnd ) CLASS TMenu

   /* Popup menus not available in 16 bit !!!

   if oWnd != nil
      if oWnd:oPopup != nil
         oWnd:oPopup:End()
      endif
      oWnd:oPopup = Self
      WinPopupMenu( HWND_DESKTOP, oWnd:hWnd, ::hWnd, nRow, nCol )
      // SysRefresh()
      // ::End()
      oWnd:oPopup = nil
   endif

   */

return nil

//----------------------------------------------------------------------------//
