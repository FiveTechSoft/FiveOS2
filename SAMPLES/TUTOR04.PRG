#include "FiveOs2.ch"

//----------------------------------------------------------------------------//

function Main()

   local oWnd
   local oBtn

   DEFINE WINDOW oWnd TITLE "Hello world!"

   @ 5, 5 BUTTON oBtn PROMPT "~Show" OF oWnd ;
      ACTION ( oBtn:Hide(), MsgInfo( "Hide" ), oBtn:Show(), MsgInfo( "Visible" ) )

   @ 30, 70 SAY "Hello" OF oWnd

   ACTIVATE WINDOW oWnd MAXIMIZED

return nil

//----------------------------------------------------------------------------//
