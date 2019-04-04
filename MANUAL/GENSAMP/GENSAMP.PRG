#define CRLF Chr(13)+Chr(10)

#define PATH_SAMPLES  "c:\FiveOS2.10\samples\"

//----------------------------------------------------------------------------//

function Main()

   local aFiles := Directory( PATH_SAMPLES + "*.prg" )
   local aPRGs  := {}
   local n
   local cEHT   := "!short: ^BFiveWin samples guide" + CRLF
   local cSamples := ""
   local hFile
   local cLine
   local cName

   cEHT += " ^BFiveWin samples guide" + CRLF
   cEHT += "컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴" + CRLF + CRLF
   cEHT += "  We do recommend learning FiveWin through samples. Try them, modify them," + CRLF
   cEHT += "  feel free to use any part of them you may need." + CRLF
   cEHT += "!short:컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴" + CRLF + CRLF

   AEval( aFiles, { | aFile | AAdd( aPRGs, aFile[ 1 ] ) } )
   aPRGs = ASort( aPRGs )

   for n = 1 to Len( aPRGs )
      hFile = FOpen( PATH_SAMPLES + aPRGs[ n ] )
      cLine = FReadStr( hFile, 80 )
      cEHT += "!short: " + PadR( aPRGs[ n ], 14 ) + ;
              SubStr( cLine, 4, At( CRLF, cLine ) - 4 ) + CRLF
      cName = SubStr( aPRGs[ n ], 1, At( ".", aPRGs[ n ] ) )
      cEHT += "!file: " + cName + "eho" + CRLF
      cEHT += If( File( PATH_SAMPLES + cName + "rc" ),;
                  "!seealso: " + cName + "rc" + CRLF, "" )
      FClose( hFile )
      cSamples += aPRGS[ n ] + CRLF
   next

   MemoWrit( "samples.eht", cEHT )
   MemoWrit( "samples", cSamples )

return nil

//----------------------------------------------------------------------------//
