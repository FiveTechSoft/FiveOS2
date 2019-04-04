static aKeys    := {}
static aActions := {}

//----------------------------------------------------------------------------//

function SetKey( nKey, bAction )

   local nAt := AScan( aKeys, nKey )

   if PCount() == 2
      if nAt == 0
         AAdd( aKeys, nKey )
         AAdd( aActions, bAction )
      else
         aKeys[ nAt ]    = nKey
         aActions[ nAt ] = bAction
      endif
   else
      if nAt != 0
         return aActions[ nAt ]
      endif
   endif

return nil

//----------------------------------------------------------------------------//
