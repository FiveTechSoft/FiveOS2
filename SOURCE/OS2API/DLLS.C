#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

HAB GetHab( void );

//----------------------------------------------------------------------------//

CLIPPER WINLOADLIB() // RARY( cDLLName )  --> hDLL
{
   _retni( ( LONG ) WinLoadLibrary( GetHab(), _parc( 1 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER WINDELETEL() // IBRARY( hDLL )  --> lSuccess
{
   _retl( WinDeleteLibrary( GetHab(), ( HLIB ) _parni( 1 ) ) );
}

//----------------------------------------------------------------------------//
