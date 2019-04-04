#include "FiveOS2.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   Local oBtn, oBar
   
   DEFINE WINDOW oWnd TITLE "FiveOS2 1.0 - CA-Clipper for IBM-OS2 library" ;
      MENU BuildMenu()

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar

   @ 20, 50 BUTTON "~Test" OF oWnd ACTION TstBrowse()
   
   SET MESSAGE OF oWnd TO "FiveOS2 - CA-Clipper & IBM-OS2 magic!"

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Do you want to end ?" )

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "~Info"
      MENU
         MENUITEM "~About..." ACTION MsgAbout() ;
            MESSAGE "Information about this application"

         SEPARATOR

         MENUITEM "~Exit..."  ACTION oWnd:End() ;
            MESSAGE "Finish this application"
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function TstBrowse()

   local oDlg, oBrw

   DEFINE WINDOW oDlg TITLE "Test Browse"
   
   USE CUSTOMER 
   
   oBrw = TWBrowse():New( ,,,, { || { Customer->First,;
                                      Customer->Last,;
                                      Customer->Street } },;
                        { "Name", "Surname", "Address" },;
                        { 100, 100, 200 }, oDlg, "Test Browse" )

   ACTIVATE WINDOW oDlg

return nil

//----------------------------------------------------------------------------//
