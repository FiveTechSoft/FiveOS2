#include <OS2Ten.h>
#define INCL_GPIBITMAPS
#include <os2.h>
#include <ClipApi.h>

/*********************************************************************
*
*  WEEDBED_TEXT -> _Weed_eatr()
*
*********************************************************************/

 typedef void ( REGNAME )( PCLIPNAME );

 typedef struct
 {
     PCLIPNAME pNamesTable;
     WORD      wTableLen;
     WORD      wDummy;
 } SYMPITEM;

 extern SYMPITEM near __sympb;
 extern SYMPITEM near __sympe;

 WORD _Weed_eatr( REGNAME far * pRegFunc );

// Devuelve el N§ de Items en la tabla de simbolos de Clipper.
// si recibe un puntero no nulo, llama al puntero recibido pasandole
// cada simbolo de la tabla

//---------------------------------------------------------------------------//

WORD _Weed_eatr( REGNAME far * pRegFunc )
{
     SYMPITEM * pSymTable = &__sympb;
     WORD wCount          = 0;
     WORD wLen;
     WORD wItem;

     do
     {
         wLen = pSymTable->wTableLen / sizeof( CLIPNAME );

         for( wItem = 0; wItem < wLen; wItem++ )
             if( pRegFunc )
                 ( pRegFunc )( pSymTable->pNamesTable + wItem );


         wCount += wLen;

     } while( ++pSymTable < &__sympe );

     return wCount;

}


//---------------------------------------------------------------------------//

extern CLIPNAME far _Start_Sym;
extern CLIPNAME far _WeedBed;

PCLIPNAME _Start_Proc( void )
{
    return &_Start_Sym && _Start_Sym.cName[ 0 ] & 0xFF
           ? &_Start_Sym
           : &_WeedBed + 1;
}

