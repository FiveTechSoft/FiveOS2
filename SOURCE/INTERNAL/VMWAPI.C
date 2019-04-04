#include <ClipApi.h>
#include <dos.h>

typedef void far * FARP;
typedef FARP  PFAR;

typedef struct
{
    WORD wcLock;
    WORD wBytes;
    WORD wIsHeap;
    WORD dummy[ 5 ];
} OMEM;

typedef OMEM far * LPOMEM;

typedef struct
{
   WORD    dummy[ 3 ];
} OVM;

typedef OVM far * POVM;
typedef POVM OVMP;

    extern FARP _vmPtr( OVMP );              // FARP to allocated virtual memory.
    extern WORD _vmRealloc( OVMP, WORD wNewSizeInKBytes );
    extern WORD _memSubExtent( LPOMEM );
    extern void _vmFree( OVMP );       // Free allocated virtual memory.
    extern OVMP _vmAlloc( WORD wKBytes );
    extern void _memSubFree( LPOMEM, WORD );
    extern WORD _memSubAlloc( LPOMEM, WORD );
    extern FARP _vmLock( OVMP );  // Nueva de ClIPPER 5.2
    extern WORD _v16( OVMP );          // -> WORD Handle
    extern OVMP _v32( WORD wHandle );  // -> OVMP
    extern WORD _memSubReinit( LPOMEM, WORD );
    extern WORD _memSubInit( LPOMEM, WORD );
    extern void _vmUnLock( OVMP );     // desbloquea tanto al Fixed como al Locked...


WORD _xvAlloc( WORD wBytes ) //  ( WORD wBytes, WORD wFlags )
{
    WORD     wSize = ( ( wBytes + sizeof( OMEM ) ) / 1024 ) + 1;
    OVMP     oVM   = _vmAlloc( wSize );
    LPOMEM  oMem = (LPOMEM) _vmPtr( oVM );

    oMem->wcLock  = 0;
    oMem->wBytes  = wBytes;
    oMem->wIsHeap = 0;

    return _v16( oVM );
}

void _xvFree( WORD wHandle )
{
    OVMP  oVM = _v32( wHandle );

    if( oVM )
        _vmFree( oVM );
}

WORD _xvRealloc( WORD wHandle, WORD wBytes )
{
    OVMP     oVM = _v32( wHandle );
    WORD     wSize;
    LPOMEM  oMem;

    if( oVM )
    {
        wSize = ( ( wBytes + sizeof( OMEM ) ) / 1024 ) + 1;

        if( ! _vmRealloc( oVM, wSize ) )
        {
            oMem = (LPOMEM) _vmPtr( oVM );
            oMem->wBytes = wBytes;
        }
        else
            wHandle = 0;

        return wHandle;
    }

    return 0;
}


FARP _xvLock( WORD wHandle )
{

    OVMP     oVM = _v32( wHandle );
    LPOMEM  oMem;

    if( oVM )
    {
        oMem = (LPOMEM) _vmLock( oVM );

        if( oMem )
        {
            ++oMem->wcLock;
            return (FARP) ( oMem + 1 );
        }
    }

    return 0;
}

FARP _xvWire( WORD wHandle )
{
    return _xvLock( wHandle );
}

void _xvUnLock( WORD wHandle )
{
    OVMP     oVM = _v32( wHandle );
    LPOMEM  oMem;

    if( oVM )
    {
        oMem = (LPOMEM) _vmPtr( oVM );

        if( oMem->wcLock )
            if( --oMem->wcLock == 0 )
                  _vmUnLock( oVM );

    }
}

void _xvUnWire( WORD wHandle )
{
     _xvUnLock( wHandle );
}

WORD _xvLockCount( WORD wHandle )
{
    OVMP     oVM = _v32( wHandle );

    if( oVM )
    {
        return ( (LPOMEM) _vmPtr( oVM ) )->wcLock;
    }

    return 0;

}

WORD _xvSize( WORD wHandle )
{
    OVMP     oVM = _v32( wHandle );

    if( oVM )
    {
        return ( (LPOMEM) _vmPtr( oVM ) )->wBytes;
    }

    return 0;

}

WORD _xvHeapNew( WORD wBytes )
{
    WORD wHandle = _xvAlloc( wBytes );
    LPOMEM  oMem;

    if( wHandle )
    {
        oMem = _vmPtr( _v32( wHandle ) );

        if( ! _memSubInit( oMem + 1, wBytes ) )
        {
            oMem->wIsHeap = 1;
        }
        else
        {
            _xvFree( wHandle );
            wHandle = 0;
        }
    }

    return wHandle;

}

void _xvHeapDestroy( WORD wHandle )
{
    _xvFree( wHandle );
}


WORD _xvHeapResize( WORD wHandle, WORD wBytes )
{
    OVMP     oVM = _v32( wHandle );
    LPOMEM  oMem;
    WORD     wResize = 0;

    if( oVM )
    {
        oMem = (LPOMEM) _vmPtr( oVM );

        wResize = ( oMem->wIsHeap && _memSubExtent( oMem + 1 ) <= wBytes  ? 1 : 0 );
    }

    if( wResize )
    {
        if( oMem->wBytes <= wBytes )
        {
            wHandle = _xvRealloc( wHandle, wBytes );

            if( wHandle )
            {
                oMem = (LPOMEM) _vmPtr( oVM );

                if( _memSubReinit( oMem + 1, wBytes ) )
                    wHandle = 0;
            }

        }
        else
        {
            if( ! _memSubReinit( oMem + 1, wBytes ) )
                wHandle = _xvRealloc( wHandle, wBytes );
            else
                wHandle = 0;
        }

    }
    else
        wHandle = 0;

    return wHandle;
}

WORD _xvHeapAlloc( WORD wHandle, WORD wBytes )
{
    OVMP     oVM = _v32( wHandle );
    LPOMEM  oMem;

    if( oVM )
    {
        oMem = (LPOMEM) _vmPtr( oVM );

        if( oMem->wIsHeap )
            return _memSubAlloc( oMem + 1, wBytes ) - sizeof( OMEM );
                                                // Bug PATH/NTX 03/03/94
    }

    return 0;
}

void _xvHeapFree( WORD wHandle, WORD wOffSet )
{
    OVMP     oVM = _v32( wHandle );
    LPOMEM  oMem;

    if( oVM )
    {
        oMem = (LPOMEM) _vmPtr( oVM );

        if( oMem->wIsHeap )
            _memSubFree( oMem + 1, wOffSet );
    }
}

FARP _xvHeapLock( WORD wHandle, WORD wOffSet )
{
    FARP   fpRet = 0;
    OVMP     oVM = _v32( wHandle );
    LPOMEM oMem;

    if( oVM )
    {
        oMem = (LPOMEM) _vmPtr( oVM );

        if( oMem->wIsHeap && wOffSet && oMem->wBytes > wOffSet )
        {
            fpRet = (FARP) ( (LPBYTE) _xvLock( wHandle ) + wOffSet );
        }
    }

    return (FARP) fpRet;
}

void _xvHeapUnLock( WORD wHandle, WORD wOffSet )
{
    OVMP   oVM = _v32( wHandle );
    LPOMEM oMem;

    if( oVM )
    {
        oMem = (LPOMEM) _vmPtr( oVM );

        if( oMem->wIsHeap && wOffSet && oMem->wBytes > wOffSet )
        {
            _xvUnLock( wHandle );
        }
    }
}

/***********   Compatibilizaciones con CL 5.01 *****************/

void _vAlloc()
{
     asm call far ptr _xvAlloc;
}
void _vFree()
{
    asm call far ptr _xvFree;
}
void _vRealloc()
{
    asm call far ptr _xvRealloc;
}
void _vLock()
{
    asm call far ptr _xvLock;
}
void _vWire()
{
    asm call far ptr _xvLock;
}
void _vUnLock()
{
    asm call far ptr _xvUnLock;
}
void _vUnWire()
{
     asm call far ptr _xvUnLock;
}
void _vLockCount()
{
    asm call far ptr _xvLockCount;
}
void _vSize()
{
    asm call far ptr _xvSize;
}

/******************
         Estas no las tiene "vmapiy" de cl 5.2  pero nosotros
         podriamos ponerlas.
*******************/


/****
void _vHeapNew()
{
    asm call far ptr _xvHeapNew;
}
void _vHeapDestroy()
{
    asm call far ptr _xvFree;
}
void _vHeapResize()
{
    asm call far ptr _xvHeapResize;
}
void _vHeapAlloc()
{
    asm call far ptr _xvHeapAlloc;
}
void _vHeapFree()
{
    asm call far ptr _xvHeapFree;
}
void _vHeapLock()
{
    asm call far ptr _xvHeapLock;
}
void _vHeapUnLock()
{
    asm call far ptr _xvHeapUnLock;
}
*****/
