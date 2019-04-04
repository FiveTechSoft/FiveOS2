#include <ClipApi.h>

//----------------------------------------------------------------------------//

BYTE bColorToN( LPSTR szColor )
{
   BYTE  bColor  = 0;
   BYTE  bChar;
   BOOL  bFore = TRUE;

   if( szColor )
   {
      while( bChar = * szColor++ )
      {
         switch( bChar )
         {
            case '*':
                bColor |= 0x80;
                break;

            case '+':
                bColor |= 0x08;
                break;

            case '/':
                bFore = FALSE;
                break;

            case 'b': case 'B':
                if( * szColor == 'G' || * szColor == 'g' )
                {
                   bColor |= bFore ? 0x03: 0x30;
                   szColor++;
                }
                else
                   bColor |= bFore ? 0x01: 0x10;
                break;

            case 'g': case 'G':
                if( * szColor == 'R' || * szColor == 'r' )
                {
                   bColor |= bFore ? 0x06: 0x60;
                   szColor++;
                }
                else
                   bColor |= bFore ? 0x02: 0x20;
                break;

            case 'w': case 'W':
                bColor |= bFore ? 0x07: 0x70;
                break;

            case 'r': case 'R':
                if( * szColor == 'B' || * szColor == 'b' )
                {
                   bColor |= bFore ? 0x05: 0x50;
                   szColor++;
                }
                else
                   bColor |= bFore ? 0x04: 0x40;
                break;
         }
      }
   }

   return bColor;
}

//----------------------------------------------------------------------------//

CLIPPER NCOLORTON()  //     szColor --> nColor
{
   _retni( bColorToN( _parc( 1 ) ) );
}

//----------------------------------------------------------------------------//

LONG lColorToRGB( BYTE bColor )
{
   LONG lRGBColor  = 0;
   BOOL bIntensity = bColor & 0x8;

   if( bColor & 1 )
      lRGBColor |= bIntensity ? 0xFF0000: 0x800000;

   if( bColor & 2 )
      lRGBColor |= bIntensity ? 0x00FF00: 0x008000;

   if( bColor & 4 )
      lRGBColor |= bIntensity ? 0x0000FF: 0x000080;

   if( ( bColor & 7 ) == 0 )
      lRGBColor |= bIntensity ? 0x808080: 0x000000;

   if( ( bColor & 7 ) == 7 )
      lRGBColor |= bIntensity ? 0xFFFFFF: 0xC0C0C0;

   return lRGBColor;
}

//----------------------------------------------------------------------------//

CLIPPER NGETFORERG()  // B()    dBase_color_string_cColor  --> nForeRGB
{
   _retnl( lColorToRGB( bColorToN( _parc( 1 ) ) & 0x0F ) );
}

//----------------------------------------------------------------------------//

CLIPPER NGETBACKRG()  // B()    dBase_color_string_cColor  --> nBackRGB
{
   _retnl( lColorToRGB( ( bColorToN( _parc( 1 ) ) & 0xF0 ) >> 4 ) );
}

//----------------------------------------------------------------------------//
