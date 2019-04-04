#include "FiveOS2.ch"

#define CLIENTS     100
#define ABOUT      1001

static oWnd

//----------------------------------------------------------------------------//

function Main()

   Local oBtn, oBar
   
   DEFINE WINDOW oWnd TITLE "FiveOS2 1.0 - CA-Clipper for IBM-OS2 library" ;
      MENU BuildMenu()

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar RESOURCE 101 ACTION MsgAbout() ;
      MESSAGE "Information about this application"

   DEFINE BUTTON OF oBar RESOURCE 102 ;
      ACTION cGetFile( "*.*", "Select a file" ) ;
      MESSAGE "Select a file"

   DEFINE BUTTON OF oBar RESOURCE 103 ACTION oWnd:End() ;
      MESSAGE "Exit this application"

   @ 20,  50 BUTTON "~Hello" OF oWnd ACTION MsgInfo( "Hello World!" )

   @ 20, 100 BUTTON "~Bye" OF oWnd ACTION oWnd:End()

   @ 20, 150 BUTTON "~Say" OF oWnd ACTION oWnd:Say( 10, 30, "Hello FiveOS2!" )
   
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

      MENUITEM "~DataBase"
      MENU
         MENUITEM "~Clients..."
         MENU
            MENUITEM "~New..."     ACTION Clients() ;
               MESSAGE "Add a new client"

            MENUITEM "~Modify..."  ACTION MsgInfo( "Modify" ) ;
               MESSAGE "Modify client data"

            MENUITEM "~Delete..." MESSAGE "Remove client"
         ENDMENU

         MENUITEM "~Stock..."      ACTION MsgBeep() ;
            MESSAGE "Stock maintenance"
      ENDMENU

      MENUITEM "~Help" ACTION MsgInfo( "CA-Clipper & IBM-OS2 Magic!" ) ;
         MESSAGE "Request help"
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function Clients()

   local oDlg, oFirst, oLast, oSbr
   local cFirst, cLast

   USE Customer
   if ! File( "CustLast.ntx" )
      INDEX ON Customer->Last TO CustLast
   endif
   SET INDEX TO CustLast
   GO TOP

   cFirst = Customer->First
   cLast  = Customer->Last

   DEFINE DIALOG oDlg RESOURCE CLIENTS

   REDEFINE GET oFirst VAR cFirst ID 106 OF oDlg
   REDEFINE GET oLast  VAR cLast  ID 108 OF oDlg

   REDEFINE SCROLLBAR oSbr ID 103 OF oDlg RANGE 1, RecCount() ;
      ON LEFT  ( DbSkip( -1 ),;
                 If( BoF(), ( MsgInfo( "Beginning of file!" ), DbGoTop() ),),;
                 cFirst := Customer->First, oFirst:Refresh(),;
                 cLast  := Customer->Last , oLast:Refresh() ) ;
      ON RIGHT ( DbSkip( 1 ),;
                 If( EoF(), ( MsgInfo( "End of file!" ), DbGoBottom() ),),;
                 cFirst := Customer->First, oFirst:Refresh(),;
                 cLast  := Customer->Last , oLast:Refresh() )

   REDEFINE BUTTON ID 104 OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

   USE

return nil

//----------------------------------------------------------------------------//

function MsgAbout()

   local oDlg
   
   DEFINE DIALOG oDlg RESOURCE ABOUT

   REDEFINE BUTTON ID 1 OF oDlg ACTION oDlg:End()
   
   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
