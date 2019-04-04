#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

void Draw3dBox( HPS hPS, RECTL * pRect, HWND hWnd, BOOL bInset );

//---------------------------------------------------------------------------//

static int near GetLong( PCLIPVAR Array, WORD wIndex )
{
    _cAt( Array, wIndex, -1, ++_tos );
    return (long) ( _tos-- )->pPointer1;
}

//---------------------------------------------------------------------------//

static void near PaintTheLine( HPS hPS, PRECTL rct, WORD wIndex,
                               PCLIPVAR pAtext, PCLIPVAR pAsizes,
                               LONG lClrFore, LONG lClrBack, BOOL bTree )
{
   RECTL box;
   LONG  lMaxRight = rct->xRight;
   WORD  wLen     = _VARRAYLEN( pAtext );

   rct->xRight  = 0;

   box.yTop    = rct->yTop;
   box.yBottom = rct->yBottom - 1;

   if( !wIndex | wIndex > wLen )
       wIndex = 1;

   while( wIndex <= wLen )
   {
        rct->xLeft   = rct->xRight;

        rct->xRight  = ( wIndex == wLen 
                       ? lMaxRight
                       : rct->xLeft + GetLong( pAsizes, wIndex ) - 1 );

        _cAt( pAtext, wIndex, 0xFFFF, ++_tos );
        box.xLeft   = rct->xLeft;
        box.xRight  = ( wIndex < wLen && rct->xRight <= lMaxRight 
                      ? rct->xRight
                      : lMaxRight );
                      

        if( _tos->wType & NUMERIC )
        {
            if( ! bTree ){
               RECTL rct1;
               rct1.yTop   = rct->yTop    + 1;
               rct1.xLeft  = rct->xLeft   + 1;
               rct1.yBottom= rct->yBottom - 1;
               rct1.xRight = rct->xRight  - 1;
              
               WinDrawBitmap( hPS, (HBITMAP) _tos->pPointer1 ,&rct1,NULL                           
                           ,lClrFore,lClrBack
                           ,DBM_IMAGEATTRS | DBM_STRETCH );
            }else
               WinDrawBitmap( hPS, (HBITMAP) _tos->pPointer1,rct,NULL
                           ,lClrFore,lClrBack
                           ,DBM_IMAGEATTRS | DBM_STRETCH );
        }
        else
        {
            rct->xLeft   += 1;
            rct->yTop    -= 1;
            rct->yBottom -= 1;
            rct->xRight  -= 1;

            WinDrawText( hPS, _tos->w2, ( LPSTR ) _VSTR( _tos ), rct,
                         lClrFore, lClrBack,
                         DT_LEFT | DT_VCENTER | DT_ERASERECT );
            rct->xLeft   -= 1;
            rct->yTop    += 1;
            rct->yBottom += 1;
            rct->xRight  += 1;
        }

        if( ! bTree )
           Draw3dBox( hPS, &box, 0, 0 );
        else
        {
           if( ! ( _tos->wType & NUMERIC ) )
           {
              box.xLeft -= 16;
              WinDrawBorder( hPS, &box, 1, 1, lClrFore, lClrBack, 0 );
           }
        }

        _tos--;

        if( rct->xRight >= lMaxRight )
        {
            wIndex = wLen + 1;   // ya no pintamos m s
        }
        else
           ++wIndex;
   }
}

//---------------------------------------------------------------------------//

CLIPPER WBrwLine() // ( hWnd, hPS, nRow, aText, aSizes, nFirstItem, ;
                   // nClrFore, nClrBack, hFont )
{
   HWND hWnd        = _parnl( 1 );
   HPS  hPS         = _parnl( 2 );
   WORD wRow        = _parni( 3 );
   BOOL bDestroyPS  = FALSE;
   FONTMETRICS fm;
   RECTL rct, box;
   LONG clrFore = ( ( PCOUNT() > 6 ) ? _parnl( 7 ): CLR_WHITE );
   LONG clrBack = ( ( PCOUNT() > 7 ) ? _parnl( 8 ): CLR_BLACK );
   BOOL  bTree  = _parl( 10 );

   // GpiCreateLogColorTable( hPS, 0L, LCOLF_RGB, 0L, 0L, (PLONG) NULL );

   if( ! hPS )
   {
      bDestroyPS = TRUE;
      hPS = WinGetPS( hWnd );
   }

   WinQueryWindowRect( hWnd, &rct );
   GpiQueryFontMetrics( hPS, sizeof(FONTMETRICS), &fm );

   // GpiSetMix( hPS, FM_XOR );
   GpiSetBackMix( hPS, BM_OVERPAINT );
   GpiSetBackColor( hPS, clrBack );
   GpiSetColor( hPS, clrFore );

   rct.yTop    -= fm.lMaxBaselineExt * wRow ;
   rct.yBottom  = rct.yTop - fm.lMaxBaselineExt + 1;
   rct.xRight  -= 13;   // ScrollBar !

   PaintTheLine( hPS, &rct, _parni( 6 ), _param( 4, -1 ), _param( 5, -1 ),
                 clrFore, clrBack, bTree );

   if( bDestroyPS )
       WinReleasePS( hPS );
}

//---------------------------------------------------------------------------//

CLIPPER nWRows() // ( hWnd, [ hPS ] ) --> nRows
{
   HWND hWnd = _parnl( 1 );
   HPS  hPS  = _parnl( 2 );
   RECTL rct;
   BOOL bDestroyPS = FALSE;
   FONTMETRICS fm;

   if( ! hPS )
   {
      bDestroyPS = TRUE;
      hPS = WinGetPS( hWnd );
   }

   WinQueryWindowRect( hWnd, &rct );
   GpiQueryFontMetrics( hPS, sizeof( FONTMETRICS ), &fm );

   if( bDestroyPS )
       WinReleasePS( hPS );

                               // 14 = size of horizontal scrollbar
   _retni( ( rct.yTop - rct.yBottom - 14 ) / fm.lMaxBaselineExt );
}

//----------------------------------------------------------------------------//
