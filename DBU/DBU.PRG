#include "FiveOS2.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   local oBar

   DEFINE WINDOW oWnd ;
      TITLE "FiveOS2 - DBU" ;
      MENU BuildMenu()

   oWnd:oWndClient:bKeyChar  = { | nKey | If( nKey == VK_ESC, oWnd:End(),) }
   oWnd:oWndClient:bRClicked = { || Setup() }

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON RESOURCE 10 OF oBar ACTION MsgInfo( "FiveOS2 - DBU" )

   DEFINE BUTTON OF oBar ACTION cGetFile( "*.dbf", "Select a DBF" )

   DEFINE BUTTON RESOURCE 30 OF oBar ;
      ACTION oWnd:End() ;
      MESSAGE "Exit from FiveOS2-DBU"

   DEFINE BUTTON OF oBar GROUP
   DEFINE BUTTON OF oBar 
   DEFINE BUTTON OF oBar 
   DEFINE BUTTON OF oBar 

   SET MESSAGE OF oWnd ;
      TO "CA-Clipper for IBM-OS2 Library" CENTERED

   ACTIVATE WINDOW oWnd MAXIMIZED ;
      VALID MsgYesNo( "Exit from FiveOS2-DBU ?" )

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "~Help  F1" ACTION MsgInfo( "FiveOS2 - DBU" )

      MENUITEM "~Open  F2"
      MENU
         MENUITEM "~DataBase" ACTION OpenDataBase()
         MENUITEM "~Index" DISABLED
         MENUITEM "~View"
      ENDMENU

      MENUITEM "~Create F3"
      MENU
         MENUITEM "~DataBase"
         MENUITEM "~Index" DISABLED
      ENDMENU

      MENUITEM "~Save F4"
      MENU
         MENUITEM "~View"
         MENUITEM "~Struct" DISABLED
      ENDMENU

      MENUITEM "~Browse F5"
      MENU
         MENUITEM "~DataBase" DISABLED
         MENUITEM "~View"     DISABLED
      ENDMENU

      MENUITEM "~Utility F6"
      MENU
         MENUITEM "~Copy"     DISABLED
         MENUITEM "~Append"   DISABLED
         MENUITEM "~Replace"  DISABLED
         MENUITEM "~Pack"     DISABLED
         MENUITEM "~Zap"      DISABLED
         MENUITEM "R~un"
      ENDMENU

      MENUITEM "~Move F7"
      MENU
         MENUITEM "~Seek"
         MENUITEM "~Goto"
         MENUITEM "~Locate"
         MENUITEM "~Skip"
      ENDMENU

      MENUITEM "~Set F8"
      MENU
         MENUITEM "~Relation"
         MENUITEM "~Filter"
         MENUITEM "F~ields"
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function OpenDataBase()

   local oChild

   DEFINE WINDOW oChild OF oWnd TITLE "Child"

   ACTIVATE WINDOW oChild

return nil

//----------------------------------------------------------------------------//

function Setup()

   local oMenu

   MENU oMenu POPUP
      MENUITEM "~Colors..."
   ENDMENU

   MsgInfo( oMenu:hWnd )

   ACTIVATE POPUP oMenu OF oWnd AT 100, 100

return nil

//----------------------------------------------------------------------------//
