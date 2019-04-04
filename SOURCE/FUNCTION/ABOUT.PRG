#include "FiveOS2.ch"


//----------------------------------------------------------------------------//

function MsgAbout()

   local oDlg
   
   DEFINE DIALOG oDlg RESOURCE IDLG_ABOUT

   REDEFINE BUTTON ID 1 OF oDlg ACTION oDlg:End()
   
   ACTIVATE DIALOG oDlg CENTERED

return nil

