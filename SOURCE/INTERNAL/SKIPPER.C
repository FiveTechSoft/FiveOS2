#include <Clipapi.h>

extern CLIPPER __EOF( void );
extern CLIPPER __BOF( void );
extern CLIPPER DBGOBOTTOM( void );
extern CLIPPER DBSKIP( void );

typedef struct
{
    WORD dummy[ 3 ];
    WORD wLogic;
    WORD dumm[ 3 ];
} CLIPLOG;

typedef CLIPLOG near * PCLIPLOG;

#define SKIP( n ) _putsym( DBSkipSym ); (++_tos)->wType = 0; _putln( n ); _xDo( 1 );

static PCLIPSYMBOL DBSkipSym = 0;

static void near LINK() { DBSKIP(); DBGOBOTTOM(); }


CLIPPER _DBSkipper() // ( nSkipRequested ) -> nSkipped
{
   int  iToSkip  = _parni( 1 );
   int  iSkipped = 0;

   if( ! DBSkipSym )
         DBSkipSym = _Get_Sym( "DBSKIP" );

   if( iToSkip > 0 )
   {
       while( iToSkip > 0 )
       {
           // SKIP( 1 );
           _PutSym( DBSkipSym );
           (++_tos)->wType = 0;
           _PutLN( 1 );
           _xDo( 1 );

           __EOF();
           if( ( (PCLIPLOG)_tos-- )->wLogic )
           {
               DBGOBOTTOM();
               goto salida;

           }
           else
           {
              iSkipped++;
              iToSkip--;
           }
       }

   }
   else
   {
       while( iToSkip < 0 )
       {
           // SKIP( -1 );
           _PutSym( DBSkipSym );
           (++_tos)->wType = 0;
           _PutLN( -1 );
           _xDo( 1 );

           __BOF();
           if( ( (PCLIPLOG)_tos-- )->wLogic )
              goto salida;

           else
           {
              iSkipped--;
              iToSkip++;
           }
       }

   }

   salida:

   _retni( iSkipped );

}
