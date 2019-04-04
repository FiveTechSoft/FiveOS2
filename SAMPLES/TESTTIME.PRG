// Using Timers. Timers are also Objects!

#include "FiveOS2.ch"

static oWnd, oTimer

//----------------------------------------------------------------------------//

function Main()

   DEFINE WINDOW oWnd FROM 3, 3 TO 20, 50 ;
      TITLE "Testing timers" ;
      MENU  BuildMenu()

   SET MESSAGE OF oWnd TO "Controlling time events..."

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Do you want to end ?" )

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "~Timers"
      MENU
         MENUITEM "~Build a Timer" ACTION Timers()

         MENUITEM "~Stop the Timer" ;
            ACTION If( oTimer != nil,;
                       ( oTimer:End(), oTimer := nil ),;
                       MsgInfo( "Not timer available!" ) )
         SEPARATOR
         MENUITEM "~Exit..."   ACTION oWnd:End()
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function Timers()

   if oTimer == nil
      DEFINE TIMER oTimer ;
         ACTION ( oWnd:Say( 15, 20, Time() ),;
                  oWnd:Say( 17, 20, Date() ) ) ;
         INTERVAL 1000  // 1 sec

      ACTIVATE TIMER oTimer
   else
      MsgAlert( "There is already a working timer..." )
   endif

return nil

//----------------------------------------------------------------------------//
