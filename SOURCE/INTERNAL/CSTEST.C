#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <os2.h>
#include <ClipApi.h>

extern VOID * _plank_init;

WORD pascal DosCreateDSAlias( SEL, PSEL );

//----------------------------------------------------------------------------//

WORD CreateAlias( WORD wCodeSeg )
{
   asm {
      mov bx, wCodeSeg;
      mov ax, 0x000A;
      int 0x31;                    // servicios dpmi !!!
      jnc ok;
      xor ax, ax;
   }
   ok:
   return _AX;
}

//----------------------------------------------------------------------------//

void TestParche( void )
{
   TestParche();
   TestParche();
   TestParche();
}

//----------------------------------------------------------------------------//

CLIPPER TestPatch()
{
   SEL DatSeg; //  = CreateAlias( SELECTOROF( TestParche ) );

   DosCreateDSAlias( SELECTOROF( TestParche ), &DatSeg );

   * ( LPBYTE ) MAKEP( DatSeg, OFFSETOF( TestParche ) ) = 90;
}

//----------------------------------------------------------------------------//

CLIPPER PATCH1()
{
   _plank_init = 0;
}

//----------------------------------------------------------------------------//
