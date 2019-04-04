#include "FiveOS2.ch"

//----------------------------------------------------------------------------//

function Main()

   local oDlg
   local nValue := 123.45

   DEFINE DIALOG oDlg ;
      FROM 2, 2 TO 100, 250 ;
      TITLE "Testing gets"

   @ 5, 2 SAY "Phone:" OF oDlg

   @ 2, 2 GET nValue OF oDlg ;
      PICTURE "999,99" ;
      SIZE 120, 8 RIGHT

   @ 5, 10 BUTTON "~Ok" OF oDlg ;
      SIZE 60, 12 ;
      ACTION If( MsgYesNo( "Want to end ?" ), oDlg:End(),)

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
