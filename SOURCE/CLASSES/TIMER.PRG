#include "FiveOS2.ch"

static aTimers := {}
static nId     := 1

//----------------------------------------------------------------------------//

CLASS TTimer

   DATA   bAction
   DATA   lActive
   DATA   nId, nInterval
   DATA   hWndOwner

   METHOD New( nInterval, bAction, oWnd ) CONSTRUCTOR

   METHOD Activate()

   METHOD DeActivate() INLINE ::lActive := .f.,;
                              WinStopTimer( ::hWndOwner, ::nId )

   METHOD End() INLINE ::DeActivate()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nInterval, bAction, oWnd ) CLASS TTimer

   DEFAULT nInterval := 18, bAction := { || nil }

   ::nInterval = nInterval
   ::bAction   = bAction
   ::nId       = nId++
   ::lActive   = .f.
   ::hWndOwner = If( oWnd != nil, oWnd:hWnd, GetActiveWindow() )

   AAdd( aTimers, Self )

return nil

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TTimer

   ::nId     = WinStartTimer( ::hWndOwner, ::nId, ::nInterval, 0 )
   ::lActive = .t.

return nil

//----------------------------------------------------------------------------//

function TimerEvent( nId )

   local nTimer := AScan( aTimers, { | oTimer | oTimer:nId == nId } )

   if nTimer != 0
      Eval( aTimers[ nTimer ]:bAction )
   endif

return 0

//----------------------------------------------------------------------------//
