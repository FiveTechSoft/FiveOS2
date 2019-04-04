#include "FiveOS2.ch"

#define ICO_FIVEOS2   1

//----------------------------------------------------------------------------//

function Main()

   local oWnd, oChild1, oChild2
   local oIco

   DEFINE ICON oIco RESOURCE ICO_FIVEOS2

   DEFINE WINDOW oWnd ;
      FROM 2, 2 TO 20, 70 ;
      TITLE "Main window"

   DEFINE WINDOW oChild1 ;
      FROM 2, 2 TO 4, 20 ;
      TITLE "Child1" OF oWnd ;
      ICON oIco

   DEFINE WINDOW oChild2 ;
      FROM 2, 21 TO 4, 40 ;
      TITLE "Child2" OF oWnd ;
      ICON oIco

   ACTIVATE WINDOW oWnd

return nil

//----------------------------------------------------------------------------//
