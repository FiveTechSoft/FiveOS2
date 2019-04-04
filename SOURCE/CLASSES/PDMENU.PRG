#include "FiveOS2.ch"

#define MENU  1
#define ITEMS 2

static aMenus := {}

//----------------------------------------------------------------------------//

function MenuBegin( lPopup, oWnd )

   DEFAULT oWnd := If( Len( aMenus ) > 0, ATail( aMenus )[ MENU ],)

   AAdd( aMenus, { TMenu():New( lPopup, oWnd ), {} } )

return ATail( aMenus )[ MENU ]

//----------------------------------------------------------------------------//

function MenuAddItem( cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile,;
                      cResName, oMenu, bBlock, nVKState, nVirtKey, lHelp )

   local oItem

   DEFAULT oMenu := ATail( aMenus )[ MENU ]

   oItem = TMenuItem():New( cPrompt, cMsg, lChecked, lActive,;
			    If( bBlock != nil, bBlock, bAction ),;
			    cBmpFile, cResName, nVKState, nVirtKey,;
			    lHelp, oMenu )

   AAdd( ATail( aMenus )[ ITEMS ], oItem )

return oItem

//----------------------------------------------------------------------------//

function MenuEnd()

   local oMenu  := ATail( aMenus )[ MENU ]
   local aItems := ATail( aMenus )[ ITEMS ]

   AEval( aItems, { | oItem | oMenu:Add( oItem ) } )

   ASize( aMenus, Len( aMenus ) - 1 )
   if Len( aMenus ) > 0
      ATail( ATail( aMenus )[ ITEMS ] ):bAction = oMenu
   endif

return oMenu

//----------------------------------------------------------------------------//
