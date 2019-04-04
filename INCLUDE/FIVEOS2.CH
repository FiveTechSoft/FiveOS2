#ifndef _FIVEOS2_CH
#define _FIVEOS2_CH

#define FO_VERSION     "FiveOS2 0C"
#define FO_COPYRIGHT   "A.Linares, F.Pulpon, I.Ortega 1993-4"

#include "OS2Api.ch"
#include "Ini.ch"
#include "Menus.ch"
#include "Objects.ch"

#define CRLF Chr(13)+Chr(10)

#translate RGB( <nRed>, <nGreen>, <nBlue> ) => ;
              ( <nRed> + ( <nGreen> * 256 ) + ( <nBlue> * 65536 ) )

//----------------------------------------------------------------------------//
// ACCESSING / SETTING Variables

#xtranslate bSETGET(<uVar>) => ;
            { | u | If( PCount() == 0, <uVar>, <uVar> := u ) }

//----------------------------------------------------------------------------//
// Windows

#xcommand DEFINE WINDOW <oWnd> ;
             [ FROM <nTop>,<nLeft> TO <nBottom>,<nRight> ] ;
             [ STYLE <nStyle> ] ;
             [ TITLE <cTitle> ] ;
             [ MENU <oMenu> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWndParent> ] ;
             [ ICON <oIco> ] ;
       => ;
          <oWnd> := TWindow():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
              <cTitle>, <nStyle>, <oMenu>, <oWndParent>, <oIco> )

#xcommand ACTIVATE WINDOW <oWnd> ;
             [ VALID <uValid> ] ;
             [ <show: ICONIZED, NORMAL, MAXIMIZED> ] ;
       => ;
          <oWnd>:Activate( [Upper(<(show)>)], <{uValid}> )

//----------------------------------------------------------------------------//
// Dialog

#xcommand DEFINE DIALOG <oDlg> ;
             [ RESOURCE <nResource> ] ;
             [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
             [ TITLE <cTitle> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          <oDlg> := TDialog():ReDefine( <nResource>, <nTop>, <nLeft>,;
             <nBottom>, <nRight>, <cTitle>, <oWnd> )

#xcommand ACTIVATE DIALOG <oDlg> ;
             [ <center: CENTERED> ] ;
             [ VALID <uValid> ] ;
       => ;
          <oDlg>:Activate( <{uValid}>, <.center.> )

/*----------------------------------------------------------------------------//
!short: PUSHBUTTON */

#xcommand @ <nRow>, <nCol> BUTTON [ <oBtn> PROMPT ] <cCaption> ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ACTION <uAction> ] ;
             [ <default: DEFAULT> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
             [ FONT <oFont> ] ;
             [ <pixel: PIXEL> ] ;
             [ <design: DESIGN> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
             [ VALID <uValid> ] ;
      => ;
         [ <oBtn> := ] TButton():New( <nRow>, <nCol>, <cCaption>, <oWnd>,;
            <{uAction}>, <nWidth>, <nHeight>, <nHelpId>, <oFont>, <.default.>,;
            <.pixel.>, <.design.>, <cMsg>, <.update.>, <{WhenFunc}>, <{uValid}> )

#xcommand REDEFINE BUTTON [ <oBtn> ] ;
             [ ID <nId> <of:OF, WINDOW, DIALOG> <oDlg> ] ;
             [ ACTION <uAction> ] ;
             [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
             [ VALID <uValid> ] ;
       => ;
          [ <oBtn> := ] TButton():ReDefine( <nId>, <{uAction}>, <oDlg>,;
             <nHelpId>, <cMsg>, <.update.>, <{WhenFunc}>, <{uValid}> )

/*----------------------------------------------------------------------------//
!short: GET  */

#xcommand REDEFINE GET [ <oGet> VAR ] <uVar> ;
             [ <memo: MULTILINE, MEMO, TEXT> ] ;
             [ ID <nId> ] ;
             [ <dlg: OF, WINDOW, DIALOG> <oDlg> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <color: COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ <readonly: READONLY, NO MODIFY> ] ;
             [ VALID <uValid> ] ;
       => ;
          [ <oGet> := ] TMultiGet():ReDefine( <nId>, bSETGET(<uVar>),;
             <oDlg>, <nHelpId>, <nClrFore>, <nClrBack>, <oFont>, <oCursor>,;
             <cMsg>, <.update.>, <{uWhen}>, <.readonly.>, <{uValid}> )

#xcommand REDEFINE GET [ <oGet> VAR ] <uVar> ;
             [ ID <nId> ] ;
             [ <dlg: OF, WINDOW, DIALOG> <oDlg> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ VALID   <ValidFunc> ]       ;
             [ PICTURE <cPict> ] ;
             [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ ON CHANGE <uChange> ] ;
             [ <readonly: READONLY, NO MODIFY> ] ;
       => ;
          [ <oGet> := ] TGet():ReDefine( <nId>, bSETGET(<uVar>), <oDlg>,;
             <nHelpId>, <cPict>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
             <oFont>, <oCursor>, <cMsg>, <.update.>, <{uWhen}>,;
             [ \{|nKey,nFlags,Self| <uChange> \}], <.readonly.> )

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
            [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ <memo: MULTILINE, MEMO, TEXT> ] ;
            [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
            [ SIZE <nWidth>, <nHeight> ] ;
            [ FONT <oFont> ] ;
            [ <hscroll: HSCROLL> ] ;
            [ CURSOR <oCursor> ] ;
            [ <pixel: PIXEL> ] ;
            [ MESSAGE <cMsg> ] ;
            [ <update: UPDATE> ] ;
            [ WHEN <uWhen> ] ;
            [ <lCenter: CENTER, CENTERED> ] ;
            [ <lRight: RIGHT> ] ;
            [ <readonly: READONLY, NO MODIFY> ] ;
            [ VALID <uValid> ] ;
       => ;
          [ <oGet> := ] TMultiGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             [<oWnd>], <nWidth>, <nHeight>, <oFont>, <.hscroll.>,;
             <nClrFore>, <nClrBack>, <oCursor>, <.pixel.>,;
             <cMsg>, <.update.>, <{uWhen}>, <.lCenter.>,;
             <.lRight.>, <.readonly.>, <{uValid}> )

#command @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
            [ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ PICTURE <cPict> ] ;
            [ VALID <ValidFunc> ] ;
            [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
            [ SIZE <nWidth>, <nHeight> ]  ;
            [ FONT <oFont> ] ;
            [ <design: DESIGN> ] ;
            [ CURSOR <oCursor> ] ;
            [ <pixel: PIXEL> ] ;
            [ MESSAGE <cMsg> ] ;
            [ <update: UPDATE> ] ;
            [ WHEN <uWhen> ] ;
            [ <lCenter: CENTER, CENTERED> ] ;
            [ <lRight: RIGHT> ] ;
            [ ON CHANGE <uChange> ] ;
             [ <readonly: READONLY, NO MODIFY> ] ;
       => ;
          [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
             <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
             <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
             <.lCenter.>, <.lRight.>,;
             [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.> )

//----------------------------------------------------------------------------//
// ScrollBars

#xcommand @ <nRow>, <nCol> SCROLLBAR [<oSbr>] ;
             [ <v: VERTICAL> ] ;
             [ <h: HORIZONTAL> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <up: ON UP, ON LEFT> <uUp> ] ;
             [ <down: ON DOWN, ON RIGHT> <uDown> ] ;
             [ RANGE <nMin>, <nMax> ] ;
       => ;
          [ <oSbr> := ] TScrollBar():New( <nRow>, <nCol>, <nWidth>,;
             <nHeight>, ! <.v.> [ .or. <.h.> ],;
             [<{uUp}>], [<{uDown}>], <nMin>, <nMax>, <oWnd> )

#xcommand REDEFINE SCROLLBAR [<oSbr>] ;
             [ ID <nId> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <up: ON UP, ON LEFT> <uUp> ] ;
             [ <down: ON DOWN, ON RIGHT> <uDown> ] ;
             [ RANGE <nMin>, <nMax> ] ;
       => ;
          [ <oSbr> := ] TScrollBar():ReDefine( <nId>, <oWnd>, <{uUp}>,;
             <{uDown}>, <nMin>, <nMax> )

/*----------------------------------------------------------------------------//
!short: LISTBOX */

#xcommand REDEFINE LISTBOX [ <oLbx> VAR ] <cnVar> ;
             [ <items: ITEMS, PROMPTS> <aItems> ]  ;
             [ FILES <cFileSpec> ] ;
             [ ID <nId> ] ;
             [ ON CHANGE <uChange> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ <of: OF, WINDOW, DIALOG > <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <bitmaps: BITMAPS > [ SIZE <nSize> ] ] ;
             [ VALID <uValid> ] ;
             [ <color: COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
       => ;
          [ <oLbx> := ] TListBox():ReDefine( <nId>, bSETGET(<cnVar>), <aItems>,;
             <{uChange}>, <oWnd>, <nHelpId>, <.bitmaps.>, <nSize>, ;
             <{uValid}>, <cFileSpec>, <nClrFore>, <nClrBack>,;
             <{uLDblClick}>, <cMsg>, <.update.>, <{uWhen}> )

#xcommand @ <nRow>, <nCol> LISTBOX [ <oLbx> VAR ] <cnVar> ;
             [ <items: ITEMS, PROMPTS> <aList>  ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ON CHANGE <uChange> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ <of: OF, WINDOW, DIALOG > <oWnd> ] ;
             [ VALID <uValid> ] ;
             [ <color: COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ <pixel: PIXEL> ] ;
             [ <design: DESIGN> ] ;
             [ FONT <oFont> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
       => ;
          [ <oLbx> := ] TListBox():New( <nRow>, <nCol>, bSETGET(<cnVar>),;
             <aList>, <nWidth>, <nHeight>, <{uChange}>, <oWnd>, <{uValid}>,;
             <nClrFore>, <nClrBack>, <.pixel.>, <.design.>, <{uLDblClick}>,;
             <oFont>, <cMsg>, <.update.>, <{uWhen}> )

//----------------------------------------------------------------------------//
// ComboBox

#xcommand @ <nRow>, <nCol> COMBOBOX [ <oCbx> VAR ] <cVar> ;
             [ ITEMS <aItems> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             bSETGET(<cVar>), <aItems>, <oWnd> )

#xcommand REDEFINE COMBOBOX [ <oLbx> VAR ] <cVar> ;
             [ ID <nId> ] ;
             [ ITEMS <aItems> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ ON CHANGE <uChange> ] ;
       => ;
          [ <oLbx> := ] TComboBox():ReDefine( <nId>, bSETGET(<cVar>),;
             <aItems>, <{uChange}>, <oWnd> )

/*----------------------------------------------------------------------------//
!short: CHECKBOX */

#xcommand REDEFINE CHECKBOX [ <oCbx> VAR ] <lVar> ;
             [ ID <nId> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <click:ON CLICK, ON CHANGE> <uClick> ];
             [ VALID <uValid> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
       => ;
          [ <oCbx> := ] TCheckBox():ReDefine( <nId>, bSETGET(<lVar>),;
             <oWnd>, <nHelpId>, [<{uClick}>], <{uValid}>, <nClrFore>,;
             <nClrBack>, <cMsg>, <.update.>, <{uWhen}> )

#xcommand @ <nRow>, <nCol> CHECKBOX [ <oCbx> VAR ] <lVar> ;
             [ PROMPT <cCaption> ] ;
             [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ FONT <oFont> ] ;
             [ <change: ON CLICK, ON CHANGE> <uClick> ] ;
             [ VALID   <ValidFunc> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ <design: DESIGN> ] ;
             [ <pixel: PIXEL> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
      => ;
         [ <oCbx> := ] TCheckBox():New( <nRow>, <nCol>, <cCaption>,;
             [bSETGET(<lVar>)], <oWnd>, <nWidth>, <nHeight>, <nHelpId>,;
             [<{uClick}>], <oFont>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
             <.design.>, <.pixel.>, <cMsg>, <.update.>, <{WhenFunc}> )

//----------------------------------------------------------------------------//
// RADIOBUTTONS

#xcommand @ <nRow>, <nCol> RADIO [ <oRadMenu> VAR ] <nVar> ;
             [ <prm: PROMPT, ITEMS> <cItems,...> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
       => ;
          [ <oRadMenu> := ] TRadMenu():New( <nRow>, <nCol>, {<cItems>},;
             [bSETGET(<nVar>)], <oWnd>, <nHelpId>, <{uChange}>,;
             <nClrFore>, <nClrBack>, <cMsg>, <.update.>, <{WhenFunc}>,;
             <nWidth>, <nHeight> )

#xcommand REDEFINE RADIO [ <oRadMenu> VAR ] <nVar> ;
             [ ID <nId,...> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
             [ COLOR <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <WhenFunc> ] ;
       => ;
          [ <oRadMenu> := ] TRadMenu():Redefine( [bSETGET(<nVar>)],;
             <oWnd>, <nHelpId>, \{ <nId> \}, <{uChange}>, <nClrFore>,;
             <nClrBack>, <cMsg>, <.update.>, <{WhenFunc}> )

//----------------------------------------------------------------------------//
// ButtonBar

#xcommand DEFINE BUTTONBAR [<oBar>] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [<oBar> := ] TBar():New( <oWnd> )

#xcommand DEFINE BUTTON [<oBtn>] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <resname: RESOURCE, NAME, RESNAME> <cResName1> [,<cResName2>] ] ;
             [ <bmpname: FILE, FILENAME, DISK> <cBmpFile1> [,<cBmpFile2>] ] ;
             [ ACTION <uAction> ] ;
             [ <lGroup: GROUP > ] ;
       => ;
          [<oBtn> :=] TBtnBmp():NewBar( <cResName1>, <cResName2>,;
             <cBmpFile1>, <cBmpFile2>, <cMsg>, [<{uAction}>] , <.lGroup.> , <oWnd> )

//----------------------------------------------------------------------------//
// MessageBar

#xcommand DEFINE MSGBAR [<oMsgBar>] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ PROMPT <cMsg> ] ;
       => ;
          [ <oMsgBar> := ] TMsgBar():New( <oWnd>, <cMsg> )

#xcommand SET MESSAGE [<oMsgBar>];
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ TO <cMsg> ] ;
       => ;
          [<oMsgBar> := ] TMsgBar():New( <oWnd>, <cMsg> )

/*----------------------------------------------------------------------------//
!short: SAY  */

#xcommand REDEFINE SAY [<oSay>] ;
             [ <label: PROMPT, VAR> <cText> ] ;
             [ PICTURE <cPict> ] ;
             [ ID <nId> ] ;
             [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
             [ <color: COLOR,COLORS > <nClrText> [,<nClrBack> ] ] ;
             [ <update: UPDATE > ] ;
             [ FONT <oFont> ] ;
       => ;
          [ <oSay> := ] TSay():ReDefine( <nId>, <{cText}>, <oWnd>, ;
                        <cPict>, <nClrText>, <nClrBack>, <.update.>, <oFont> )

#xcommand @ <nRow>, <nCol> SAY [ <oSay> <label: PROMPT,VAR > ] <cText> ;
             [ PICTURE <cPict> ] ;
             [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
             [ FONT <oFont> ]  ;
             [ <lCenter: CENTERED, CENTER > ] ;
             [ <lRight:  RIGHT >    ] ;
             [ <lBorder: BORDER >   ] ;
             [ <lPixel: PIXEL, PIXELS > ] ;
             [ <color: COLOR,COLORS > <nClrText> [,<nClrBack> ] ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <design: DESIGN >  ] ;
             [ <update: UPDATE >  ] ;
             [ <lShaded: SHADED, SHADOW > ] ;
             [ <lBox:    BOX   >  ] ;
             [ <lRaised: RAISED > ] ;
      => ;
          [ <oSay> := ] TSay():New( <nRow>, <nCol>, <{cText}>,;
             [<oWnd>], [<cPict>], <oFont>, <.lCenter.>, <.lRight.>, <.lBorder.>,;
             <.lPixel.>, <nClrText>, <nClrBack>, <nWidth>, <nHeight>,;
             <.design.>, <.update.>, <.lShaded.>, <.lBox.>, <.lRaised.> )

/*----------------------------------------------------------------------------//
!short: LISTBOX - BROWSE */
// Warning: SELECT <cField>  ==> Must be the Field key of the current INDEX !!!

#xcommand REDEFINE LISTBOX [ <oLbx> ] FIELDS [<Flds,...>] ;
             [ ALIAS <cAlias> ] ;
             [ ID <nId> ] ;
             [ <dlg:OF,DIALOG> <oDlg> ] ;
             [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
             [ <head:HEAD,HEADER,HEADERS> <aHeaders,...> ] ;
             [ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
             [ <change: ON CHANGE, ON CLICK> <uChange> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ ON RIGHT CLICK <uRClick> ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
       => ;
              [ <oLbx> := ] TWBrowse():ReDefine( <nId>, ;
              [\{|| \{ <Flds> \} \}], <oDlg>,;
              [ \{<aHeaders>\}], [\{<aColSizes>\}],;
              <(cField)>, <uValue1>, <uValue2>,;
              [<{uChange}>],;
              [\{|nRow,nCol,nFlags|<uLDblClick>\}],;
              [<{uRClick}>], <oFont>,;
              <oCursor>, <nClrFore>, <nClrBack>, <cMsg>, <.update.>,;
              <cAlias>, <{uWhen}>, <{uValid}> )

#xcommand @ <nRow>, <nCol> LISTBOX [ <oBrw> ] FIELDS [<Flds,...>] ;
               [ ALIAS <cAlias> ] ;
               [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
               [ <head:HEAD,HEADER,HEADERS> <aHeaders,...> ] ;
               [ SIZE <nWidth>, <nHeigth> ] ;
               [ <dlg:OF,DIALOG> <oDlg> ] ;
               [ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
               [ <change: ON CHANGE, ON CLICK> <uChange> ] ;
               [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
               [ ON RIGHT CLICK <uRClick> ] ;
               [ FONT <oFont> ] ;
               [ CURSOR <oCursor> ] ;
               [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
               [ MESSAGE <cMsg> ] ;
               [ <update: UPDATE> ] ;
               [ <pixel: PIXEL> ] ;
               [ WHEN <uWhen> ] ;
               [ <design: DESIGN> ] ;
               [ VALID <uValid> ] ;
      => ;
          [ <oBrw> := ] TWBrowse():New( <nRow>, <nCol>, <nWidth>, <nHeigth>,;
                           [\{|| \{<Flds> \} \}], ;
                           [\{<aHeaders>\}], [\{<aColSizes>\}], ;
                           <oDlg>, <(cField)>, <uValue1>, <uValue2>,;
                           [<{uChange}>],;
                           [\{|nRow,nCol,nFlags|<uLDblClick>\}],;
                           [<{uRClick}>],;
                           <oFont>, <oCursor>, <nClrFore>, <nClrBack>, <cMsg>,;
                           <.update.>, <cAlias>, <.pixel.>, <{uWhen}>,;
                           <.design.>, <{uValid}> )

/*----------------------------------------------------------------------------//
!short: Timer  */

#xcommand DEFINE TIMER [ <oTimer> ] ;
             [ INTERVAL <nInterval> ] ;
             [ ACTION <uAction> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [ <oTimer> := ] TTimer():New( <nInterval>, [<{uAction}>], <oWnd> )

#xcommand ACTIVATE TIMER <oTimer> => <oTimer>:Activate()

/*----------------------------------------------------------------------------//
!short: Icons */

#xcommand @ <nRow>, <nCol> ICON [ <oIcon> ] ;
             [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
             [ <border:BORDER> ] ;
             [ ON CLICK <uClick> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
       => ;
          [ <oIcon> := ] TIcon():New( <nRow>, <nCol>, <cResName>,;
             <cIcoFile>, <.border.>, <{uClick}>, <oWnd>, <.update.>,; 
             <{uWhen}> )

#xcommand REDEFINE ICON <oIcon> ;
             [ ID <nId> ] ;
             [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
             [ ON CLICK <uClick> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen> ] ;
       => ;
          [ <oIcon> := ] TIcon():ReDefine( <nId>, <cResName>, <cIcoFile>,;
             <{uClick}>, <.update.>, <oWnd>, <{uWhen}> )

#xcommand DEFINE ICON <oIcon> ;
             [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
             [ WHEN <WhenFunc> ] ;
       => ;
          <oIcon> := TIcon():New( ,, <cResName>, <cIcoFile>, <{WhenFunc}> )

//----------------------------------------------------------------------------//

#endif
