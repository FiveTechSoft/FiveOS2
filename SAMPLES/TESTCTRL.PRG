#include "FiveOS2.ch"
#include "TestCtrl.ch"

#define ID_CONTROLS 100

//----------------------------------------------------------------------------//

function Main()

   local oDlg, oSbrHor, oSbrVer
   local cTest  := "FiveOS2 xBase Power!"
   local nValue := 2
   local lTest  := .t.
   local cLbxItem, cCbxItem

   DEFINE DIALOG oDlg RESOURCE ID_CONTROLS

   REDEFINE GET cTest ID ID_GET OF oDlg

   REDEFINE CHECKBOX lTest ID ID_CHECKBOX OF oDlg ;
      ON CHANGE MsgInfo( "Checkbox toggled" )

   REDEFINE RADIO nValue ID 105, 106, 107 OF oDlg ;
      ON CHANGE MsgBeep()

   REDEFINE LISTBOX cLbxItem ;
      ITEMS { "Hello", "World", "from", "IBM-OS2", "and", "CA-Clipper 5" } ;
      ID ID_LISTBOX OF oDlg

   REDEFINE COMBOBOX cCbxItem ;
      ITEMS { "Hello", "World", "from", "IBM-OS2", "and", "CA-Clipper 5" } ;
      ID ID_COMBOBOX OF oDlg

   REDEFINE SCROLLBAR oSbrHor ID ID_HSCROLL OF oDlg ;
      ON LEFT  MsgInfo( "Scroll Left" ) ;
      ON RIGHT MsgInfo( "Scroll Right" )

   REDEFINE SCROLLBAR oSbrVer ID ID_VSCROLL OF oDlg ;
      ON UP   MsgInfo( "Scroll Up" ) ;
      ON DOWN MsgInfo( "Scroll Down" )

   REDEFINE BUTTON ID ID_BUTTON OF oDlg ;
      ACTION MsgInfo( "Hello World!" )

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
