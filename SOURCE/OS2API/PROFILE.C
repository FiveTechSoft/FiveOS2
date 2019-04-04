#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

HAB GetHab( void );
void ValToChar( LPCLIPVAR pVal );   // Returns cStr at _eval

//----------------------------------------------------------------------------//

CLIPPER PRFQUERYIN() // T( cAppName, cKeyName, nDefault ) --> nValue
{
   LONG lValue, lLen = 4;

   /*
   WinQueryProfileData( GetHab(), _parc( 1 ), _parc( 2 ),
                        ( PVOID ) &lValue, ( PULONG ) &lLen );
   */

   _retnl( lValue );
}

//----------------------------------------------------------------------------//

CLIPPER PRFQUERYST() // RING( cAppName, cKeyName, cDefault )  --> cValue
{
   BYTE pBuffer[ 250 ];

   /*
   WinQueryProfileString( GetHab(), _parc( 1 ), _parc( 2 ),
                          _parc( 3 ), pBuffer, 249 );
   */

   _retc( pBuffer );
}

//----------------------------------------------------------------------------//

CLIPPER PRFWRITEST() // RING( cAppName, cKeyName, cValue )  --> lSuccess
{
   /*
   _retl( WinWriteProfileString( GetHab(), _parc( 1 ), _parc( 2 ),
                                 _parc( 3 ) ) );
   */
}

//----------------------------------------------------------------------------//

CLIPPER PRFWRITEDA() // TA( cAppName, cKeyName, uValue )  --> lSuccess
{
   ValToChar( _param( 3, -1 ) );

   /*
   _retl( WinWriteProfileData( GetHab(), _parc( 1 ), _parc( 2 ),
                               _parc( -1 ), _parclen( -1 ) ) );
   */
}

//----------------------------------------------------------------------------//
