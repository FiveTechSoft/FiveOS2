#include "FiveOS2.ch"

//----------------------------------------------------------------------------//

CLASS TIni

   DATA   cIniFile

   METHOD New( cIniFile ) CONSTRUCTOR

   METHOD Get( cSection, cEntry, uDefault, uVar )

   METHOD Set( cSection, cEntry, uValue )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cIniFile ) CLASS TIni

   DEFAULT cIniFile := ""

   if ! Empty( cIniFile ) .and. At( ".", cIniFile ) == 0
      cIniFile  += ".ini"
   endif

   ::cIniFile = cIniFile

return nil

//----------------------------------------------------------------------------//

METHOD Get( cSection, cEntry, uDefault, uVar ) CLASS TIni

   local cType := ValType( If( uDefault != nil, uDefault, uVar ) )

   if cType == "N"
      uVar = PrfQueryInt( cSection, cEntry, uDefault )
   else
      uVar = PrfQueryString( cSection, cEntry, cValToChar( uDefault ) )
   endif

   ::Set( cSection, cEntry, uVar )

   do case
      case cType == "D"
           uVar = CToD( uVar )

      case cType == "L"
           uVar = ( Upper( uVar ) == ".T." )
   endcase

return uVar

//----------------------------------------------------------------------------//

METHOD Set( cSection, cEntry, uValue ) CLASS TIni

return PrfWriteData( cSection, cEntry, uValue )

//----------------------------------------------------------------------------//
