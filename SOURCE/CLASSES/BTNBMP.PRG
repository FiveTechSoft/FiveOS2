#include "FiveOS2.ch"

static lRegistered := .f.

//----------------------------------------------------------------------------//

CLASS TBtnBmp FROM TControl

   DATA   bAction, cMsg
   DATA   lPressed, lCaptured
   DATA   nClrPane, nClrText
   DATA   nResName1, nResName2

   METHOD New( nTop, nLeft, nWidth, nHeight,;
               cResName1, cResName2, cBmpFile1, cBmpFile2,;
               bAction, oWnd, cMsg ) CONSTRUCTOR

   METHOD NewBar( nResName1, nResName2, cBmpFile1, cBmpFile2,;
                  bAction, oWnd, cMsg ) CONSTRUCTOR

   METHOD Click()
    
   METHOD Paint()
   
   METHOD LButtonDown( nRow, nCol, nKeyFLags )
   METHOD LButtonUp( nRow, nCol, nKeyFLags )
   METHOD MouseMove( nRow, nCol, nKeyFlags )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight,;
            cResName1, cResName2, cBmpFile1, cBmpFile2,;
            bAction, oWnd, cMsg )  CLASS TBtnBmp
   
   ::nStyle    = nOR( WS_VISIBLE )
   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::bAction   = bAction
   ::cMsg      = cMsg
   ::nTop      = nTop
   ::nLeft     = nLeft
   ::nBottom   = nTop + nHeight - 1
   ::nRight    = nLeft + nWidth - 1
   ::lPressed  = .f.
   ::lCaptured = .f.
   ::nClrPane  = SYSCLR_BUTTONMIDDLE
   ::nClrText  = CLR_BLACK

   if ! lRegistered
      WinRegisterClass( ::ClassName(), nOR( CS_SYNCPAINT, CS_SIZEREDRAW ) )
      lRegistered = .t.
   endif

   if ! Empty( oWnd:hWnd )
      ::hWnd = WinCreateWindow( oWnd:hWnd;
      						,::ClassName(), "", ::nStyle;
      						,nTop;
      						,nLeft;
      						,nHeight;
      						,nWidth;
      						,oWnd:hWnd )
      ::Link()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD NewBar( nResName1, nResName2, cBmpFile1, cBmpFile2, cMsg , bAction,;
               lGroup , oWnd ) CLASS TBtnBmp

   DEFAULT oWnd:aControls := {}

   ::nStyle    = nOR( WS_VISIBLE )
   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::bAction   = bAction
   ::cMsg      = cMsg
   ::nTop      = 2
   ::nLeft     = 2 + oWnd:GetBtnLeft( lGroup )
   ::nBottom   = ::nTop + oWnd:nBtnHeight
   ::nRight    = ::nLeft + oWnd:nBtnWidth
   ::lPressed  = .f.
   ::lCaptured = .f.
   ::nClrPane  = SYSCLR_BUTTONMIDDLE
   ::nClrText  = CLR_BLACK
   ::nResName1 = nResName1
   ::nResName2 = nResName2

   if ! lRegistered
      WinRegisterClass( ::ClassName(), nOR( CS_SYNCPAINT, CS_SIZEREDRAW ) )
      lRegistered = .t.
   endif

   if ! Empty( oWnd:hWnd )
      ::hWnd = WinCreateWindow( oWnd:hWnd;
      						,::ClassName(), "", ::nStyle;
                        ,::nLeft;
                        ,::nTop;
                        ,oWnd:nBtnWidth;
                        ,oWnd:nBtnHeight;
      						,oWnd:hWnd )
      ::Link()
      oWnd:AddControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Click() CLASS TBtnBmp

   if ::bAction != nil
      Eval( ::bAction )
   endif
   
return nil

//---------------------------------------------------------------------------//

METHOD Paint() CLASS TBtnBmp

  local hBmp

  hBmp = GpiLoadBitmap( ::hPs, 0, ::nResName1, 0, 0 )
  WinFillRect( ::hPS, 0, ::nClrPane, ::hWnd )

  if ::lPressed
    WinDrawBitMap( ::hPS, hBmp, 0, { 3, 0 }, 0, 0 )
    Draw3dBox( ::hPS, 0, ::hWnd , .t. )
  else  
    WinDrawBitMap( ::hPS, hBmp, 0, { 2, 1 }, 0, 0 )
    Draw3dBox( ::hPS, 0, ::hWnd , .f. )
  endif  

return Nil

//----------------------------------------------------------------------------//

METHOD LButtonDown()  CLASS TBtnBmp

    ::lPressed  = .t.
    ::lCaptured = .t.
    ::Capture( .t. )
    ::Refresh( .f. )

return Nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol )  CLASS TBtnBmp

   local lClick := IsOverWnd( ::hWnd, nRow, nCol )

   if ::lCaptured
      ::lCaptured = .f.
      if ::lPressed
         ::lPressed = .f.
         ::Refresh( .f. )
      endif
      ::Capture(.f.)
      if lClick
         ::Click()
      endif
   endif

return Nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TBtnBmp

   if ::lCaptured
      if ::lPressed != IsOverWnd( ::hWnd, nRow, nCol )
         ::lPressed = ! ::lPressed
         ::Refresh( .f. )
      endif
   endif
   
   ::oWnd:SetMsg( ::cMsg )
   
return nil

//----------------------------------------------------------------------------//
