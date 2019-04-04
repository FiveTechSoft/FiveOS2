#include <OS2Ten.h>

#define INCL_DOSMEMMGR
#define INCL_GPIBITMAPS
#include <os2.h>

#include <ClipApi.h>
#include "FWArray.h"

extern void _bmove( LPBYTE pTarget, LPBYTE pSource, WORD wCount );

extern SEL fwGlobalAlloc( WORD, LONG );
extern SEL fwGlobalReAlloc( SEL, LONG lSize , WORD Flags );

//---------------------------------------------------------------------------//

static HFWARRAY near Size( HFWARRAY hList, WORD wItemCount )
{
    LPFWARRAY pArray   = (LPFWARRAY) MAKEP( hList, 0 );
    WORD      wNewSize;

    if( ! pArray )
        return 0;

    wNewSize = pArray->wItemSize * ( wItemCount + wItemCount % pArray->wChunk );

    if( wNewSize != pArray->wSize )           // ­ Crece ¢ reduce !
    {
        hList = fwGlobalReAlloc( hList, sizeof( FWARRAY ) + wNewSize, 0 );

        pArray   = (LPFWARRAY) MAKEP( hList, 0 );

        // A veces, GlobalRealloc no inicia con ceros la parte
        // nueva de un buffer increntado.
        if( wNewSize > pArray->wSize )
            _bset( pArray->pList + pArray->wSize, 0, wNewSize - pArray->wSize );

        pArray->wSize = wNewSize;
        pArray->wItemCount = wItemCount;

    }

    return hList;
}

//---------------------------------------------------------------------------//

static void near Set( HFWARRAY hList, WORD wItemIndex, LPVOID pVal )
{
    LPFWARRAY pArray   = (LPFWARRAY) MAKEP( hList, 0 );

    if( pArray && wItemIndex && wItemIndex <= pArray->wItemCount )
    {
        wItemIndex--;

        if( pArray->wItemSize == 2 )
            ( (LPWORD) pArray->pList )[ wItemIndex ] = *( (LPWORD) pVal );

        else if( pArray->wItemSize == 4 )
            ( (LPLONG) pArray->pList )[ wItemIndex ] = *( (LPLONG) pVal );

        else if( pArray->wItemSize == 1 )
            pArray->pList[ wItemIndex ] = *( (LPBYTE) pVal );

        else
            _bcopy( (LPBYTE) pArray->pList + ( wItemIndex * pArray->wItemSize ),
                    (LPBYTE) pVal,
                    pArray->wItemSize );
    }
    // else -> error "array access"

}

//---------------------------------------------------------------------------//

static void near Get( HFWARRAY hList, WORD wItemIndex, LPVOID pVal )
{
    LPFWARRAY pArray   = (LPFWARRAY) MAKEP( hList, 0 );

    if( pArray && wItemIndex && wItemIndex <= pArray->wItemCount )
    {
        wItemIndex--;

        if( pArray->wItemSize == 2 )
            *( (LPWORD) pVal ) = ( (LPWORD) pArray->pList )[ wItemIndex ];

        else if( pArray->wItemSize == 4 )
            *( (LPLONG) pVal ) = ( (LPLONG) pArray->pList )[ wItemIndex ];

        else if( pArray->wItemSize == 1 )
            *( (LPBYTE) pVal ) =  pArray->pList[ wItemIndex ];

        else
            _bcopy( (LPBYTE) pVal,
                    (LPBYTE) pArray->pList + ( wItemIndex * pArray->wItemSize ),
                    pArray->wItemSize );
    }
    // else -> error "array access"

}

//---------------------------------------------------------------------------//

HFWARRAY fwArrayNew( WORD wItemSize, WORD wInitLen )
{
    HFWARRAY  hList = 0;
    LPFWARRAY pArray;
    WORD      wChunk = 0;
    WORD      wSize;

    if( ! wItemSize )
        wItemSize = 2;         // Tama¤o de WORD por defecto.

    if( wItemSize < 33 )
        wChunk = 128 / wItemSize;
    else if( wItemSize < 129 )
        wChunk = 512 / wItemSize;

    if( wChunk < 2 )
        wChunk = 2;

    wSize    = wChunk * wItemSize;

    if( wInitLen * wItemSize > wSize )
        wSize = wInitLen * wItemSize;

    hList    = fwGlobalAlloc( 0, sizeof( FWARRAY ) + wSize );
    pArray   = (LPFWARRAY) MAKEP( hList, 0 );

    pArray->wSize      = wSize;
    pArray->wChunk     = wChunk;
    pArray->wItemSize  = wItemSize;
    pArray->wItemCount = 0;

    return hList;

}

//---------------------------------------------------------------------------//

static WORD Grow( HFWARRAY hList, WORD wItemsToAdd )
{
    WORD wItemCount = 0;

    if( hList )
    {

        LPFWARRAY pArray = (LPFWARRAY) MAKEP( hList, 0 );

        wItemCount  = pArray->wItemCount + wItemsToAdd;

        Size( hList, wItemCount );

    }

    return wItemCount;

}

//---------------------------------------------------------------------------//

WORD fwArrayAdd( HFWARRAY hList, LPVOID pVal )
{
    WORD wItemCount = Grow( hList, 1 );

    if( wItemCount )
        Set( hList, wItemCount, pVal );

    return wItemCount;
}

//---------------------------------------------------------------------------//


WORD fwArrayDel( HFWARRAY hList, WORD wIndex )
{
    LPFWARRAY pArray;
    LPBYTE    pList;
    WORD      wItemCount = 0;

    if( hList && wIndex )
    {

        pArray = (LPFWARRAY) MAKEP( hList, 0 );

        if( pArray->wItemCount )
        {
            if( wItemCount > wIndex )
            {
                pList  = (LPBYTE) pArray->pList + wIndex * pArray->wItemSize;

                _bmove( pList - pArray->wItemSize,
                        pList,
                        ( wItemCount - wIndex ) * pArray->wItemSize );

            }

            Size( hList, --wItemCount );
        }

    }

    return wItemCount;
}

//---------------------------------------------------------------------------//

WORD fwArrayIns( HFWARRAY hList, WORD wIndex, LPVOID pVal )
{
    LPFWARRAY pArray;
    LPBYTE    pList;
    WORD      wItemCount = 0;

    if( hList && wIndex && pVal )
    {
        wItemCount  = Grow( hList, 1 );

        if( wItemCount > wIndex )
        {
            pArray = (LPFWARRAY) MAKEP( hList, 0 );
            pList  = (LPBYTE) pArray->pList + wIndex * pArray->wItemSize;

            _bcopy( pList,
                    pList - pArray->wItemSize,
                    ( wItemCount - wIndex ) * pArray->wItemSize );

            Set( hList, wIndex, pVal );

        }
    }

    return wItemCount;
}

//---------------------------------------------------------------------------//

void fwArraySet( HFWARRAY hList, WORD wIndex, LPVOID pVal )
{
    Set( hList, wIndex, pVal );
}

//---------------------------------------------------------------------------//

void fwArrayGet( HFWARRAY hList, WORD wIndex, LPVOID pVal )
{
    Get( hList, wIndex, pVal );
}

//---------------------------------------------------------------------------//

void fwArrayFree( HFWARRAY hList )
{
    if( hList )
    {
        DosFreeSeg( hList );
    }
}

//---------------------------------------------------------------------------//

LPVOID fwArrayLock( HFWARRAY hList )
{
    return MAKEP( hList, 0 );
}

//---------------------------------------------------------------------------//

void fwArrayUnlock( HFWARRAY hList )
{
}

//---------------------------------------------------------------------------//

WORD fwArraySize( HFWARRAY hList, WORD wNewSize )
{
     if( hList && Size( hList, wNewSize ) )
         return wNewSize;
     else
         return 0;
}

//---------------------------------------------------------------------------//

WORD fwArrayLen( HFWARRAY hList )
{
    return ( hList ? ( (LPFWARRAY) MAKEP( hList, 0 ) )->wItemCount : 0 );
}

//---------------------------------------------------------------------------//

WORD fwArrayTraverse( HFWARRAY hList, FWARRAYCALLBACK pFunc,
                      WORD wInit, WORD wCount )
{
    WORD wIndex = 0;
    if( hList && pFunc )
    {
        LPFWARRAY pArray = (LPFWARRAY) MAKEP( hList, 0 );

        if( pArray )
        {
            BOOL bEnd       = FALSE;
            WORD wItemCount = pArray->wItemCount;
            WORD wItemSize  = pArray->wItemSize;
            if( wInit )
                --wInit;
            wIndex = wItemCount - wInit;
            wCount = wCount ? ( wCount <= wIndex ? wCount : wIndex ) : wIndex;
            wCount += wInit;

            wIndex = wInit;

            while( wIndex < wCount && !bEnd )
            {
                 bEnd = ( pFunc )( pArray->pList + wIndex * wItemSize );
                 wIndex++;
            }

            if( !bEnd )
                wIndex = 0;

        }

    }

    return wIndex;
}

//---------------------------------------------------------------------------//
static LONG lValScanned = 0;

static BOOL ScanWordCallBack( LPVOID pWord )
{
    return ( ( LPWORD ) pWord )[ 0 ] == (WORD) lValScanned;
}

static BOOL ScanLongCallBack( LPVOID pLong )
{
    return ( ( LPLONG ) pLong )[ 0 ] == lValScanned;
}

//---------------------------------------------------------------------------//

WORD fwArrayScanWord( HFWARRAY hList, WORD wScanned, WORD wInit, WORD wCount )
{
    lValScanned = (LONG) wScanned;
    return fwArrayTraverse( hList, ( FWARRAYCALLBACK ) ScanWordCallBack,
                            wInit, wCount );
}

//---------------------------------------------------------------------------//

WORD fwArrayScanLong( HFWARRAY hList, LONG lScanned, WORD wInit, WORD wCount )
{
    lValScanned = lScanned;
    return fwArrayTraverse( hList, ( FWARRAYCALLBACK ) ScanLongCallBack,
                            wInit, wCount );
}

//---------------------------------------------------------------------------//
