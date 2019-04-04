#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

#define FO_FONTID 128

//--------------------------------------------------------------------------//

void Draw3dBox( HPS hPS, RECTL * pRect, HWND hWnd, BOOL bInset )
{
   RECTL rctTemp;
   POINTL pt;
   
   // GpiCreateLogColorTable( hPS, 0L, LCOLF_RGB, 0L, 0L, ( PLONG ) NULL );
   
   if( ! pRect )
   {
      WinQueryWindowRect( hWnd, &rctTemp );
      pRect = &rctTemp;
   }

   pt.y = pRect->yTop - 1;
   pt.x = pRect->xLeft + 1;
   GpiSetColor( hPS, ( bInset ? SYSCLR_SHADOW : CLR_WHITE ) );
   GpiSetCurrentPosition( hPS, &pt );

   pt.y = pRect->yTop - 1;
   pt.x = pRect->xRight - 1;
   GpiLine( hPS, &pt );
   GpiSetColor( hPS, ( bInset ? CLR_WHITE : SYSCLR_SHADOW ) );

   pt.y = pRect->yTop - 1;
   pt.x = pRect->xRight - 1;
   GpiSetCurrentPosition( hPS, &pt );

   pt.y = pRect->yBottom;
   pt.x = pRect->xRight - 1;
   GpiLine( hPS, &pt );

   pt.y = pRect->yBottom;
   pt.x = pRect->xLeft;
   GpiLine( hPS, &pt );

   pt.y = pRect->yBottom + 1;
   pt.x = pRect->xLeft;
   GpiSetCurrentPosition( hPS, &pt );

   pt.y = pRect->yTop - 1;
   pt.x = pRect->xLeft;
   GpiSetColor( hPS, ( bInset ? SYSCLR_SHADOW : CLR_WHITE ) );
   GpiLine( hPS, &pt );
}

//--------------------------------------------------------------------------//

CLIPPER DRAW3DBOX()  // ( hPS, aRect, hWnd, lInset )  --> nil
{
   RECTL rct;
   RECTL * pRect = 0;

   if( ISARRAY( 2 ) )
   {
      rct.yTop    = _parni( 2, 1 );
      rct.xLeft   = _parni( 2, 2 );
      rct.yBottom = _parni( 2, 3 );
      rct.xRight  = _parni( 2, 4 );
      pRect       = &rct;
   }

   Draw3dBox( ( HPS ) _parnl( 1 ), pRect, ( HWND ) _parnl( 3 ), _parl( 4 ) );
}

//----------------------------------------------------------------------------//

CLIPPER GPILOADBIT() // MAP()
{
	_retnl( ( LONG ) GpiLoadBitmap( ( HPS ) _parnl( 1 )				// hPS
						,_parnl( 2 )             // ReSource
						,_parnl( 3 )				// Id
						,_parnl( 4 )				// Width
						,_parnl( 5 ) ) );				// Heigth

}

//--------------------------------------------------------------------------//

CLIPPER GPICREATEL(){               //OGFONT

   FATTRS fat;
   HPS   hPS;
//      ::hFont = GpiCreateLogFont(hPS,{ ::nHeight, ::nWidth, ::nEscapement,;
//                              ::nOrientation, ::nWeight, ::lItalic,;
//                              ::lUnderLine, ::lStrikeOut, ::nCharSet,;
//                              ::nOutPrecision, ::nClipPrecision,;
//                              ::nQuality, ::nPitchFamily, ::cFaceName } )

   
   fat.usRecordLength = sizeof(FATTRS); /* sets size of structure   */
   fat.fsSelection = 0;         
   fat.lMatch = 0L;             
   fat.idRegistry = 0;          
   fat.usCodePage = 850;        
   fat.lMaxBaselineExt = _parnl( 2 , 1 );  
   fat.lAveCharWidth   = _parnl( 2 , 2 );     
   fat.fsType = 0;              
   fat.fsFontUse = FATTR_FONTUSE_NOMIX;
   hPS = (HPS) _parnl( 1 );
    
   strcpy(fat.szFacename ,_parc( 2 , 14 ));
   
   _retnl( ( LONG ) GpiCreateLogFont( hPS , NULL , FO_FONTID , &fat ) );   
    
}
//--------------------------------------------------------------------------//
