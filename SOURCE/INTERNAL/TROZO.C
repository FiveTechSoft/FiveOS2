#define INCL_WINSTDDLGS

#include <pmstddlg.h>

   FILEDLG pfdFiledlg;      /* File dialog info structure           */
   HWND hwndDlg;            /* File dialog window                   */
   HWND hWndMain;
   char szFile[CCHMAXPATH] ; /* File filter string       */
   char szTitle[ 100 ];
   BYTE bIndex = _parni( 3 );


   szFile[0] = '.';
   
   szFile[1] = '\\';
   
   _bcopy( &szFile[2], _parc( 1 ) , _parclen( 1 ) );
   
   _bcopy( szTitle, _parc( 2 ) , _parclen( 2 ) );
   
   szFile[ _parclen( 1 ) + 2 ] = 0;
   
   szTitle[ _parclen( 2 ) ] = 0;

   _xunlock();

   _bset( ( char * ) &pfdFiledlg, 0, sizeof( FILEDLG ) );

 
   pfdFiledlg.cbSize = sizeof(FILEDLG); 
   
   pfdFiledlg.fl = FDS_OPEN_DIALOG;
   
   pfdFiledlg.pszTitle = szTitle;      
   
   _bcopy(pfdFiledlg.szFullFile, szFile , _parclen( 1 ) + 3 ); 
//   _bcopy(pfdFiledlg.szFullFile, "*.*" , 4 ); 
   
   
   hWndMain = WinQueryActiveWindow( HWND_DESKTOP , 0 );
   WinMessageBox(HWND_DESKTOP,
     HWND_DESKTOP,                /* client-window handle  */
     szFile,                     /* body of the message   */
     szTitle,   /* title of the message  */
     0,                         /* message box id        */
     MB_NOICON | MB_OK);        /* icon and button flags */
   hwndDlg = WinFileDlg(HWND_DESKTOP , hWndMain , &pfdFiledlg);
 
   if (hwndDlg && (pfdFiledlg.lReturn == DID_OK)){
   
      _retc(pfdFiledlg.szFullFile);
      
   }
   

