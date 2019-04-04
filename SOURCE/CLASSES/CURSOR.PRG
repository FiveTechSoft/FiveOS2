#include "FiveOS2.ch"

#define SPTR_ARROW   1

//----------------------------------------------------------------------------//

CLASS TCursor

   DATA   hCursor

   METHOD New( nResName ) CONSTRUCTOR

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nResName ) CLASS TCursor

   if Empty( nResName )
      ::hCursor = WinQrySysPointer( HWND_DESKTOP, SPTR_ARROW, .f. )
   else
      ::hCursor = WinLoadPointer( GetResources(), nResName )
   endif

return nil

//----------------------------------------------------------------------------//
