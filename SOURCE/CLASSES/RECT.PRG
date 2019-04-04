#include "FiveOS2.ch"

//----------------------------------------------------------------------------//

CLASS TRect

   DATA   nTop, nLeft, nBottom, nRight

   METHOD New( nTop, nLeft, nBottom, nRight ) CONSTRUCTOR

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight ) CLASS TRect

   ::nTop    = nTop
   ::nLeft   = nLeft
   ::nBottom = nBottom
   ::nRight  = nRight

return nil

//----------------------------------------------------------------------------//
