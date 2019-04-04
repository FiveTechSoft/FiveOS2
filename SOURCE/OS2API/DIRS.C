#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

//----------------------------------------------------------------------------//

CLIPPER DOSCURDIR()
{
   BYTE Buffer[ 256 ];
   USHORT wLen = 255;

   DosQCurDir( 0, Buffer, &wLen );
   _retc( Buffer );
}

//----------------------------------------------------------------------------//
