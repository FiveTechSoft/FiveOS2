#include "FiveOS2.ch"

//----------------------------------------------------------------------------//

function Main()

   local hDLL := WinLoadLibrary( "c:\Fiveos2.10\dlls\screens.dll" )

   MsgInfo( hDLL )

   if WinDeleteLibrary( hDLL )
      MsgInfo( "DLL removed from memory" )
   else
      MsgInfo( "DLL could not be removed from memory" )
   endif

return nil

//----------------------------------------------------------------------------//
