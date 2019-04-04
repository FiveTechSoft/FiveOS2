// This function replaces Clipper.lib OSDATE module.

#define INCL_BASE
#define INCL_WIN
#define INCL_GPI

#include <OS2Ten.h>
#include <OS2.h>
#include <ClipApi.h>

typedef struct
{
   WORD wHours, wMinutes, wSeconds, wHundredths;
} CLIPTIME;

//----------------------------------------------------------------------------//

WORD _ostime( CLIPTIME * pClipTime )
{
   DATETIME dt;

   DosGetDateTime( &dt );

   pClipTime->wHours      = dt.hours;
   pClipTime->wMinutes    = dt.minutes;
   pClipTime->wSeconds    = dt.seconds;
   pClipTime->wHundredths = dt.hundredths;

   return 0;
}

//----------------------------------------------------------------------------//

WORD _osdate( WORD * wDate )
{
   DATETIME dt;

   DosGetDateTime( &dt );

   wDate[ 0 ] = dt.day;
   wDate[ 1 ] = dt.month;
   wDate[ 2 ] = dt.year;
   wDate[ 3 ] = 0;

   return 0;
}

//----------------------------------------------------------------------------//
