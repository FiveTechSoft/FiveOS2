#include "FiveOS2.ch"

static nId := 110

//----------------------------------------------------------------------------//

CLASS TMenuItem

   DATA   cPrompt, cMsg
   DATA   nId
   DATA   bAction
   DATA   lChecked, lActive, lHelp
   DATA   oMenu
   DATA   hBitmap

   METHOD New( cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile,;
               cResName, nVKState, nVirtKey, lHelp ) CONSTRUCTOR

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile, cResName,;
            nVKState, nVirtKey, lHelp ) CLASS TMenuItem

   DEFAULT lChecked := .f., lActive := .t., cBmpFile := "",;
           lHelp := .f.

   ::bAction  = bAction
   ::cPrompt  = cPrompt
   ::cMsg     = cMsg
   ::nId      = nId++
   ::lChecked = lChecked
   ::lActive  = lActive
   ::lHelp    = lHelp
   ::hBitmap  = 0

   /*
   if ! Empty( cBmpFile )
      ::hBitmap = ReadBitmap( 0, cBmpFile )
   endif
   if ! Empty( cResName )
      ::hBitmap = LoadBitmap( GetResources(), cResName )
   endif

   if nVirtKey != nil
      __AddAccel( nVKState, nVirtKey, ::nId )
   endif
   */

return nil

//----------------------------------------------------------------------------//
