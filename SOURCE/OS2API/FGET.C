#define INCL_BASE
#define INCL_WIN
#define INCL_GPI
#define INCL_WINSTDDLGS

#include <Os2Ten.h>
#include <OS2.h>
#include <ClipApi.h>
#include <pmstddlg.h>

void * pascal DosSelToFlat( void * );

/*********************************************************************
 *
 *  Name:   OpenFileDialog
 *
 *  Purpose: open the standard file open dialog as file extention
 *           and return the filename
 *
 *  Usage:   called when the user needs to supply a name for
 *           the file to be opened
 *
 *  Method:  calls the standard file open dialog to get the
 *           file name.
 *
 *  Parameters: HWD hwnd         Handle of the owner window.
 *              PSZ szTitle      Title of open dialog.
 *              PSZ pszFileExt   File extention. (for example : *.txt)
 *              PSZ pszFullPath  PSZ for returning the file name.
 *
 *  Returns: TRUE if successful in getting a file name, FALSE
 *              if not in pushing CANCEL
 *           PSZ pszFullPath pointer to filename (full path)
 *
 **********************************************************************/

static char Drive[]={0,0,0};

CLIPPER cGetFile()
{
   static   PSZ        ppszdefaultdrivelist[] = {NULL};

            FILEDLG    fdg;               /* file dialog structure           */

   HWND hwndOwner = WinQueryActiveWindow( HWND_DESKTOP, 0 );
   PSZ szTitle    = _parc( 2 );
   PSZ szFileExt  = _parc( 1 );

   //PSZ szFullPath = _parc( 3 );

   fdg.cbSize = sizeof(FILEDLG);          /* Size of FILEDLG.                */
   fdg.pszTitle = szTitle;                /* String to display in title bar. */
   fdg.pszOKButton = (PSZ)"Open";         /* String to display in OK button. */
   fdg.ulUser = 0L;                       /* User defined field.             */
   fdg.fl = FDS_HELPBUTTON |              /* FDS flags.                      */
            FDS_CENTER |
            FDS_OPEN_DIALOG;
   fdg.pfnDlgProc = (PFNWP)WinDefDlgProc; /* Entry point to custom*/
                                                  /*         dialog proc. */
   fdg.lReturn = 0L;                      /* Result code from dialog dismissal. */
   fdg.lSRC = 0L;                         /* System return code.          */
   fdg.hMod = 0;                          /* Custom file dialog template. */
   fdg.usDlgId = 0;                       /* Custom file dialog ID.       */
   fdg.x = 0;                             /* X coordinate of the dialog.  */
   fdg.y = 0;                             /* Y coordinate of the dialog.  */

   /* set selected fully qualified path */
   strcpy( fdg.szFullFile, szFileExt);

   fdg.pszIType = NULL;                   /* Pointer to string containing   */
                                          /*   Initial EA type filter.      */
   fdg.papszITypeList = NULL;             /* Pointer to table of pointers   */
                                          /*  that point to null terminated */
   if (!Drive[0])                         /*  Type strings.                 */
       fdg.pszIDrive = NULL;              /* Pointer to string containing   */
   else                                   /*  initial drive.                */
       fdg.pszIDrive = Drive;

   fdg.papszIDriveList = (PAPSZ)ppszdefaultdrivelist;
                                          /* Pointer to table of pointers   */
                                          /*  that point to null terminated */
                                          /*  Drive strings.                */
   fdg.sEAType = 0;                       /* Selected file's EA Type.       */
   fdg.papszFQFilename = NULL;            /* Pointer to table of pointers   */
                                          /*  point to null terminated      */
                                          /*  FQFname strings.              */
   fdg.ulFQFCount = 0L;                   /* Numbers of file selected.      */

   /* get the file */

   if (! WinFileDlg(HWND_DESKTOP, hwndOwner, (PFILEDLG)&fdg) )
      return FALSE;

   if (fdg.lReturn == DID_CANCEL)
      return FALSE;

   /* copy file name into file name buffer */

   // strcpy(szFullPath, fdg.szFullFile);
   // strcpy(szFileExt, fdg.szFullFile);
   // _bcopy(Drive,fdg.szFullFile,2);         /* Always Contains Drive letter */

   // return TRUE;
} /* End of OpenFileDialog */

