#include "FiveWin.ch"

//----------------------------------------------------------------------------//

function Main()

   DEFINE WINDOW oWnd FROM 1, 1 TO 10, 44 ;
      TITLE OemToAnsi( "Probando los nuevos controles 'Meter'" )

   ACTIVATE WINDOW oWnd ;
      ON INIT ShowControls( oWnd )

return

//----------------------------------------------------------------------------//

function ShowControls( oWnd )

   local nActual := 0
   local oMeter

   @ 2, 2 METER oMeter VAR nActual TOTAL 50 OF oWnd

   @ 6,  8 BUTTON "&Disminuye" OF oWnd SIZE 90, 25 ;
      ACTION oMeter:Set( nActual - 1 )

   @ 6, 27 BUTTON "&Aumenta"   OF oWnd SIZE 90, 25 ;
      ACTION oMeter:Set( nActual + 1 )

return

//----------------------------------------------------------------------------//
