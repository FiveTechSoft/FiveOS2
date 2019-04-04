#include "FiveOs2.ch"

//----------------------------------------------------------------------------//

CLASS TRadMenu

   DATA   aItems
   DATA   bSetGet, bChange
   DATA   cMsg
   DATA   lUpdate

   METHOD New( nRow, nCol, acItems, bSetGet, oWnd, nHelp, bChange,;
               nClrText, nClrPane, cMsg, lUpdate, bWhen, nWidth, nHeight ) CONSTRUCTOR

   METHOD Redefine( bSetGet, oWnd, nHelp, aRadioIDs, bChange,;
                    nClrText, nClrPane, cMsg, lUpdate, bWhen ) CONSTRUCTOR

   METHOD nOption( nNewOption ) SETGET

   METHOD Refresh()

   METHOD End() INLINE  AEval( ::aItems, { | oRadio | oRadio:End() } )

   METHOD Disable() INLINE AEval( ::aItems, { | oRadio | oRadio:Disable() } )
   METHOD Enable()  INLINE AEval( ::aItems, { | oRadio | oRadio:Enable() } )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, acItems, bSetGet, oWnd, nHelp, bChange,;
            nClrText, nClrPane, cMsg, lUpdate, bWhen, nWidth, nHeight ) CLASS TRadMenu

   local n

   if nClrText == nil
      nClrPane := oWnd:nClrPane
   endif

   DEFAULT nHelp := 100, nClrText := oWnd:nClrText, lUpdate := .f.

   ::aItems  = {}
   ::bSetGet = bSetGet
   ::bChange  = bChange
   ::cMsg    = cMsg
   ::lUpdate = lUpdate

   if ValType( Eval( bSetGet ) ) != "N"
      Eval( bSetGet, 1 )
   endif

   for n = 1 to Len( acItems )
      AAdd( ::aItems, TRadio():New( nRow - n - 1, nCol, acItems[ n ],;
            n == 1,;                // First element is group
            n == Eval( bSetGet ),;  // Is Checked ?
            n, oWnd, Self, nHelp, nClrText, nClrPane, cMsg, lUpdate, bWhen,;
            nWidth, nHeight ) )
   next

return nil

//----------------------------------------------------------------------------//

METHOD nOption( nNewOption ) CLASS TRadMenu

   if nNewOption != nil
      Eval( ::bSetGet, nNewOption )
      if ::bChange != nil
         Eval( ::bChange )
      endif
   else
      return Eval( ::bSetGet )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Redefine( bSetGet, oWnd, nHelp, anItemsIDs, bChange, nClrText,;
                 nClrPane, cMsg, lUpdate, bWhen )  CLASS TRadMenu

   local n

   if nClrText == nil
      nClrPane := oWnd:nClrPane
   endif

   DEFAULT nHelp := 100, nClrText := oWnd:nClrText, lUpdate := .f.

   ::bSetGet = bSetGet
   ::aItems  = {}
   ::bChange  = bChange
   ::cMsg    = cMsg
   ::lUpdate = lUpdate

   if ValType( Eval( bSetGet ) ) != "N"
      Eval( bSetGet, 1 )
   else
      if Eval( bSetGet ) == 0
         Eval( bSetGet, 1 )
      endif
   endif

   for n = 1 to Len( anItemsIDs )
       AAdd( ::aItems, TRadio():ReDefine( anItemsIDs[ n ], ;
                               n == Eval( bSetGet ),;  // Is Checked ?
                               n,;
                               oWnd, Self, nHelp, nClrText, nClrPane,;
                               cMsg, lUpdate, bWhen ) )
   next

return Self

//---------------------------------------------------------------------------//

METHOD Refresh() CLASS TRadMenu

   local nOption := Eval( ::bSetGet )
   local nAt     := AScan( ::aItems, { | oRadio | oRadio:lIsChecked() } )

   if nAt != nOption .and. nAt <= Len( ::aItems )
      ::aItems[ nAt ]:SetCheck( .f. )
      ::aItems[ nOption ]:SetCheck( .t. )
   endif

return nil

//---------------------------------------------------------------------------//
