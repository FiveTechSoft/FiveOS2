#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>
#include <bsedos.h>

#define iLenCtl sizeof(DLGTITEM)
#define iLenHdr sizeof(DLGTEMPLATE)

MRESULT EXPENTRY DlgProc( HWND hWnd, WORD wMsg, MPARAM lParam1, MPARAM lParam2 );

static LPCLIPSYMBOL pHandleEvent = 0;

static PCLIPVAR poLastDlg = 0;
static HWND     hLastDlg  = 0;

void WindowListSet( HWND hWnd, WORD wWndIndex );
WORD WindowListGet( HWND hWnd );
void WindowListDel( HWND hWnd );

//---------------------------------------------------------------------------//

PCLIPVAR GetCurrentBase( HWND hDlg )
{

    if( hDlg && ( hDlg != hLastDlg || !poLastDlg ) )
        poLastDlg = (PCLIPVAR) WindowListGet( hDlg );

    hLastDlg  = hDlg;

    return poLastDlg;

}

//---------------------------------------------------------------------------//

static void SetCurrentBase( PCLIPVAR pBase )
{
     hLastDlg  = 0;
     poLastDlg = pBase;
}

//----------------------------------------------------------------------------//

CLIPPER WINCREATED() // IALOG()
{
   // DosGetResource( 0, RT_DIALOG, _parni( 1 ), &pdlgt );

   _retnl( ( LONG ) WinCreateDlg( ( HWND ) _parnl( 1 ),   // hWndParent
                                  ( HWND ) _parnl( 2 ),   // hWndOwner
                                  ( PFNWP ) _parnl( 3 ),  // DlgProc
                                  ( PDLGTEMPLATE ) _parc( 4 ), 0 ) );
}
//----------------------------------------------------------------------------//

CLIPPER CCTRL2CHR() // IALOG()
{
   PDLGTITEM pCtlt;
   
   PSZ pszCtl = _parc(8);
   HWND hDlg;
   int iLen,iLenClass=0;
   if (ISCHAR(7)){
   		iLenClass= strlen(_parc(7)) +1;
   }
   iLen = strlen( pszCtl );
   pCtlt=_xgrab( iLenCtl+iLen+1+iLenClass );
   // Control
   pCtlt->fsItemStatus = 0;
   pCtlt->cChildren = 0;
   if ( iLenClass != 0 ){
	   	pCtlt->cchClassName = iLenClass-1;
	   	pCtlt->offClassName = iLenHdr+_parni(9)*iLenCtl+_parni(10);
   }else{
   		pCtlt->cchClassName = 0;
   		pCtlt->offClassName = _parni(7);
   }
   pCtlt->cchText = iLen;
   pCtlt->offText = iLenHdr+_parni(9)*iLenCtl+_parni(10)+iLenClass;
   pCtlt->flStyle = _parnl(6);
   pCtlt->x  = _parni(2);
   pCtlt->y  = _parni(1);
   pCtlt->cx = _parni(4) - _parni(2) + 1;
   pCtlt->cy = _parni(3) - _parni(1) + 1;
   pCtlt->id = _parni(5);
   pCtlt->offPresParams = 0xffff;
   pCtlt->offCtlData = 0xffff;
   // Cadenas
   if (iLenClass!=0)
	   _bcopy((char *)pCtlt+iLenCtl,_parc(7),iLenClass+1);
   _bcopy((char *)pCtlt+iLenCtl+iLenClass,pszCtl,iLen+1);
   _reta(2);
   _storclen((LPBYTE)pCtlt,iLenCtl,-1,1);
   _storclen((LPBYTE)pCtlt+iLenCtl,iLen+1+iLenClass,-1,2);
   _xfree(pCtlt);
}
//---------------------------------------------------------------------------

CLIPPER CDLG2CHR() // IALOG()
{
   PDLGTEMPLATE pdlgt;
   
   PSZ pszTitulo = _parc(6);
   HWND hDlg;
   int iLen;
   
   iLen=strlen(pszTitulo);
   pdlgt=_xgrab(iLenHdr+iLen+5);
   // Cabecera
   pdlgt->cbTemplate   = iLenHdr+iLen+5;
   pdlgt->type         = 0;
   pdlgt->codepage     = 850;
   pdlgt->offadlgti    = 0xE;
   pdlgt->fsTemplateStatus = 1;
   pdlgt->iItemFocus     = 0;
   pdlgt->coffPresParams = 0;
   pdlgt->adlgti[0].fsItemStatus = 0;
   pdlgt->adlgti[0].cChildren = _parni(1);
   pdlgt->adlgti[0].cchClassName = 0;
   pdlgt->adlgti[0].offClassName = 1;
   pdlgt->adlgti[0].cchText = iLen;
   pdlgt->adlgti[0].offText = iLenHdr+(_parni(1)*iLenCtl);
   pdlgt->adlgti[0].flStyle = _parnl(7);
   pdlgt->adlgti[0].x  = _parni(3);
   pdlgt->adlgti[0].y  = _parni(2) ;
   pdlgt->adlgti[0].cx = _parni(5) - _parni(3) + 1;
   pdlgt->adlgti[0].cy = _parni(4) - _parni(2) + 1;
   pdlgt->adlgti[0].id = 100;
   pdlgt->adlgti[0].offPresParams = 0xffff;
   pdlgt->adlgti[0].offCtlData =iLenHdr+iLen+1+(_parni(1)*iLenCtl);
   // Cadenas
   _bcopy(((char *)pdlgt)+iLenHdr,pszTitulo,iLen);
   *(LONG *)(((char *)pdlgt)+iLenHdr+iLen+1) = FCF_SYSMENU | FCF_TITLEBAR | FCF_DLGBORDER;
   _reta(2);
   _storclen((LPBYTE)pdlgt,iLenHdr,-1,1);
   _storclen((LPBYTE)((char *)pdlgt+iLenHdr),iLen+5,-1,2); 
   _xfree(pdlgt);
}
//----------------------------------------------------------------------------//

CLIPPER WINDLGBOX() // IALOG()
{
   HWND hDlg;
	
   SetCurrentBase( _param( 4, ALLTYPES ) );
   hDlg =  ( HWND ) WinLoadDlg( 
   				( HWND ) _parnl( 1 ),      // hWndParent
                ( HWND ) _parnl( 2 ),      // hWndOwner
   				( PFNWP ) DlgProc, 0 , _parnl(3) , 0 ) ;
   _retnl(WinProcessDlg(hDlg)) ;
   WinDestroyWindow(hDlg);
   SetCurrentBase( 0 );
}

//----------------------------------------------------------------------------//

CLIPPER WINDLGBOX1()
{
   SetCurrentBase( _param( 4, ALLTYPES ) );

   _retnl( WinDlgBox( ( HWND ) _parnl( 1 ),      // hWndParent
                      ( HWND ) _parnl( 2 ),      // hWndOwner
                      ( PFNWP ) DlgProc, 0, _parnl( 3 ), 0 ) );
   SetCurrentBase( 0 );
}

//----------------------------------------------------------------------------//

static void HandleEvent( PCLIPVAR oDlg, WORD wMsg, MPARAM lParam1, MPARAM lParam2 )
{
   if( ! pHandleEvent )
      pHandleEvent = _Get_Sym( "HandleEvent" );

   _PutSym( pHandleEvent );
   _bcopy( ( void * ) ++_tos, ( void * ) oDlg, 14 );

   _PutQ( wMsg );
   _PutLN( ( LONG ) lParam1 );
   _PutLN( ( LONG ) lParam2 );
   _xSend( 3 );
}

//----------------------------------------------------------------------------//

CLIPPER WINDLGBOXI() //   hWnd, Self
{
   HWND hDlg;

   SetCurrentBase( _param( 4, ALLTYPES ) );
   hDlg = WinCreateDlg( ( HWND ) _parnl( 1 ),
                        ( HWND ) _parnl( 2 ),
                        ( PFNWP ) DlgProc,
                        ( PDLGTEMPLATE ) _parc( 3 ), 0 );
   _retnl( WinProcessDlg( hDlg ) );
   WinDestroyWindow( hDlg );
   SetCurrentBase( 0 );
}

//----------------------------------------------------------------------------//

MRESULT EXPENTRY DlgProc( HWND hWnd, WORD wMsg, MPARAM lParam1, MPARAM lParam2 )
{

   if( !hLastDlg )
   {
        hLastDlg = hWnd;
        WindowListSet( hWnd, (WORD) poLastDlg );
   }

   if( wMsg == WM_INITDLG )
      HandleEvent( GetCurrentBase( hWnd ), wMsg, hWnd, lParam2 );
   else
      HandleEvent( GetCurrentBase( hWnd ), wMsg, lParam1, lParam2 );

   if( ! _parl( -1 ) )
      return WinDefDlgProc( hWnd, wMsg, lParam1, lParam2 );
   else
      return 0;
}

//----------------------------------------------------------------------------//

CLIPPER DIALOGPROC() { _retnl( ( LONG ) DlgProc ); }

//----------------------------------------------------------------------------//

CLIPPER WINDISMISS() // DLG()
{
   _retl( WinDismissDlg( ( HWND ) _parnl( 1 ), _parnl( 2 ) ) );

   WindowListDel( ( HWND ) _parnl( 1 ) );

}

//----------------------------------------------------------------------------//

CLIPPER WINWINDOWF() // ROMID()
{
   _retnl( ( LONG ) WinWindowFromID( ( HWND ) _parnl( 1 ), _parnl( 2 ) ) );
}

//----------------------------------------------------------------------------//

void CenterDialog( HWND hDlg )
{
   RECTL r;

   WinQueryWindowRect( hDlg, &r );
   WinSetWindowPos( hDlg, 0,
   ( WinQuerySysValue( HWND_DESKTOP, SV_CXSCREEN ) - ( r.xRight -r.xLeft ) ) / 2,
   ( WinQuerySysValue( HWND_DESKTOP, SV_CYSCREEN ) - ( r.yTop - r.yBottom ) ) / 2,
   r.xRight - r.xLeft, r.yTop - r.yBottom, SWP_MOVE );
}

//----------------------------------------------------------------------------//

CLIPPER CENTERDIAL() // OG()
{
   CenterDialog( ( HWND ) _parnl( 1 ) );
}

//----------------------------------------------------------------------------//
