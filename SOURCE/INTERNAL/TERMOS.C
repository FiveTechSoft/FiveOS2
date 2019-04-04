#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <os2.h>
#include <ClipApi.h>

// BOOL IsModelessDialog( MSG * pMsg );

static WORD wTerm;

BYTE _nbuff[ 230 ] = {   // Clipper uses a buffer there !!! 11/11/94
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0x59,0x40,0,0x54,0x45,0x52,0x4d,0,
    0x0c,0x0d,0,0x0d,0x0a,0,0x0d,0x0a,
    0,0x0d,0,0x0d,0x0a,0,0x0d,0x0a,
    0,0x0d,0x0a,0,0x20,0,0x54,0x45,
    0x52,0x4d,0,0x1a,0,0x2e,0x54,0x58,
    0x54,0,0x2e,0x50,0x52,0x4e,0,0x1a,
    0,0x50,0x52,0x49,0x4e,0,0x2e,0x50,
    0x52,0x4e,0,0x50,0x52,0x49,0x4e,0,
    0x48,0x45,0x4c,0x50,0,0x53,0x43,0x52,
    0x45,0x45,0x4e,0,0,0,0x54,0x45,
    0x52,0x4d,0 };

//----------------------------------------------------------------------------//

void pascal DEVOUT()
{
    if( PCOUNT() > 1 )
       _xSetColor( _lbase + 3 );

   _gtWriteCon( _parc( 1 ), _parclen( 1 ) );

   if( PCOUNT() > 1 )
      _xSetColor( _eval );
}

//----------------------------------------------------------------------------//

void pascal DISPOUT() {}
void pascal LASTKEY() {}
void pascal NEXTKEY() {}

//----------------------------------------------------------------------------//

void pascal QOUT()
{
   BYTE CrLf[ 3 ];

   CrLf[ 0 ] = 13;
   CrLf[ 1 ] = 10;
   CrLf[ 2 ] =  0;

   _gtWriteCon( CrLf, 2 );
   _gtWriteCon( _parc( 1 ), _parclen( 1 ) );
}

//----------------------------------------------------------------------------//

void pascal QQOUT()   { QOUT(); }
// void pascal SETKEY()  {}   Est  en el m¢dulo KEYS.prg
void pascal SETPRC()  {}

void Now()         {}
void _cQOut()      {}
void _dbgtermx()   {}
void _modal_key()  {}
void _termSLR()    {}
void _xSetCursor() {}

//----------------------------------------------------------------------------//

WORD pascal __ROW()
{
   WORD wRow, wCol;

   _gtGetPos( &wRow, &wCol );
   _PutLN( wRow );
   return 0;
}

//----------------------------------------------------------------------------//

WORD pascal __COL()
{
   WORD wRow, wCol;

   _gtGetPos( &wRow, &wCol );
   _PutLN( wCol );
   return 0;
}

//----------------------------------------------------------------------------//

void pascal __PROW()     {}
void pascal __PCOL()     {}

//----------------------------------------------------------------------------//

WORD pascal __DEVPOS()
{
   _gtSetPos( _sptoq( _tos - 1 ), _sptoq( _tos ) );
   _tos--;
   return 0;
}

//----------------------------------------------------------------------------//

void pascal __EJECT()    {}
void pascal __INKEY0()   {}
void pascal __KEYBOARD() {}

//----------------------------------------------------------------------------//

WORD pascal __SETPOS()
{
   _gtSetPos( _sptoq( _tos - 1 ), _sptoq( _tos ) );
   _tos--;
   return 0;
}

//----------------------------------------------------------------------------//

void pascal __SETPOSBS()
{
   WORD wRow, wCol;

   _gtGetPos( &wRow, &wCol );
   _gtSetPos( wRow, ++wCol );

   ( ++_tos )->wType = 0;
}

void pascal __XHELP()    {}

//----------------------------------------------------------------------------//

void pascal __INKEY1()
{
   /*
   MSG msg;

   msg.message = 1;

   while( GetMessage( &msg, 0, 0, 0 ) && msg.message != WM_KEYDOWN )
   {
      if( ! IsModelessDialog( &msg ) )
      {
         TranslateMessage( &msg );
         DispatchMessage( &msg );
      }
   }
   _tos->pPointer1 = ( LPBYTE ) msg.wParam;
   */
}

//----------------------------------------------------------------------------//
