#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <Os2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

extern void ValToChar( LPCLIPVAR pVal );   // Returns cStr at _eval

//----------------------------------------------------------------------------//

CLIPPER MSGINFO()
{
   HWND hWnd = WinQueryActiveWindow( HWND_DESKTOP, 0 );
   LPSTR szCaption = IF( PCOUNT() > 1 && ISCHAR( 2 ), _parc( 2 ), "Information" );

    ValToChar( _param( 1, -1 ) );   // Result at _eval

   _retni( WinMessageBox( HWND_DESKTOP, hWnd, _parc( -1 ), szCaption,
           0, MB_INFORMATION | MB_OK | MB_MOVEABLE | MB_APPLMODAL ) );
}

//----------------------------------------------------------------------------//

CLIPPER MSGBEEP()
{
   WinAlarm( HWND_DESKTOP, WA_ERROR );
}

//----------------------------------------------------------------------------//

CLIPPER MSGYESNO()
{
   HWND hWnd = WinQueryActiveWindow( HWND_DESKTOP, 0 );
   LPSTR szCaption = IF( PCOUNT() > 1 && ISCHAR( 2 ), _parc( 2 ),
                         "Please, select" );

    ValToChar( _param( 1, -1 ) );   // Result at _eval

   _retl( WinMessageBox( HWND_DESKTOP, hWnd, _parc( -1 ), szCaption,
    0, MB_ICONQUESTION | MB_YESNO | MB_MOVEABLE | MB_APPLMODAL ) == MBID_YES );
}

//----------------------------------------------------------------------------//

CLIPPER MSGERROR()
{
   HWND hWnd = WinQueryActiveWindow( HWND_DESKTOP, 0 );

   ValToChar( _param( 1, -1 ) );   // Result at _eval

   WinMessageBox( HWND_DESKTOP, hWnd, _parc( -1 ), _parc( 2 ),
     0, MB_ERROR | MB_OK | MB_MOVEABLE | MB_APPLMODAL );
}

//----------------------------------------------------------------------------//

CLIPPER MSGSTOP()
{
   HWND hWnd = WinQueryActiveWindow( HWND_DESKTOP, 0 );
   LPSTR szTitle = ( PCOUNT() > 1 ) ? _parc( 2 ): "Stop!";

   ValToChar( _param( 1, -1 ) );   // Result at _eval

   WinMessageBox( HWND_DESKTOP, hWnd, _parc( -1 ), szTitle,
     0, MB_ICONHAND | MB_OK | MB_MOVEABLE | MB_APPLMODAL );
}

//----------------------------------------------------------------------------//

CLIPPER MSGALERT()
{
   HWND hWnd     = WinQueryActiveWindow( HWND_DESKTOP, 0 );
   LPSTR szTitle = ( PCOUNT() > 1 ) ? _parc( 2 ): "Alert";

   ValToChar( _param( 1, -1 ) );   // Result at _eval

   WinMessageBox( HWND_DESKTOP, hWnd, _parc( -1 ), szTitle,
     0, MB_ICONEXCLAMATION | MB_OK | MB_MOVEABLE | MB_APPLMODAL );
}

//----------------------------------------------------------------------------//
