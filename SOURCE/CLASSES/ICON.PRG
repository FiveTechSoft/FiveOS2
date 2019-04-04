#include "FiveOS2.ch"
#include "Constant.ch"

#define IDI_HAND   32513

static lRegistered := .f.

//----------------------------------------------------------------------------//

CLASS TIcon FROM TControl

   DATA   cIcoFile, cResName
   DATA   hIcon

   METHOD New( nRow, nCol, cResName, cIcoFile, lBorder, bClick,;
               oWnd, lUpdate, bWhen ) CONSTRUCTOR

   METHOD ReDefine( nId, cResName, cIcoFile, bClick, lUpdate, oDlg,;
                    bWhen ) CONSTRUCTOR

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD Paint() INLINE WinDrawPointer( ::hDC, 0, 0, ::hIcon )

   METHOD Destroy() INLINE If( ::hIcon != 0, WinDestPointer( ::hIcon ),),;
                           ::hIcon := 0, Super:Destroy()

   METHOD SetName( cNewName )

   METHOD SetFile( cIcoFile )

   METHOD LButtonDown( nRow, nCol, nKeyFlags )

   METHOD Init( hDlg )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cResName, cIcoFile, lBorder, bClick, oWnd,;
            lUpdate, bWhen ) CLASS TIcon

   DEFAULT nRow := 0, nCol := 0, cResName := "",;
           cIcoFile := "", lBorder := .f., lUpdate := .f.

   ::nTop      = nRow * ICO_CHARPIX_H // 14
   ::nLeft     = nCol * ICO_CHARPIX_W // 8
   ::nBottom   = ::nTop  + 32
   ::nRight    = ::nLeft + 32
   ::oWnd      = oWnd
   ::nStyle    = WS_VISIBLE   // , If( lBorder, WS_BORDER, 0 ) )
   ::nId       = ::GetNewId()
   ::cIcoFile  = cIcoFile
   ::cResName  = cResName
   ::bLClicked = bClick
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen

   if ! lRegistered
      ::Register() //  nOR( CS_VREDRAW, CS_HREDRAW ) )
      lRegistered = .t.
   endif

   if oWnd != nil
      ::nClrText  = oWnd:nClrText
      ::nClrPane  = oWnd:nClrPane
      if oWnd:lVisible
         ::Create()
      else
         oWnd:DefControl( Self )
      endif
   else
      oWnd = GetWndDefault()
      if oWnd != nil
         ::nClrText = oWnd:nClrText
         ::nClrPane = oWnd:nClrPane
      endif
   endif

   if ! Empty( cIcoFile )
      // ::hIcon = ExtractIcon( cIcoFile )
   endif

   if ! Empty( cResName )
      ::hIcon = WinLoadPointer( GetResources(), cResName )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, cResName, cIcoFile, bClick, lUpdate, oDlg,;
                    bWhen ) CLASS TIcon

   DEFAULT lUpdate := .f.

   ::nId       = nId
   ::cResName  = cResName
   ::cIcoFile  = cIcoFile
   ::bLClicked = bClick
   ::lUpdate   = lUpdate
   ::oWnd      = oDlg
   ::bWhen     = bWhen

   if ! lRegistered
      ::Register() //  nOR( CS_VREDRAW, CS_HREDRAW ) )
      lRegistered = .t.
   endif

   oDlg:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD SetName( cNewName ) CLASS TIcon

   if ! Empty( cNewName )
      ::cResName = cNewName
      if ::hIcon != 0
         WinDestPointer( ::hIcon )
      endif
      ::hIcon = WinLoadPointer( GetResources(), cNewName )
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TIcon

   if ::lDrag
      return Super:LButtonDown( nRow, nCol, nKeyFlags )
   else
      if ::bLClicked != nil
         Eval( ::bLClicked, nRow, nCol, nKeyFlags )
      endif
      return 0
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetFile( cIcoFile ) CLASS TIcon

   if ! Empty( cIcoFile ) .and. File( cIcoFile )
      ::cIcoFile = cIcoFile
      if ::hIcon != 0
         WinDestPointer( ::hIcon )
      endif
      // ::hIcon = ExtractIcon( cIcoFile )
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Init( hDlg ) CLASS TIcon

   Super:Init( hDlg )

   if ! Empty( ::cIcoFile )
      // ::hIcon = ExtractIcon( ::cIcoFile )
   endif

   if ! Empty( ::cResName )
      ::hIcon = WinLoadPointer( GetResources(), ::cResName )
   endif

return nil

//----------------------------------------------------------------------------//
