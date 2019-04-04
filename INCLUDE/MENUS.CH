#ifndef _MENUS_CH
#define _MENUS_CH

//----------------------------------------------------------------------------//

#xcommand MENU [ <oMenu> ] ;
             [ <popup: POPUP> ] ;
       => ;
          [ <oMenu> := ] MenuBegin( <.popup.> )

#xcommand MENUITEM [ <oMenuItem> PROMPT ] [<cPrompt>] ;
             [ MESSAGE <cMsg> ] ;
             [ <checked: CHECK, CHECKED, MARK> ] ;
             [ <enable: ENABLED, DISABLED> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
             [ <resource: RESOURCE, RESNAME, NAME> <cResName> ] ;
             [ ACTION <uAction> ] ;
             [ BLOCK <bAction> ] ;
             [ <of: OF, MENU, SYSMENU> <oMenu> ] ;
             [ ACCELERATOR <nState>, <nVirtKey> ] ;
             [ <help: HELP> ] ;
       => ;
          [ <oMenuItem> := ] MenuAddItem( <cPrompt>, <cMsg>,;
             <.checked.>, [ Upper(<(enable)>) == "ENABLED" ], <{uAction}>,;
             <cBmpFile>, <cResName>, <oMenu>, <bAction>, <nState>, <nVirtKey>,;
             <.help.> )

#xcommand SEPARATOR => MenuAddItem()

#xcommand ENDMENU => MenuEnd()

//----------------------------------------------------------------------------//
// PopUps Management

#xcommand ACTIVATE <menu:POPUP,MENU> <oMenu> ;
             [ AT <nRow>, <nCol> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          <oMenu>:Activate( <nRow>, <nCol>, <oWnd> )

//----------------------------------------------------------------------------//

#endif
