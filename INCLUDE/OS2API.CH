#ifndef _OS2API_CH
#define _OS2API_CH

#define WM_SIZE                   7
#define WM_HITTEST               12    // 0x000C                                
#define WM_SETFOCUS              15
#define WM_COMMAND               32    // 0x0020
#define WM_SYSCOMMAND            33    // 0x0021
#define WM_PAINT                 35    // 0x0023
#define WM_TIMER                 36    // 0x0024
#define WM_CLOSE                 41    // 0x0029
#define WM_QUIT                  42    // 0x002a
#define WM_CONTROL               48    // 0x0030
#define WM_VSCROLL               49    // 0x0031
#define WM_HSCROLL               50    // 0x0032
#define WM_QUERYDLGCODE          58    // 0x003A
#define WM_INITDLG               59    // 0x003B
#define WM_ADJUSTFRAMEPOS        86    // 0x0056  Sacado del Espia
#define WM_MOUSEMOVE            112    // 0x0070
#define WM_BUTTON1DOWN          113    // 0x0071
#define WM_BUTTON1UP            114    // 0x0072
#define WM_BUTTON1DBLCLK        115    // 0x0073
#define WM_BUTTON2DOWN          116    // 0x0074
#define WM_BUTTON2UP            117    // 0x0075
#define WM_BUTTON2DBLCLK        118    // 0x0076
#define WM_CHAR                 122    // 0x007a

//--------------------------------------------------------------------------//              

#define WM_USER               4096   // 0x1000

#define FO_CLICK        (WM_USER+1)
#define FO_SCROLLUP     (WM_USER+2)
#define FO_SCROLLDOWN   (WM_USER+3)
#define FO_LOSTFOCUS    (WM_USER+4)

#define SC_CLOSE             32772

#define SBS_HORZ                 0

#define HWND_TOP                 3
#define HWND_BOTTOM              4

#define DID_OK                   1
#define DID_CANCEL               2

#define BN_CLICKED               1

#define BS_PUSHBUTTON            0
#define BS_AUTOCHECKBOX          2
#define BS_AUTORADIOBUTTON       4
#define BS_HELP                256   // 0x100
#define BS_DEFAULT            1024   // 0x400

#define CBS_DROPDOWN             2
#define CBS_DROPDOWNLIST         4

#define DT_LEFT                  0
#define DT_TOP                   0
#define DT_MNEMONIC           8192   // 0x2000
#define DT_CENTER              256   // 0x0100
#define DT_RIGHT               512   // 0x0200
#define DT_VCENTER            1024   // 0x0400
#define DT_BOTTOM             2048   // 0x0800

#define LM_QUERYITEMCOUNT      352   // 0x0160
#define LM_INSERTITEM          353   // 0x0161
#define LM_DELETEITEM          355   // 0x0163
#define LM_SELECTITEM          356   // 0x0164
#define LM_QUERYSELECTION      357   // 0x0165
#define LM_DELETEALL           366   // 0x016e

#define SS_TEXT                  1
#define SS_BITMAP                4

#define WS_VISIBLE      2147483648   // 0x80000000
#define WS_GROUP             65536   // 0x00010000
#define WS_TABSTOP          131072   // 0x00020000

#define WC_COMBOBOX     4294901762   // 0xFFFF0002
#define WC_BUTTON       4294901763   // 0xFFFF0003
#define WC_STATIC       4294901765   // 0xFFFF0005
#define WC_ENTRYFIELD   4294901766   // 0xFFFF0006
#define WC_LISTBOX      4294901767   // 0xFFFF0007
#define WC_SCROLLBAR    4294901768   // 0xFFFF0008
#define WC_MLE          4294901770   // 0xFFFF000A

#define ES_ANY                   0
#define ES_LEFT                  0
#define ES_CENTER                1
#define ES_RIGHT                 2
#define ES_AUTOSCROLL            4
#define ES_MARGIN                8

#define ID_OK                    1
#define ID_CANCEL                2

/***************************************************************************\
* MLE Window styles ( in addition to WS_* )
\***************************************************************************/
#define MLS_WORDWRAP             1
#define MLS_BORDER               2
#define MLS_VSCROLL              4
#define MLS_HSCROLL              8
#define MLS_READONLY            16
#define MLS_IGNORETAB           32

#define HWND_DESKTOP             1

#define FCF_TITLEBAR             1
#define FCF_SYSMENU              2
#define FCF_SIZEBORDER           8
#define FCF_TASKLIST          2048   // 0x00000800
#define FCF_MINMAX              48   // 0x00000030
#define FCF_SHELLPOSITION     1024   // 0x00000400

#define MM_INSERTITEM          384   // 0x180

#define CS_SIZEREDRAW            4
#define CS_SYNCPAINT      33554432   // 0x02000000
#define CS_SAVEBITS       67108864   // 0x04000000
#define CS_FRAME		           32   // 0x00000020L
#define CS_CLIPCHILDREN  536870912   // 0x20000000L
#define CS_CLIPSIBLINGS  268435456   // 0x10000000L
#define CS_PARENTCLIP	 134217728   // 0x08000000L


#define SBS_VERT                 1


#define SYSCLR_TITLETEXT              -16
#define SYSCLR_ACTIVETITLE            -23
#define SYSCLR_ACTIVETITLETEXT        -28
#define SYSCLR_ACTIVETITLETEXTBGND    -30
#define SYSCLR_BUTTONDEFAULT          -38
#define SYSCLR_BUTTONDARK             -39
#define SYSCLR_BUTTONMIDDLE           -40
#define SYSCLR_BUTTONLIGHT            -41

#define CLR_DEFAULT                    -3
#define CLR_WHITE                      -2
#define CLR_BLACK                      -1
#define CLR_BACKGROUND                  0
#define CLR_BLUE                        1
#define CLR_RED                         2
#define CLR_PINK                        3
#define CLR_GREEN                       4
#define CLR_CYAN                        5
#define CLR_YELLOW                      6
#define CLR_NEUTRAL                     7
#define CLR_DARKGRAY                    8
#define CLR_DARKBLUE                    9
#define CLR_DARKRED                    10
#define CLR_DARKPINK                   11
#define CLR_DARKGREEN                  12
#define CLR_DARKCYAN                   13
#define CLR_BROWN                      14
#define CLR_PALEGRAY                   15

#define SWP_SIZE                        1
#define SWP_MOVE                        2
#define SWP_ZORDER                      4
#define SWP_SHOW                        8

//----------------------------------------------------------------------------

#define BAR_HEIGHT   33
#define BTN_HEIGHT   29
#define BTN_WIDTH    29
#define BAR_TOP      1
#define BAR_LEFT     2
#define BAR_RIGHT    3
#define BAR_ADJUST   4

//----------------------------------------------------------------------------

#define IDLG_ABOUT   1001
#define IDB_OS2      1002
#define IDB_FIVEOS2  1003

//----------------------------------------------------------------------------

#define HE_DONE      0
#define HE_DEFAULT   Nil

//--------------------------------------------------------------------------//
// Scroll Bar Commands */

#define SB_LINEUP		1
#define SB_LINEDOWN		2
#define SB_LINELEFT		1
#define SB_LINERIGHT		2
#define SB_PAGEUP		3
#define SB_PAGEDOWN		4
#define SB_PAGELEFT		3
#define SB_PAGERIGHT		4
#define SB_SLIDERTRACK		5
#define SB_SLIDERPOSITION	6
#define SB_ENDSCROLL		7

//--------------------------------------------------------------------------//

#define VK_BUTTON1               1
#define VK_BUTTON2               2
#define VK_BUTTON3               3
#define VK_BREAK                 4
#define VK_BACKSPACE             5
#define VK_TAB                   6
#define VK_BACKTAB               7
#define VK_NEWLINE               8
#define VK_SHIFT                 9
#define VK_CTRL 		10
#define VK_ALT			11
#define VK_ALTGRAF              12
#define VK_PAUSE		13
#define VK_CAPSLOCK             14
#define VK_ESC			15
#define VK_SPACE		16
#define VK_PAGEUP		17
#define VK_PAGEDOWN             18
#define VK_END			19
#define VK_HOME 		20
#define VK_LEFT 		21
#define VK_UP			22
#define VK_RIGHT		23
#define VK_DOWN 		24
#define VK_PRINTSCRN            25
#define VK_INSERT		26
#define VK_DELETE		27
#define VK_SCRLLOCK             28
#define VK_NUMLOCK              29
#define VK_ENTER		30
#define VK_SYSRQ		31
#define VK_F1			32
#define VK_F2			33
#define VK_F3			34
#define VK_F4			35
#define VK_F5			36
#define VK_F6			37
#define VK_F7			38
#define VK_F8			39
#define VK_F9			40
#define VK_F10			41
#define VK_F11			42
#define VK_F12			43

#define KC_CHAR                  1
#define KC_VIRTUALKEY            2
#define KC_SCANCODE              4

#define KC_SHIFT                 8
#define KC_CTRL                 16
#define KC_ALT                  32
#define KC_KEYUP                64
#define KC_PREVDOWN            128
#define KC_LONEKEY             256
#define KC_DEADKEY             512
#define KC_COMPOSITE          1024
#define KC_INVALIDCOMP        2048

#endif
