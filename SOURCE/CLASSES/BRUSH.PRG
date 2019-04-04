#include "FiveOs2.ch"

//----------------------------------------------------------------------------//

CLASS TBrush

   DATA   hBrush, hBitmap

   METHOD New( cStyle, nRGBColor, cBmpFile, cBmpRes ) CONSTRUCTOR

   METHOD cGenPRG()

   METHOD Release()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cStyle, nRGBColor, cBmpFile, cBmpRes ) CLASS TBrush

   local nAt
   local aNewTypes := { "BORLAND", "BRICKS", "TILED" }
   local aStdTypes := { "HORIZONTAL", "VERTICAL", "FDIAGONAL", "BDIAGONAL",;
                        "CROSS", "DIAGCROSS" }

   ::hBrush  = 0
   ::hBitmap = 0

   do case
      case cStyle == nil .and. nRGBColor != nil
           // ::hBrush = CreateSolidBrush( nRGBColor )

      case cStyle != nil
           do case
              case ( nAt := AScan( aNewTypes, cStyle ) ) != 0
                   // ::hBitmap = FWBrushes( nAt )
                   // ::hBrush = If( ::hBitmap > 0,;
                   //               CreatePatternBrush( ::hBitmap ), )

              case ( nAt := AScan( aStdTypes, cStyle ) ) != 0
                   // ::hBrush = CreateHatchBrush( nAt - 1, nRGBColor )

              otherwise
                 if File( cBmpFile )
                    // ::hBitMap = ReadBitmap( 0, cBmpFile )
                    // ::hBrush = If( ::hBitmap > 0,;
                    //               CreatePatternBrush( ::hBitmap ), )
                 endif
           endcase

      case cBmpFile != nil
           if File( cBmpFile )
              // ::hBitMap = ReadBitmap( 0, cBmpFile )
              // ::hBrush = If( ::hBitmap > 0, CreatePatternBrush( ::hBitmap ), )
           endif

      case cBmpRes != nil
           // ::hBitmap = LoadBitmap( GetResources(), cBmpRes )
           // ::hBrush  = If( ::hBitmap > 0, CreatePatternBrush( ::hBitmap ),)
   endcase


return nil

//----------------------------------------------------------------------------//

METHOD cGenPRG() CLASS TBrush

   local cPrg := ""

   cPrg += CRLF + ;
           "   DEFINE BRUSH oBrush " + ;
           If( ::hBitmap != 0, 'BITMAP "brush.bmp"', "" ) + CRLF

return cPrg

//----------------------------------------------------------------------------//

METHOD Release() CLASS TBrush

   if ::hBrush != nil .and. ::hBrush > 0
      // DeleteObject( ::hBrush )
   endif

   if ::hBitmap != nil .and. ::hBitMap > 0
      // DeleteObject( ::hBitmap )
   endif

   ::hBrush  = 0
   ::hBitmap = 0

return nil

//----------------------------------------------------------------------------//
