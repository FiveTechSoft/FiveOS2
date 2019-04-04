
#ifndef __FWARRAY_H
#define __FWARRAY_H

#ifdef __cplusplus
 extern "C" {
#endif


typedef struct
{
    WORD    wSize;
    WORD    wChunk;
    WORD    wItemCount;
    WORD    wItemSize;
    BYTE    pList[];
}  FWARRAY;


typedef FWARRAY far * LPFWARRAY;

typedef void * HFWARRAY;

typedef BOOL ( far * FWARRAYCALLBACK )( LPVOID );

//------------------- Protos -----------------------

HFWARRAY fwArrayNew( WORD wItemSize, WORD wInitLen );

WORD fwArrayAdd( HFWARRAY hList, LPVOID pVal );              // -> wNewLen

WORD fwArrayDel( HFWARRAY hList, WORD wIndex );              // -> wNewLen

WORD fwArrayIns( HFWARRAY hList, WORD wIndex, LPVOID pVal ); // -> wNewLen
void fwArraySet( HFWARRAY hList, WORD wIndex, LPVOID pVal );
void fwArrayGet( HFWARRAY hList, WORD wIndex, LPVOID pVal ); // -> valor en lo apuntado por pVal
void fwArrayFree( HFWARRAY hList );
LPVOID fwArrayLock( HFWARRAY hList );   // -> pointer to data array. Increases one the lockCount
void fwArrayUnlock( HFWARRAY hList );   // decremet one the lockCount.
WORD fwArraySize( HFWARRAY hList, WORD wNewSize ); // -> wNewSize
WORD fwArrayLen( HFWARRAY hList );                 // -> TheArraySize


/* Esta es la mas chula.

   Se llama a la funcion CallBack segun indiquen wInit  y wCount y mientras
   la funci¢n callback devuelva FALSE;

      si wInit es cero se empieza por el Primero ( 1 )
      si wCount es 0 se evaluan wCount elemento.

   La funci¢n CallBack recibe un puntero valido al dato.

   Est  chupado montarse busquedas y todo tipo de peliculas...

   Devuelve 0 si hubo errores ¢ si se recorri¢ el array hasta wCount

   si es distinto de cero es indice al £ltimo iTem evaluado, o sea: la
   funci¢n CallBack forz¢ la salida devolviendo TRUE;

*/

WORD fwArrayTraverse( HFWARRAY hList, FWARRAYCALLBACK pFunc,
                      WORD wInit, WORD wCount );

#ifdef __cplusplus
}
#endif

#endif // __FWARRAY_H

