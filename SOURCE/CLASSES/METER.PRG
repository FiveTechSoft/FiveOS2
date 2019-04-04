#include "FiveOS2.ch"


static lRegistered := .f.

//----------------------------------------------------------------------------//

CLASS TMeter FROM TControl

   DATA   nTotal

   METHOD New( nRow, nCol, bSetGet, nTotal, oWnd, nWidth, nHeight,;
               lUpdate ) CONSTRUCTOR

   METHOD ReDefine( nId, bSetGet, nTotal, oWnd, lUpdate ) CONSTRUCTOR

   METHOD Default()

   METHOD Init( hDlg ) INLINE Super:Init( hDlg ), ::Default()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Paint() BLOCK ;
      { | Self, nActual | MeterPaint( ::hWnd, ::hPS,;
                          nActual := Eval( ::bSetGet ), ::nTotal,;
                          nActual * 100 / ::nTotal ) }

   METHOD Set( nActual )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, nTotal, oWnd, nWidth, nHeight,;
            lUpdate ) CLASS TMeter

   DEFAULT nTotal  := 10, nWidth := 300, nHeight := 20,;
           lUpdate := .f.

   ::nTop      = nRow //14
   ::nLeft     = nCol //8
   ::nBottom   = ::nTop  + nHeight
   ::nRight    = ::nLeft + nWidth
   ::oWnd      = oWnd
   ::nStyle    = nOR( WS_VISIBLE )
   ::nId       = ::GetNewId()
   ::bSetGet   = bSetGet
   ::nTotal    = nTotal
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lUpdate   = .f.

   if ! lRegistered
      ::Register()
      lRegistered = .t.
   endif

   if oWnd:lVisible
      ::Create()
      ::Default()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, nTotal, oWnd, lUpdate ) CLASS TMeter

   DEFAULT nTotal := 10, lUpdate := .f.

   ::nId       = nId
   ::bSetGet   = bSetGet
   ::nTotal    = nTotal
   ::oWnd      = oWnd
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lUpdate   = lUpdate

   if ! lRegistered
      ::Register( )
      lRegistered = .t.
   endif

   if oWnd != nil
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TMeter

   if nMsg == WM_PAINT
      ::BeginPaint()
      ::Paint()
      ::EndPaint()
      return 0
   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD Set( nActual ) CLASS TMeter

   DEFAULT nActual := Eval( ::bSetGet )

   if nActual > ::nTotal
      nActual = ::nTotal
   endif

   if nActual < 0
      nActual = 0
   endif

   Eval( ::bSetGet, nActual )

   ::Refresh( .f. )

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TMeter

   if ValType( Eval( ::bSetGet ) ) == "U"
      Eval( ::bSetGet, 0 )
   endif

return nil

//----------------------------------------------------------------------------//
