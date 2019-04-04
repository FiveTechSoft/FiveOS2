#include "FiveOS2.ch"

//----------------------------------------------------------------------------//

function cGetFile( cMask, cTitle )

   local oDlg, oGet, oFiles
   local cName := PadR( cMask, 40 )
   local cFile := "One", cPath := DosCurDir()
   local aFiles := {}, aPaths := {}
   local aTemp

   DEFAULT cMask  := ""
   DEFAULT cTitle := "Select a file"

   aTemp = Directory( "c:\*.*" )
   AEval( aTemp, { | aFile | AAdd( aFiles, aFile[ 1 ] ) } )

   DEFINE DIALOG oDlg FROM 0, 0 TO 112, 240 TITLE cTitle

   @ 102, 8 SAY "FileName:" OF oDlg SIZE 80, 8 PIXEL

   @ 92, 10 GET oGet VAR cName OF oDlg SIZE 180, 8 PIXEL

   @ 79, 8 SAY "Files:" OF oDlg SIZE 60, 8 PIXEL
   @  5, 8 LISTBOX oFiles VAR cFile ITEMS { "One", "Two", "Three" } ;
      SIZE 87, 79 PIXEL OF oDlg ;
      ON CHANGE oGet:VarPut( cFile )

   @ 79, 103 SAY "Directory:" OF oDlg SIZE 60, 8 PIXEL
   @  5, 103 LISTBOX cPath ITEMS aPaths SIZE 87, 79 PIXEL OF oDlg

   @ 89, 198 BUTTON "~Ok"     SIZE 40, 14 PIXEL OF oDlg ;
      ACTION oFiles:Add( "test" )

   @ 73, 198 BUTTON "~Cancel" SIZE 40, 14 PIXEL OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
