/*************
*   Errsyso.prg
*   From Standard Clipper 5.0 error handler
*	Compile:  /m/n/w
*/

#include "error.ch"
#include "FiveOS2.ch"

#define NTRIM(n)		( LTrim(Str(n)) )

/*************
*	ErrorSys()
*
*	Note:  automatically executes at startup
*/
proc ErrorSys()
    ErrorBlock( { | e | ErrorDialog( e ) } )
return


#define  CRLF          chr( 13 ) + chr( 10 )

/*************
*   ErrorDialog()
*/
static func ErrorDialog( e ) // -> logical  or quits App.

   local i, cStack := ""
   local nButtons := 1

   

   // by default, division by zero yields zero
   if ( e:genCode == EG_ZERODIV )
       return (0)
   end


   // for network open error, set NETERR() and subsystem default
   if ( e:genCode == EG_OPEN .and. e:osCode == 32 .and. e:canDefault )

       NetErr(.t.)
       return .f.       // Warning: Exiting!

   end


   // for lock error during APPEND BLANK, set NETERR() and subsystem default
   if ( e:genCode == EG_APPENDLOCK .and. e:canDefault )

       NetErr(.t.)
       return .f.       // OJO SALIDA

   endif

   if e:canRetry
      nButtons++
   endif

   if e:canDefault
      nButtons++
   endif


   // build error message
   cStack := ErrorMessage(e) + CRLF


   i := 2
   while ( i < 14 )

       if !Empty(ProcName(i))
          cStack += "Called from " + Trim(ProcName(i)) + ;
                        "(" + NTRIM(ProcLine(i)) + ")" + ;
                        if( i < 13, CRLF, "" )
       endif

       i++
   end


   MsgInfo( cStack, FO_VERSION + " Error Info" )

   ErrorLevel(1)
   QUIT              // OJO QUIT

return .f.


/*************
*	ErrorMessage()
*/
static func ErrorMessage(e)

	// start error message
    local cMessage := if( empty( e:osCode ), ;
                          if( e:severity > ES_WARNING, "Error ", "Warning " ),;
                          "(DOS Error " + NTRIM(e:osCode) + ") " )

	// add subsystem name if available
    cMessage += if( ValType( e:subsystem ) == "C",;
                    e:subsystem()                ,;
                    "???" )

	// add subsystem's error code if available
    cMessage += if( ValType( e:subCode ) == "N",;
                    "/" + NTRIM( e:subCode )   ,;
                    "/???" )
	// add error description if available
	if ( ValType(e:description) == "C" )
        cMessage += "  " + e:description
	end

	// add either filename or operation
    cMessage += if( !Empty( e:filename ),;
                    ": " + e:filename   ,;
                    if( !Empty( e:operation ),;
                        ": " + e:operation   ,;
                        "" ) )
return cMessage
