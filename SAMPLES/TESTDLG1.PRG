#include "FiveOS2.ch"

//----------------------------------------------------------------------------//

function Main()

   local oDlg
   local cName   := "Testing..."
   local cItem1  := "Two", cItem2 := "world"
   local nValue  := 2
   local lLogic  := .t.

   DEFINE DIALOG oDlg TITLE "A Modal Dialog from source code" ;
      FROM 2, 2 TO 100, 300

   @ 73, 13 SAY "Name" SIZE 30, 15 OF oDlg

   @ 80, 50 GET cName SIZE 120, 8 OF oDlg ;
      VALID If( Empty( cName ), ( MsgStop( "Write something!" ), .f. ), .t. )

   @ 40, 180 LISTBOX cItem2 ;
      ITEMS { "Hello", "world", "from", "CA-Clipper", "IBM-OS2", "and", "CA-Clipper" } ;
      SIZE 80, 50 OF oDlg

   @ 10, 275 SCROLLBAR VERTICAL ;
      SIZE 9, 80 ;
      ON UP MsgInfo( "Up" ) ;
      ON DOWN MsgInfo( "Down" ) ;
      OF oDlg

   @ 4, 2 CHECKBOX lLogic PROMPT "~CheckBox" OF oDlg ;
      ON CHANGE MsgBeep()

   @ 40, 20 SCROLLBAR HORIZONTAL ;
      SIZE 150, 7 ;
      RANGE 0, 10 ;
      ON LEFT MsgInfo( "Left" ) ;
      ON RIGHT MsgInfo( "Right" ) ;
      OF oDlg

   @ 17, 80 COMBOBOX cItem1 ITEMS { "One", "Two", "Three" } ;
      SIZE 80, 50 OF oDlg

   @  4,  27 RADIO nValue ITEMS "~One", "~Two", "T~hree" OF oDlg

   @ 20,  40 BUTTON "~Ok" SIZE 50, 13 ACTION MsgInfo( Str( nValue ) )

   @ 20, 100 BUTTON "~Cancel" SIZE 50, 13 ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
