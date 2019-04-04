
#include <ClipApi.h>

typedef struct
{
    LONG hWnd;
    WORD wDummy;
    LONG lIndex;
} WNDLINK;

extern WNDLINK far * OptDictGetMet( WORD hWndList, PCLIPSYMBOL hWnd );

static LONG hWndList       = 0;


//---------------------------------------------------------------------------//

void WindowListSet( LONG hWnd, WORD wWndIndex )
{
   if( !hWndList )
   {
       hWndList = _mdCreate( 25, _Get_Sym( "WNDLINK" ) );
   }

   _mdAdd( hWndList, (PCLIPSYMBOL) hWnd, (PCLIPFUNC) wWndIndex );

}

//---------------------------------------------------------------------------//

WORD WindowListGet( LONG hWnd )
{
   return (WORD) ( OptDictGetMet( hWndList, (PCLIPSYMBOL) hWnd )->lIndex );
}

//---------------------------------------------------------------------------//

void WindowListDel( LONG hWnd )
{
    _mdAdd( hWndList, (PCLIPSYMBOL) hWnd, (PCLIPFUNC) 0 );
}

//---------------------------------------------------------------------------//

CLIPPER WndListSet( void ) // ( hWnd, nWndIndex )
{
    WindowListSet( _parnl( 1 ), _parni( 2 ) );
}

//---------------------------------------------------------------------------//

CLIPPER WndListGet( void ) // ( hWnd ) -> nWndIndex
{
    _retni( WindowListGet( _parnl( 1 ) ) );
}

//---------------------------------------------------------------------------//

CLIPPER WndListDel( void ) // ( hWnd )
{
    WindowListDel( _parnl( 1 ) );
}

//---------------------------------------------------------------------------//
