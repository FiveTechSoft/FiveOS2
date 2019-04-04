#include "FiveOS2.ch"
#include "Clients.h"       // OS2 DlgEdit does not let us use .CH

static oWnd

//----------------------------------------------------------------------------//

function Main()

   local oBar

   DEFINE WINDOW oWnd TITLE "Clients Management" ;
      MENU BuildMenu()

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar RESOURCE IDB_INFO ;
      MESSAGE "Information about this program" ;
      ACTION MsgAbout()

   DEFINE BUTTON OF oBar ACTION Clients()  RESOURCE IDB_CLIENT ;
      MESSAGE "Clients management"

   DEFINE BUTTON OF oBar ACTION oWnd:End() RESOURCE IDB_EXIT ;
      MESSAGE "Exit this application"

   DEFINE BUTTON OF oBar RESOURCE IDB_CALC ACTION OS2Exec( "pmdcalc.exe" ) ;
      MESSAGE "Use the calculator" GROUP

   DEFINE BUTTON OF oBar RESOURCE IDB_CALENDAR  ACTION OS2Exec( "pmdcalen.exe" ) ;
      MESSAGE "Run Calendar App"

   DEFINE BUTTON OF oBar RESOURCE IDB_ICONEDIT ACTION OS2Exec( "iconedit.exe" ) ;
      MESSAGE "Run Icon Editor App"

   SET MESSAGE OF oWnd TO "FiveOS2 - CA-Clipper and IBM-OS2 magic!"

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Exit this app ?" )

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "~Information"
      MENU
         MENUITEM "~About..." ;
            ACTION MsgAbout() ;
            MESSAGE "Information about this program"
         SEPARATOR
         MENUITEM "~Exit..." ACTION oWnd:End() ;
            MESSAGE "Exit this application"
      ENDMENU

      MENUITEM "~DataBase"
      MENU
         MENUITEM "~Clients..." ACTION Clients() MESSAGE "Clients management"
         MENUITEM "~Stock..." ACTION MsgInfo( "This is just a FiveOS2 demo!" )
      ENDMENU

      MENUITEM "~Utilities"
      MENU
         MENUITEM "~Calculator" ACTION OS2Exec( "PmdCalc.exe" ) ;
            MESSAGE "Use the calculator"
         MENUITEM "C~alendar" ACTION OS2Exec( "PmdCalen.exe" ) ;
            MESSAGE "Use the calendar"
         MENUITEM "I~conEdit" ACTION OS2Exec( "IconEdit.exe" ) ;
            MESSAGE "Design an icon"
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function Clients()

   local oDlg, oName, oStreet, oNotes, oHBar
   local cName, cStreet, cCountry, cNotes
   local bUpdate := { || cName   := Customer->Last,   oName:Refresh(), ;
                         cStreet := Customer->Street, oStreet:Refresh(), ;
                         cNotes  := Customer->Notes,  oNotes:Refresh() }

   USE Customer

   cName    = Customer->Last
   cStreet  = Customer->Street
   cCountry = Customer->State
   cNotes   = Customer->Notes

   DEFINE DIALOG oDlg RESOURCE CLIENTS

   REDEFINE GET oName   VAR cName   ID ID_NAME   OF oDlg
   REDEFINE GET oStreet VAR cStreet ID ID_STREET OF oDlg
   REDEFINE GET oNotes  VAR cNotes  ID ID_NOTES  OF oDlg

   REDEFINE COMBOBOX cCountry ITEMS { "CA", "IL", "FL" } ;
      ID ID_COUNTRY OF oDlg

   REDEFINE SCROLLBAR oHBar ID ID_HORBAR OF oDlg ;
      RANGE 1, RecCount() ;
      ON LEFT  ShowPrev( bUpdate ) ;
      ON RIGHT ShowNext( bUpdate )

   REDEFINE BUTTON ID ID_TOP OF oDlg ;
      ACTION ShowFirst( bUpdate, oHBar )

   REDEFINE BUTTON ID ID_PREV OF oDlg ;
      ACTION ShowPrev( bUpdate, oHBar )

   REDEFINE BUTTON ID ID_NEXT OF oDlg ;
      ACTION ShowNext( bUpdate, oHBar )

   REDEFINE BUTTON ID ID_BOTTOM OF oDlg ;
      ACTION ShowBottom( bUpdate, oHBar )

   REDEFINE BUTTON ID ID_SEARCH OF oDlg ;
      ACTION MsgInfo( cName )

   REDEFINE BUTTON ID ID_END OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

   USE

return nil

//----------------------------------------------------------------------------//

function ShowFirst( bUpdate, oHBar )

   GO TOP
   Eval( bUpdate )
   oHBar:SetPos( 1 )

return nil

//----------------------------------------------------------------------------//

function ShowPrev( bUpdate, oHBar )

   DbSkip( -1 )
   if BoF()
      MsgAlert( "Begining of file!" )
      GO TOP
   else
      Eval( bUpdate )
   endif

   if oHBar != nil
      oHBar:SetPos( oHBar:GetPos() - 1 )
   endif

return nil

//----------------------------------------------------------------------------//

function ShowNext( bUpdate, oHBar )

   DbSkip()
   if EoF()
      MsgAlert( "End of file!" )
      GO BOTTOM
   else
      Eval( bUpdate )
   endif

   if oHBar != nil
      oHBar:SetPos( oHBar:GetPos() + 1 )
   endif

return nil

//----------------------------------------------------------------------------//

function ShowBottom( bUpdate, oHBar )

   if EoF()
      MsgAlert( "End of file!" )
      GO BOTTOM
   else
      GO BOTTOM
      Eval( bUpdate )
   endif

   oHBar:SetPos( RecCount() )

return nil

//----------------------------------------------------------------------------//

function MsgAbout()

   local oDlg

   DEFINE DIALOG oDlg RESOURCE DLG_ABOUT

   REDEFINE BUTTON ID ID_OK OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
