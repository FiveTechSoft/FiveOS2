#include <OS2Ten.h>

#define INCL_DOSMEMMGR
#define INCL_GPIBITMAPS
#include <os2.h>

#include <ClipApi.h>

typedef void far * FARP;
typedef FARP  PFAR;

// los objetos de memoria de M¢dulo om. Se obtienen con _vmAllocO()
typedef struct
{
   WORD    wSelector;

   BYTE    bKBytes;
   BYTE    bOMFlgs;

   SEL wDiskioId;

} OVM;

typedef OVM far * POVM;
typedef POVM OVMP;

#define  VM_FIXED        0x80
#define  VM_HANDLE       0x8000
#define  VM_DISKIO       0x7FFF  // si es un objeto para Diskio, _vmAllocD():
                                 // VM_HANDLE & oVM->wDiskioId -> FALSE
                                 // VM_DISKIO & oVM->wDiskioId -> wDiskioId

                                 // si no es un _vmAlloc() ¢ _vmAllocF():
                                 // VM_HANDLE & oVM->wDiskioId -> TRUE
                                 // VM_DISKIO & oVM->wDiskioId -> wHandle

                                 // los objetos de _vmAllocO son del array
                                 // static (OVM*) _OSegs y por tanto no tienen
                                 // variable wDiskioId.



#define EVE_TERMINA      0x510C   // ¨ despues de que syslevel sea 0 ?
#define EVE_SYSDOWN      0x510B   // una por bajada de syslevel.
#define EVE_TERMINA_INI  0x510A   // antes de las ventanas alert no se si siempre
                                  // un alt_c lo provoca tambi‚n.
#define EVE_INKEY_IDLE   0x5108   // siempre que el buffer est  vac¡o en inkey().
#define EVE_CYCLE_F      0x6004   // llamar a CycleF desde vmEventHandler.

 SEL fwGlobalAlloc( WORD, LONG );
 SEL fwGlobalReAlloc( SEL, LONG lSize , WORD Flags );

 void _vmPreAlloc( void ); // ¨ Unknow ? La usan la Construci¢n de
                           // indices (DBFNTX.LIB) y no pasa nada.

 OVMP _vmAlloc( WORD wKBytes );


 OVMP _vmAllocO( WORD wOMIndex, WORD wKBytes ); // wOMIndex
                                                // es un indice al
                                                // array OVMP _OSegs

 OVMP _vmAllocF( WORD wKBytes ); // ????
                                       // Es llamada por las funciones
                                       // del m¢dulo "Alloc" _xalloc()


 OVMP _vmAllocD( WORD wKBytes );       // pone flag 20h y
                                       // Disk > 0.
                                       // Es llamada por las funciones del
                                       // m¢dulo "diskio" allocatea buffers
                                       // que luego ser n usados para i/o
                                       // de disco.

 FARP _vmDirtyPtr( OVMP );       // FARP to allocated virtual memory.

 FARP _vmPtr( OVMP );            // FARP to allocated virtual memory.

 FARP _vmTwo( OVMP, OVMP );   // Carga y pone en preserve los dos punteros
                              // Devuelve el puntero a mem del primer objeto.

 void _vmXchg( OVMP, OVMP );  // Carga e intercambia los objetos de memoria
                              // Poniendo los dos en preserve.

 WORD _vmSize( OVMP );       // -> WORD wAllocatedKBytes.

 void _vmDiscard( OVMP );    // UnLock allocated virtual memory. Not Free Object
 void _vmFree( OVMP );       // Free allocated virtual memory.


WORD _vmRealloc( OVMP, WORD wNewSizeInKBytes );

 
 FARP _vmLock( OVMP );       // FARP to allocated virtual memory.
 FARP _vmFix( OVMP );        // FARP to allocated virtual memory.

 FARP _vmLockOvl( OVMP );   // ¨¨¨¨¨ ??????

 void _vmUnlock( OVMP );     // desbloquea tanto al Fixed como al Locked...

 void _vmUnlockOvl( OVMP );  // c¢digo identico a _vmUnlock.
 void _vmPendingOvl( OVMP ); // c¢digo identico a _vmUnlock.

 WORD  _v16( OVMP );          // -> WORD Handle
 OVMP _v32( WORD wHandle );  // -> OVMP

 void _efault( void );

 void _vmXfr( void );

 void _mem_resume( void );   // ¨ ret y parms ?   Tiene algo que ver con el RUN program...
 void _mem_suspend( void );  // ¨ ret y parms ?   idem

 void _vmAdd( void );  // ­ No nos hace falta !


 FARP DSNormal( WORD vPointer );  // Devuelve puntero largo de DS, a partir
                                   // de uno corto con el
                                   // offset <= 0x000F

 WORD _mem_exit( WORD );  // debe liberar toda la memoria alocateada
                          // devuelve el mismo word que recibe sin hacer
                          // nada con ‚l.
 
 WORD _mem_init2( WORD ); // Registra el receptor de eventos del m¢dulo.
                          // devuelve el mismo word que recibe sin hacer
                          // nada con ‚l.

 WORD _mem_init( WORD );  // Inicia el sistema de memoria.
                          // devuelve el mismo word que recibe sin hacer
                          // nada con ‚l.


 

 WORD _vmStat( WORD );     // Devuelven diferentes c¢digos segun parm y estado
 WORD _vmStatn( WORD );    // de la vm.
 WORD _vmStatE( WORD );

 FARP _vmLockSeg( OVMP );  // Nueva de ClIPPER 5.2


extern WORD _osStackBase( void );
extern void _osAllocDefSeg( WORD*, WORD*,WORD* );
extern WORD _osAvail( void );   // N§ de parrafos disponibles.

extern void _CycleF( void );
extern void _ierror( WORD );
extern void _ShowErrMsg( void ); // en "\internal\outstdw.c"
extern void _ePStack( void );    // reventon de pila.
extern WORD _SysLevel( void );
extern CLIPPER __LowMemEr( void );   // en fwerror.prg

// extern PCLIPVAR _eval;
extern PCLIPVAR _evalhigh;
// extern PCLIPVAR _tos;
extern PCLIPVAR _eextent;
extern PCLIPVAR _estat;
extern PCLIPVAR _estatlow;
extern PCLIPVAR _eextent;
// extern PCLIPVAR _lbase;


extern void _fwFreeAllGlobals( void ); // en handlist.c
extern void _fwFreeAllLibrarys( void );


typedef void ( far * DISKIODROPFUNCP )( WORD );

 static WORD wDiskioError( void );
 static WORD near wKiloBytes( DWORD dwBytes );
 static DWORD near ulBytes( WORD wKBytes );
 static WORD near wScanEmpty( OVMP );
 static void ovmAddFix( OVMP oVM );
 static void ovmSubFix( OVMP oVM );
 static void LowMemError( void );
 static OVMP near ovmAlloc( OVMP oVM, WORD wKBytes );
 static OVMP near ovmNew( WORD wKBytes );
 static void near ovmFree( OVMP oVM );
 static void near ovmFreeAll( void );

 #define OVMNULL       { 0, 0, 0, 0 }
 #define _16OVMNULL    OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL, OVMNULL

 #define _OSEGS_LEN    0x200

 OVM _OSegs[ _OSEGS_LEN ] = {
                              _16OVMNULL, _16OVMNULL, _16OVMNULL, _16OVMNULL,
                              _16OVMNULL, _16OVMNULL, _16OVMNULL, _16OVMNULL,
                              _16OVMNULL, _16OVMNULL, _16OVMNULL, _16OVMNULL,
                              _16OVMNULL, _16OVMNULL, _16OVMNULL, _16OVMNULL,
                              _16OVMNULL, _16OVMNULL, _16OVMNULL, _16OVMNULL,
                              _16OVMNULL, _16OVMNULL, _16OVMNULL, _16OVMNULL,
                              _16OVMNULL, _16OVMNULL, _16OVMNULL, _16OVMNULL,
                              _16OVMNULL, _16OVMNULL, _16OVMNULL, _16OVMNULL
                            };

 static OVMP _dummy  = _OSegs;
 static OVMP _dummy2 = &_OSegs[ 0x100 ];

 DISKIODROPFUNCP _DiskioDrop = (DISKIODROPFUNCP) wDiskioError;
 WORD _stackbase = 0;
 WORD _stackslop = 0x0500;


 OVMP Preserve1;
 OVMP Preserve2;
 WORD ReceiverHandle;
 WORD SwapLowEventId;
 WORD OverlayTop;
 WORD OverlayLine;
 WORD OverlayLevel;
 WORD _memCount = 0;            // Nueva de ClIPPER 5.2

 static OVMP* aOSegs    = 0;    // array de arrays de OVM
 static WORD  wOSegsLen = 0;    // N§ de items de arrays de aOSegs. Max 128
                                // Cada array nuevo ser  capaz de contener
                                // 256 decim. OVM's

 #define OSEGS_ITEM_LEN   256   // Objetos OVM en decimal.
 #define OSEGS_ITEM_SIZE 1536   // 256 * sizeof( OVM ) bytes en decimal



 static SEL haOSegs = 0;

 static WORD _osDataSegment;
 static WORD _osDSegSize;       // Tama¤o en parrafos del DataSegment.
 static WORD _osABrkTb;         //
 static WORD _osAvailable;      // tama¤o en parrafos de la la memoria OS
                                // disponible.

 #define MY_ALLOC_ITEMS   4

 static WORD MyAllocSegs[ MY_ALLOC_ITEMS ] = { 0,0,0,0 };
                              // Ser n puestos de momento por _vmAllocDos
                              // y liberados por _mem_exit().

 static WORD ovmFixedHeap  = 0;   // N§ de KBytes Fixed.

 static WORD ovmTotalAlloc = 0;   // N§ de KBytes Fixed.

 #define CHUNK   16               // incrementos de aOSegs...


//---------------------------------------------------------------------------//

static void DoLowMemError( void )
{
    _PutSym( _Get_Sym( "__LowMemEr" ) );
    ( ++_tos )->wType = 0;
    _xDo( 0 );
}
//---------------------------------------------------------------------------//

SEL fwGlobalAlloc( WORD wFlags, LONG lBytes )
{
    SEL hMem = 0;

    if( DosAllocSeg( (WORD) lBytes, &hMem, 0 ) )
        LowMemError();

    // set them to 0 !!!

    _bset( MAKEP( hMem, 0 ), 0, (WORD) lBytes );

    return hMem;
}

//---------------------------------------------------------------------------//

SEL fwGlobalReAlloc( SEL hMem, LONG lSize , WORD wFlags )
{
    ULONG lOldSize;

    DosSizeSeg( hMem, &lOldSize );

    if( DosReallocSeg( lSize, hMem ) )
        LowMemError();

    // set only the difference to 0 !!!

    if( lSize > lOldSize )
       _bset( MAKEP( hMem, lOldSize ), 0, lSize - lOldSize );

    return hMem;
}

//---------------------------------------------------------------------------//

// Cuando se llama a ( _DiskioDrop )() antes de que se inicie el m¢dulo
// diskio
static WORD wDiskioError()
{
    _ierror( 0x1464 );
    return 1;
}

//---------------------------------------------------------------------------//

static WORD near wKiloBytes( DWORD ulBytes )
{
    WORD wLow  = LOUSHORT( (ULONG) ulBytes ) >> 10;
    WORD wHigh = HIUSHORT( (ULONG) ulBytes );

    return wLow + wHigh * 64;
}

//---------------------------------------------------------------------------//

static DWORD near ulBytes( WORD wKBytes )
{
    if( wKBytes < 64 )
        return ( wKBytes << 10 );

    else if( wKBytes == 64 )
        return 0x10000;

    return 0;
}

//---------------------------------------------------------------------------//

static BOOL near bIsOmObject( OVMP oVM )
{
     return ( SELECTOROF( _OSegs ) == SELECTOROF( oVM ) );
}

//---------------------------------------------------------------------------//

static BOOL near bIsDiskioObject( OVMP oVM )
{
    return ( !bIsOmObject( oVM ) && !( oVM->wDiskioId & VM_HANDLE ) );
}

//---------------------------------------------------------------------------//

static WORD near wScanEmpty( OVMP oSegsItem )
{
    WORD wIndex = 0;

    for( wIndex = 0; wIndex < OSEGS_ITEM_LEN; wIndex++ )
    {
         if( oSegsItem[ wIndex ].wSelector == 0 )
             return wIndex + 1;
    }

    return 0;
}

//---------------------------------------------------------------------------//

static void ovmAddFix( OVMP oVM )
{
    if( !( oVM->bOMFlgs & VM_FIXED ) )
    {
        ovmFixedHeap += oVM->bKBytes;
        oVM->bOMFlgs |= VM_FIXED;
    }
}

//---------------------------------------------------------------------------//

static void ovmSubFix( OVMP oVM )
{
    if( oVM->bOMFlgs & VM_FIXED )
    {
        if( ovmFixedHeap >= oVM->bKBytes )
            ovmFixedHeap -= oVM->bKBytes;
        else
            ovmFixedHeap = 0;

        oVM->bOMFlgs &= 0x7F;
    }
}

//---------------------------------------------------------------------------//

static void LowMemError( void )
{
    // el famoso "Memory Low", si no hay memoria suficiente.
    /*
    if( SwapLowEventId )
        _evSendId( SwapLowEventId, ReceiverHandle );
        //_evPostId( SwapLowEventId, ReceiverHandle );
    */

    _ierror( 5300 ); // "Not Enought Memory"
}

//---------------------------------------------------------------------------//

static OVMP near ovmAlloc( OVMP oVM, WORD wKBytes )
{
   oVM->wSelector = fwGlobalAlloc( 0, ulBytes( wKBytes ) );
   oVM->bKBytes   = (BYTE) wKBytes;
   oVM->bOMFlgs   = 0;
   oVM->wDiskioId = 0;
    
   return oVM;
}

//---------------------------------------------------------------------------//

static OVMP near ovmNew( WORD wKBytes )
{
     WORD wIndex = 0;
     WORD wSubIndex = 0;
     SEL hTemp;

     if( !haOSegs )
     {
         haOSegs   = fwGlobalAlloc( 0, CHUNK * sizeof( OVMP ) );
         aOSegs    = (OVMP*) MAKEP( haOSegs, 0 );
         wOSegsLen = CHUNK;
     }


     while( !wSubIndex && wIndex < 0x007F )
     {
         if( !aOSegs[ wIndex ] )
         {
             hTemp = fwGlobalAlloc( 0, OSEGS_ITEM_SIZE );
             aOSegs[ wIndex ] = (OVMP) MAKEP( hTemp, 0 );

         }

         wSubIndex = wScanEmpty( aOSegs[ wIndex ] ); // OK > 0

         wIndex++;

         if( !wSubIndex && wIndex == wOSegsLen ) // Resize.
         {
             haOSegs = fwGlobalReAlloc( haOSegs,
                                      ( wOSegsLen + CHUNK ) * sizeof( OVMP ),
                                      0 );
             aOSegs    = (OVMP*) MAKEP( haOSegs, 0 );
             wOSegsLen += CHUNK;
             
         }

     }

     if( wSubIndex && wKBytes <= 64 )  // No WOVM's mayores de 64 KB's
     {
        OVMP oRet = &aOSegs[ --wIndex ][ --wSubIndex ];

        ovmAlloc( oRet, wKBytes );

        // si es un objeto para diskio ser  machacado
        // por vmAllocD. Esto es solo para que vmapi pueda usar las
        // funciones _v16() y _v32();

        oRet->wDiskioId = VM_HANDLE | ( ( wIndex << 8 ) | wSubIndex );

        return oRet;

     }
     else
        return (OVMP) 0;

}

//---------------------------------------------------------------------------//

static BOOL bHaySelector( OVMP oVM )
{
     if( oVM )
     {
        if( oVM->wSelector )
            return TRUE;
        else
            _ierror( 5333 );
     }

     return FALSE;
}

//---------------------------------------------------------------------------//

static void near ovmFree( OVMP oVM )
{
    SEL hTemp;

    ovmSubFix( oVM );

    if( oVM->wSelector )
        DosFreeSeg( oVM->wSelector );

    // Borra con ceros la estructura.
    _bset( (FARP) oVM, 0, sizeof( OVM ) );

}


//---------------------------------------------------------------------------//

/****
       Creo que al no desbloquear realmente ningun OVM no hace falta
       avisar al m¢dulo diskio de nada.

static void near PreservedDiscard( OVMP Preserved )
{
    if( Preserved && !( Preserved->bOMFlgs & VM_FIXED ) )
    {
        ovmDiscard( Preserved );

        if( bIsDiskioObject( Preserved ) )
            ( _DiskioDrop )( Preserved->wDiskioId );

    }

}
********************** */

//---------------------------------------------------------------------------//

static void near ovmFreeAll()
{
     WORD wIndex = 0;
     WORD wSubIndex = 0;
     SEL hTemp;

     for( wIndex = 0; wIndex < wOSegsLen ; wIndex++ )
     {
          if( aOSegs[ wIndex ] )
          {
              for( wSubIndex = 0; wSubIndex < OSEGS_ITEM_LEN; wSubIndex++ )
              {
                   ovmFree( &aOSegs[ wIndex ][ wSubIndex ] );
              }

              hTemp = SELECTOROF( aOSegs[ wIndex ] );

              DosFreeSeg( hTemp );

              aOSegs[ wIndex ] = 0;

          }
     }

     DosFreeSeg( haOSegs );
     haOSegs = 0;
     aOSegs  = 0;

     for( wIndex = 0; wIndex < _OSEGS_LEN; wIndex++ )
     {
          if( _OSegs[ wIndex ].wSelector )
          {
              ovmFree( (OVMP) &_OSegs[ wIndex ] );
          }

     }

}

//---------------------------------------------------------------------------//

OVMP _vmAlloc( WORD wKBytes )
{

    return ovmNew( wKBytes );

}

//---------------------------------------------------------------------------//

OVMP _vmAllocF( WORD wKBytes )
{

    return ovmNew( wKBytes );

}

//---------------------------------------------------------------------------//

OVMP _vmAllocD( WORD wDiskID )
{
    OVMP oRet = ovmNew( 1 );

    oRet->wDiskioId = wDiskID & VM_DISKIO;

    return oRet;

}

//---------------------------------------------------------------------------//

OVMP _vmAllocO( WORD wOSegsIndex, WORD wKBytes )
{
    if( wOSegsIndex < _OSEGS_LEN )
        return ovmAlloc( &_OSegs[ wOSegsIndex ], wKBytes );
    else
        _ierror( 1332 );
    return 0;

}

//---------------------------------------------------------------------------//

FARP _vmPtr( OVMP oVM )
{
     if( bHaySelector( oVM ) )
     {
         if( oVM->wSelector )
            return (FARP) MAKEP( oVM->wSelector, 0 );
         else
            _ierror( 1331 );
     }

     return (FARP) 0;

}

//---------------------------------------------------------------------------//

FARP _vmDirtyPtr( OVMP oVM )
{
     return _vmPtr( oVM );
}

//---------------------------------------------------------------------------//

FARP _vmTwo( OVMP oVM1, OVMP oVM2 )
{
     _vmPtr( oVM2 );

     return _vmPtr( oVM1 );
}

//---------------------------------------------------------------------------//

void _vmXchg( OVMP oVM1, OVMP oVM2 )
{
     OVM oTemp;

     _bcopy( (FARP) &oTemp, (FARP) oVM1  , sizeof( OVM ) );
     _bcopy( (FARP) oVM1  , (FARP) oVM2  , sizeof( OVM ) );
     _bcopy( (FARP) oVM2  , (FARP) &oTemp, sizeof( OVM ) );

}

//---------------------------------------------------------------------------//

WORD _vmSize( OVMP oVM )
{
    if( bHaySelector( oVM ) )
    {
        return (WORD) oVM->bKBytes;
    }
    else
        return 0;
}

//---------------------------------------------------------------------------//

void _vmDiscard( OVMP oVM )
{
    if( bHaySelector( oVM ) )
    {
        // GlobalUnlock( GlobalHandle( oVM->wSelector ) );
        DosUnlockSeg( oVM->wSelector );
    }

}

//---------------------------------------------------------------------------//

void _vmFree( OVMP oVM )
{
    if( bHaySelector( oVM ) )
        ovmFree( oVM );
}

//---------------------------------------------------------------------------//

WORD _vmRealloc( OVMP oVM, WORD wKBytes )
{
     SEL hTemp = 2;
     WORD wOldKBytes;
     ULONG lSize;

     if( bHaySelector( oVM ) )
     {
         wOldKBytes = _vmSize( oVM );

         if( wKBytes && wKBytes < 64 )
         {
             if( wOldKBytes == wKBytes )
                return FALSE;

             hTemp = fwGlobalReAlloc( oVM->wSelector,
                                      ulBytes( wKBytes ),
                                      0 );

             if( hTemp )
             {
                 if( oVM->bOMFlgs & VM_FIXED )
                 {
                     if( wKBytes > wOldKBytes )
                         ovmFixedHeap += wKBytes;
                     else
                         if( wOldKBytes - wKBytes <= ovmFixedHeap )
                             ovmFixedHeap -= ( wOldKBytes - wKBytes);
                 }

                 oVM->wSelector = hTemp;

                 DosSizeSeg( hTemp, &lSize );
                 oVM->bKBytes = lSize;

                 hTemp = FALSE;
             }
             else
                hTemp = 2;

         }
     }

     return hTemp;

}

//---------------------------------------------------------------------------//

FARP _vmLock( OVMP oVM )
{
     FARP oRet = _vmPtr( oVM );

     if( oRet )
         ovmAddFix( oVM );

     return oRet;
}


//---------------------------------------------------------------------------//


FARP _vmFix( OVMP oVM )            // FARP to allocated virtual memory.
{
     return _vmLock( oVM );

     
}

//---------------------------------------------------------------------------//

FARP _vmLockOvl( OVMP oVM )
{
     return _vmLock( oVM );
}

//---------------------------------------------------------------------------//

FARP _vmLockSeg( OVMP oVM )  // Nueva de ClIPPER 5.2
{
     return _vmLock( oVM );
}

//---------------------------------------------------------------------------//

void _vmUnlock( OVMP oVM )   // desbloquea objetos vm movibles.
{
     _vmDiscard( oVM );
     ovmSubFix( oVM );
}

//---------------------------------------------------------------------------//

void _vmUnlockOvl( OVMP oVM )
{
     _vmUnlock( oVM );
}

//---------------------------------------------------------------------------//

void _vmPendingOvl( OVMP oVM )
{
    _vmUnlock( oVM );
}

//---------------------------------------------------------------------------//

WORD _v16( OVMP oVM )    // -> WORD Handle
{
     if( !bIsOmObject( (OVMP) oVM ) && ( oVM->wDiskioId & VM_HANDLE ) )
         return oVM->wDiskioId;
     else
         return 0;
}

//---------------------------------------------------------------------------//

OVMP _v32( WORD wHandle )  // -> OVMP
{
     WORD wIndex;
     WORD wSubIndex;

     if( wHandle & VM_HANDLE )
     {
         wHandle  &= VM_DISKIO;
         wSubIndex = wHandle & 0x00FF;
         wIndex    = wHandle >> 8;

         return &aOSegs[ wIndex ][ wSubIndex ];

     }
     else
         return 0;
}

//---------------------------------------------------------------------------//

void _efault( void )
{
}
/*
        if( _tos >= _evalhigh && _estat <= _estatlow && _evalhigh <= (PCLIPVAR) 0xFF7F )
        {
            _evalhigh += 0x0080;

            if( _estatlow >= (PCLIPVAR) 0x0041 )
                _estatlow -= 0x0040;
            else
               _ierror( 0x29B );
        }
        else
            _ierror( 0x29B );

}
*/
//---------------------------------------------------------------------------//

// Funciones que no van a hacer nada

void _mem_suspend() { }
void _mem_resume()  { }
void _vmAdd()       { }
void _vmXfr()       { }

void _vmPreAlloc()  { }

//---------------------------------------------------------------------------//

FARP DSNormal( WORD vPointer )  // Devuelve puntero largo a partir
{                               // de uno corto con el
                                // offset <= 0x000F

     return MAKEP( _osDataSegment + ( vPointer / 16 ), vPointer & 0x000F );
}

//---------------------------------------------------------------------------//

WORD _mem_exit( WORD wTonto )
{
    WORD wIndex;

    ovmFreeAll();         // libera todos los OVM y los arrays que los soportan.
    _fwFreeAllGlobals();  // Libera handles globales a¤adidos a handlist.c
    _fwFreeAllLibrarys(); // Libera todas las DLL's.

    for( wIndex = 0; wIndex < MY_ALLOC_ITEMS; wIndex++ )
    {
         if( MyAllocSegs[ wIndex ] > 0 )
             DosFreeSeg( MyAllocSegs[ wIndex ] );
    }

    return wTonto;
}

//---------------------------------------------------------------------------//

static PCLIPFUNC aTerminators[ 10 ] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

void _fwAddTerminator( PCLIPFUNC pFunc )
{
    WORD wIndex = 0;
    if( pFunc )
    {
        while( wIndex < 10 && !( aTerminators[ wIndex ] == 0 ) )
               wIndex++;

        if( wIndex < 10 )
            aTerminators[ wIndex ] = pFunc;
    }
}

//---------------------------------------------------------------------------//
/* el asunto de los eventos es aparentemente simple, solo debemos atender
   el evento 0x6004 llamando a  void _CycleF( void )
*/
static WORD _vmEventHandler( EVENT* Evento )
{

     if( Evento->wMessage == EVE_CYCLE_F )
         _CycleF();

     else if( Evento->wMessage == EVE_TERMINA )
     {
          WORD wIndex = 0;
          while( wIndex < 10 && !( aTerminators[ wIndex ] == 0 ) )
              ( aTerminators[ wIndex++ ] )();
     }

     return 0;
}

//---------------------------------------------------------------------------//

WORD _mem_init2( WORD wTonto )
{
     // No nos hace falta de momento.
     // SwapLowEventId = _evRegType( (DWORD)0, (DWORD)0, 0x5000 );

     ReceiverHandle = _evRegReceiverFunc( (EVENTFUNCP) _vmEventHandler,
                                          0x6001 );
     return wTonto;
}

//---------------------------------------------------------------------------//

WORD _mem_init( WORD wTonto )
{  
    _bset( (FARP) _OSegs, 0, _OSEGS_LEN * sizeof( OVM ) );

    _stackbase = _osStackBase();

    _osAllocDefSeg( &_osDataSegment, &_osDSegSize, &_osABrkTb );

    _osAvailable = _osAvail();

    _eval = ( _evalhigh = ( _tos = (PCLIPVAR) _osABrkTb ) );

    _eextent = _eval + ( ( _osDSegSize - _osABrkTb ) / sizeof( CLIPVAR ) );
    _estat = ( _estatlow = _eextent );

    _efault();

    _tos->wType = 0;
    _lbase = _tos;

    return wTonto;

}

//---------------------------------------------------------------------------//

// Bufff las £ltimas...
WORD _vmStat( WORD wOption )
{
     WORD wRet;
     ULONG lSize;

     switch( wOption )
     {
                // Memoria Libre Convencional
        case 1:
                DosMemAvail( &lSize );
                wRet = wKiloBytes( lSize );

                if( wRet > 422 )
                   wRet = 422;   // Clipper OM no admite valores superiores

                if( wRet < 64 )
                    DoLowMemError();
                break;


                // Memoria Convencional no alocateada. ¨ ponemos Conv. Libre ?
        case 2:
                DosMemAvail( &lSize );
                wRet = wKiloBytes( lSize );

                if( wRet < 64 )
                    DoLowMemError();
                break;

                 // Memoria Expandida disponible:
        // case 4:
        //        wRet = 0;
        //        break;

                 // Allocated Fixed Heap Total de _vmAllocF();
        case 6:
                wRet = ovmFixedHeap;
                break;

                 // Mayor bloque continuo para cadenas.
        case 8:
                DosMemAvail( &lSize );
                wRet = wKiloBytes( lSize );

                if( wRet >= 64 )
                    wRet = 64;
                else
                    DoLowMemError();

                break;

        default:
                wRet = 0;

     }

     return wRet;

}

//---------------------------------------------------------------------------//

WORD _vmStatE( WORD wTonto )
{
     wTonto = 0;
     return wTonto; // solo para no ver el "Warning" de bcc.exe
}

//---------------------------------------------------------------------------//

void pascal _vmIdle()
{
     _evSendId( EVE_INKEY_IDLE, 0xFFFF );
     // _evSendId( 0x4103, 0xFFFF );
}

//---------------------------------------------------------------------------//

WORD _vmStatN( WORD wKBytes )
{
    return _vmStat( 8 ) / wKBytes;
}

/********** cosas de las _vmStat...

 WORD _vmStat( WORD )

 _vmStat( 1 ) -> Memoria libre convencional en KB.    ser  _osAvailable ¢
                 GetFreeSpace( 0 ) / 1024;

 _vmStat( 2 ) -> Memoria real que usa el VM. Suma de todos los segmentos
                 incuidos los de uso del propio m¢dulo.

 _vmStat( 4 ) -> Memoria Expandida disponible -> 0 KB.

 _vmStat( 6 ) -> Segmentos usados por la VMM. ¨ Suma de KB de los segmentos
                 fijos y de los bloqueados ?

 _vmStat( 8 ) -> Memoria para bloques de Caracteres. Supongo que ser  el
                 tama¤o del Mayor bloque continuo libre. Nunca devolveremos
                 un valor que sea mayor que 64 Kb.  As¡ nadie nos pedir 
                 un OVM de mas de 64 Kb.

 _vmStat( > 8 ) -> 0;


 // solo son usadas por el dichoso m¢dulo sortof
 WORD _vmStatE( WORD );

 _vmStatE() -> 0; // Creo que devuelve tama¤o de mayor bloque continuo de
                  // memoria Expandida. NOSOTROS DEVOLVEMOS 0;

 WORD _vmStatN( WORD )

 _vmStatn()       // Parece que recibe KBytes Requeridos y devuelve N§ maximo
                  // de veces que pueden ser allocateados en el mayor bloque
                  // libre contiguo.

************************/
//
//
//
//
//
//---------------------------------------------------------------------------//

WORD _vmAllocDos( WORD wBytes )
{
     WORD wSelector = fwGlobalAlloc( 0, wBytes );
     WORD wIndex    = 0;

     while( wIndex < MY_ALLOC_ITEMS && MyAllocSegs[ wIndex ] > 0 )
            wIndex++;

     if( wSelector && wIndex < MY_ALLOC_ITEMS )
     {
         MyAllocSegs[ wIndex ] = wSelector;
     }

     return wSelector;

}

//---------------------------------------------------------------------------//

BOOL TestStackOverflow( void )
{
    if( _SP <= _stackbase + _stackslop )
    {
        if( _stackslop )
        {
            _stackslop = 0;
            _ePStack();
        }
        return TRUE;
    }

    return FALSE;
}

//---------------------------------------------------------------------------//
