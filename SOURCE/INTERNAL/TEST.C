#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <os2.h>
#include <ClipApi.h>

extern VOID * _plank_init;

//----------------------------------------------------------------------------//

CLIPPER PATCH1() // S()
{
   _plank_init = 0;
}

//----------------------------------------------------------------------------//
