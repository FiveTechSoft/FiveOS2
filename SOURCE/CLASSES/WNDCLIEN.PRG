#include "FiveOS2.ch"

//----------------------------------------------------------------------------//

CLASS TWndClient FROM TWindow

   METHOD New( oWnd ) CONSTRUCTOR

   METHOD SetMsg( cMsg ) INLINE ;
                         If( ::oMsgBar != nil, ::oMsgBar:SetMsg( cMsg ),)
                         
   METHOD Close() VIRTUAL

   METHOD Paint()

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), HE_DEFAULT

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd ) CLASS TWndClient

   ::nClrPane = oWnd:nClrPane
   ::oWnd     = oWnd

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TWndClient

   WinFillRect( ::hPS, 0, ::nClrPane, ::hWnd )
    
return nil

//----------------------------------------------------------------------------//
