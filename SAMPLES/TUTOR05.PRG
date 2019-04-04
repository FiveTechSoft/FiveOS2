#include "FiveOS2.ch"

//----------------------------------------------------------------------------//

function Main()

   local oDlg

   DEFINE DIALOG oDlg FROM 20, 20 TO 120, 250 ;
      TITLE "Hello FiveOS2!"

   @ 5, 5 BUTTON "~Hello" SIZE 56, 14 OF oDlg ;
      ACTION MsgInfo( "FiveOS2 1.0" )

   @ 30, 5 BUTTON "~Bye" SIZE 56, 14 OF oDlg ;
      ACTION MsgInfo( "FiveOS2 1.0" )

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
