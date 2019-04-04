// FiveOS2 : CA-Clipper for IBM-OS2 library demo.
// (c) Antonio Linares & Francisco Pulp¢n, 1993-4
// CA-Clipper (c) Computer Associates

// Five technology is based on CA-Clipper 5 and xBase power.
// FiveOS2 is builted upon four complementary levels:
//
//    * xBase Commands:            Highest productivity and simplicity.
//    * Classes & Objects:         Reusability and encapsulation benefits.
//    * Functions & Structures:    Modularity benefits.
//    * IBM-OS2 PM API Conection:  Highest low-level power
//
// FiveOS2 is an object oriented product which uses the power of
// xBase languages.

#include "FiveOS2.ch"

#define CLIENTS     100

static oWnd

//----------------------------------------------------------------------------//

function Main()

   DEFINE WINDOW oWnd TITLE "FiveOS2 1.0 - CA-Clipper for IBM-OS2 library" 

   @ 20, 100 BUTTON "~Bye" OF oWnd ACTION Draw(oWnd)

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Do you want to end ?" )

return nil

Function draw(oWnd)
	Local hBmp,hPs
	MsgInfo(" hHwnd: " +str(oWnd:hWndClient))
	hPs := WinGetPs(oWnd:hWndClient)
	MsgInfo(" hPs  : " +str(hPs))
	hBmp := GpiLoadBitmap(hPs,0,100,0,0)
	MsgInfo(" hBmp : " +str(hBmp))
	MsgInfo(IF(WinDrawBitMap(hPS,hBmp,0,{100,100},0,0) ,"Verdadero","Falso"))
	WinRelPS(hPS)
return nil
