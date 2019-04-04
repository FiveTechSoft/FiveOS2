#include "FiveOS2.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   local oSbr

   DEFINE WINDOW oWnd TITLE "Hello world!" ;
      MENU BuildMenu()

   DEFINE BUTTONBAR OF oWnd

   @ 5, 5 SCROLLBAR oSbr VERTICAL SIZE 16, 80 OF oWnd

   SET MESSAGE OF oWnd TO "FiveOS2 - CA-Clipper for IBM-OS2 library"

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Confirm exit" )

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "~Information"
      MENU
         MENUITEM "~About..." ACTION ( oWnd:oWndClient:GetDC(),;
                                       WinInvertRect( oWnd:oWndClient:hPS, { 0, 0, 100, 100 } ),;
                                       oWnd:oWndClient:ReleaseDC() )
         SEPARATOR
         MENUITEM "~Exit..." ACTION oWnd:End()
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//
