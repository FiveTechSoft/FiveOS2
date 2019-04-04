#include "FiveOS2.ch"
#include "Browse.ch"

//----------------------------------------------------------------------------//

function Main()

   local oDlg, oBrw

   USE Customer INDEX CustLast

   DEFINE DIALOG oDlg RESOURCE Browse

   REDEFINE LISTBOX oBrw ;
      FIELDS Customer->First, Customer->Last, Customer->Street ;
      HEADERS "First", "Last", "Street" ;
      COLSIZES 100, 100, 100 ;
      ID ID_BROWSE OF oDlg ;
      ON DBLCLICK MsgInfo( "DoubleClick" ) ;
      ON RIGHT CLICK MsgInfo( "RightClick" )

   REDEFINE BUTTON ID ID_NEW OF oDlg ;
      ACTION MsgInfo( "New" )

   REDEFINE BUTTON ID ID_DEL OF oDlg ;
      ACTION ( If( MsgYesNo( "Delete this record ?" ), DbDelete(),),;
               oBrw:SetFocus() )

   REDEFINE BUTTON ID ID_END OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
