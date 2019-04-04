#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <os2.h>
#include <ClipApi.h>

void main( int, char * [] );
int pascal _MessageBox( int, char *, char *, int );

HAB  hab;         /* Handle al Anchor Table */
HMQ  hmq;         /* Handle a la Cola de Mensages "Message Queue"*/

static BOOL bRunning = FALSE;


// Para colocar en init.c

//----------------------------------------------------------------------------//

extern void _Weed_eatr( void );
extern void _Start_Proc( void );
extern CLIPPER ErrorSys( void );

static void Link( void )
{
    _Weed_eatr();
    _Start_Proc();
    ErrorSys();
}


//----------------------------------------------------------------------------//

int FiveMain( int argc, char * argv[] )
{
  hab = WinInitialize( 0 );
  hmq = WinCreateMsgQueue( hab, 0 );

  main( argc, argv );

  WinDestroyMsgQueue( hmq );
  WinTerminate( hab );
  return 0;
}

//----------------------------------------------------------------------------//

CLIPPER WINRUN()
{
   QMSG qmsg;

   if( bRunning )
      return;

   bRunning = TRUE;

   while( WinGetMsg( hab, &qmsg, 0, 0, 0 ) )
   {
      WinDispatchMsg( hab, &qmsg );
   }

   bRunning = FALSE;
}

//----------------------------------------------------------------------------//

HAB GetHab( void ) { return hab; }

//----------------------------------------------------------------------------//

void _fwFreeAllGlobals( void ) { }
void _fwFreeAllLibrarys( void ) { }

//----------------------------------------------------------------------------//
