// They are like Clipper's PadL(), PadC() and PadR() but based on pixels!!!

#include "FiveOs2.ch"

#define PADCHAR  Chr(32)

//----------------------------------------------------------------------------//

function xPadR( cText, nPixels, cChar )

   DEFAULT cChar := PADCHAR

   while GetTextWidth( 0, cText ) < nPixels
      cText += cChar
   end

return cText

//----------------------------------------------------------------------------//

function xPadL( cText, nPixels, cChar )

   DEFAULT cChar := PADCHAR

   while GetTextWidth( 0, cText ) < nPixels
      cText = cChar + cText
   end

return cText

//----------------------------------------------------------------------------//

function xPadC( cText, nPixels, cChar )

   local cRet    := If( ValType( cText ) == "C", AllTrim( cText ), "" )
   local nLen    := Len( cText )
   local nPixLen := GetTextWidth( 0, cText )
   local nPad    := GetTextWidth( 0, If( cChar != nil, cChar, PADCHAR ) )

   if nPixels > nPixLen
      cRet = PadC( cRet, nLen + ( nPixels - nPixLen ) / nPad,;
                   If( cChar != nil, cChar, PADCHAR ) )
   endif

return cRet

//----------------------------------------------------------------------------//
