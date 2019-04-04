// This module replaces Clipper.lib OSMEM module.

#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

#define _CF 2

extern WORD _asizds, _abrktb;

SEL fwGlobalAlloc( WORD wFlags, LONG lBytes );
SEL fwGlobalReAlloc( SEL sel, LONG lSize, WORD Flags );

//----------------------------------------------------------------------------//

WORD _osAllocDefSeg( WORD * pDS, WORD * pSizeDS, WORD * pDSLimit )
{
   * pDS      = _DS;
   * pSizeDS  = ( _asizds & 0xFFFE );
   * pDSLimit = ( _abrktb + 1 ) & 0xFFFE;

   return 0;
}

//----------------------------------------------------------------------------//

WORD _osAvail( void )              // Maximum memory available
{
   LONG lSize;

   DosMemAvail( ( PULONG ) &lSize );

   return lSize / 16;

   /*
   WinAlarm( HWND_DESKTOP, WA_ERROR );

   _BX = 0xFFFF;
   _AH = 0x48;
   _Dos3Call();

   return _BX;
   */
}

//----------------------------------------------------------------------------//

WORD _osAlloc( WORD wParagraphs )  // Allocate memory
{
   return fwGlobalAlloc( 0, wParagraphs * 16 );

   /*
   _BX = wParagraphs;
   _AH = 0x48;
   _Dos3Call();

   return IF( _FLAGS & _CF, 0, _AX );
   */
}

//----------------------------------------------------------------------------//

WORD _osSize( WORD wSegment, WORD wNewSize )  // Modify memory allocation
{
   return fwGlobalReAlloc( wSegment, wNewSize * 16, 0 );

   /*
   _ES = wSegment;
   _BX = wNewSize;
   _AH = 0x4A;
   _Dos3Call();

   return _FLAGS & _CF;
   */
}

//----------------------------------------------------------------------------//
