#include "FiveOS2.ch"


//----------------------------------------------------------------------------//

CLASS TFont

   DATA   cFaceName
   DATA   hFont, hFontOld
   DATA   lBold, lItalic, lUnderline, lStrikeOut
   DATA   nHeight, nWidth, nEscapement, nOrientation, nWeight
   DATA   nCharSet, nOutPrecision, nClipPrecision, nQuality, nPitchFamily

   METHOD New( cFaceName, nWidth, nHeight, lFromUser,;
               lBold, nEscapement, nOrientation, nWeight, lItalic,;
               lUnderline, lStrikeOut, nCharSet, nOutPrecision,;
               nClipPrecision, nQuality ) CONSTRUCTOR

   METHOD Release() VIRTUAL // INLINE If( ::hFont != 0, DeleteObject( ::hFont ),)

   METHOD Activate( hPS ) VIRTUAL // INLINE ::hFontOld := SelectObject( hPS, ::hFont )

   METHOD DeActivate( hPS ) VIRTUAL // INLINE  SelectObject( hPS, ::hFontOld )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFaceName, nWidth, nHeight, lFromUser, lBold,;
            nEscapement, nOrientation, nWeight, lItalic, lUnderline,;
            lStrikeOut, nCharSet, nOutPrecision, nClipPrecision,;
            nQuality ) CLASS TFont

   local aFont, nRGBColor

   DEFAULT nEscapement := 0, nOrientation := 0, nWeight := 0, lItalic := .f.,;
           lFromUser := .f., lUnderLine := .f., lStrikeOut := .f.,;
           nCharSet := 0, nOutPrecision := 0, nClipPrecision := 0,;
           nQuality := 0, lBold := .f.

   if lBold
      nWeight = nOr( nWeight)
      ::lBold = lBold
   endif

   ::cFaceName      =  cFaceName 
   ::nHeight        =  nHeight 
   ::nWidth         =  nWidth 
   ::nEscapement    =  nEscapement 
   ::nOrientation   =  nOrientation 
   ::nWeight        =  nWeight 
   ::lItalic        =  lItalic 
   ::lUnderLine     =  lUnderLine 
   ::lStrikeOut     =  lStrikeOut 
   ::nCharSet       =  nCharSet 
   ::nOutPrecision  =  nOutPrecision 
   ::nClipPrecision =  nClipPrecision 
   ::nQuality       =  nQuality 
   ::nPitchFamily   =  0 
   ::hFontOld       =  0

   if ::cFaceName != "System"
      ::hFont = GpiCreateLogFont( { ::nHeight, ::nWidth, ::nEscapement,;
                              ::nOrientation, ::nWeight, ::lItalic,;
                              ::lUnderLine, ::lStrikeOut, ::nCharSet,;
                              ::nOutPrecision, ::nClipPrecision,;
                              ::nQuality, ::nPitchFamily, ::cFaceName } )
   endif

return nil


//--------------------------------------------------------------------------//

