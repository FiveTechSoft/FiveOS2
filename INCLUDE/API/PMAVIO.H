/***************************************************************************\
*
* Module Name: PMAVIO.H
*
* OS/2 Presentation Manager AVIO constants, types and function declarations
*
* Copyright (c) 1989-1990, Microsoft Corporation.  All rights reserved.
*
\***************************************************************************/

#define PMAVIO_INCLUDED

/* common types, constants and function declarations */

typedef USHORT HVPS;		/* hpvs */
typedef HVPS far *PHVPS;	/* phpvs */

/* VioCreatePS format constants */

#define FORMAT_CGA	0x0001
#define FORMAT_4BYTE	0x0003

/* options for VioQueryFonts */

#define VQF_PUBLIC	0x0001L
#define VQF_PRIVATE	0x0002L

USHORT APIENTRY VioAssociate(HDC hdc, HVPS hvps);
USHORT APIENTRY VioCreateLogFont(PFATTRS pfat, LONG lcid, PSTR8 pstr8Name,
				 HVPS hvps);
USHORT APIENTRY VioCreatePS(PHVPS phvps, SHORT cRows, SHORT cColumn,
			    SHORT fFormat, SHORT cAttrBytes, HVPS hvps);
USHORT APIENTRY VioDeleteSetId(LONG llcid, HVPS hvps);
USHORT APIENTRY VioDestroyPS(HVPS hvps);
USHORT APIENTRY VioGetDeviceCellSize(PSHORT psHeight, PSHORT psWidth,
				     HVPS hvps);
USHORT APIENTRY VioGetOrg(PSHORT psRow, PSHORT psColumn, HVPS hvps);
USHORT APIENTRY VioQueryFonts(PLONG plRemfonts, PFONTMETRICS afmMetrics,
			      LONG lMetricsLength, PLONG plFonts,
			      PSZ pszFacename, ULONG flOptions, HVPS hvps);
USHORT APIENTRY VioQuerySetIds(PLONG allcids, PSTR8 pNames,
			       PLONG alTypes, LONG lcount, HVPS hvps);
USHORT APIENTRY VioSetDeviceCellSize(SHORT sHeight, SHORT sWidth, HVPS hvps);
USHORT APIENTRY VioSetOrg(SHORT sRow, SHORT sColumn, HVPS hvps);
USHORT APIENTRY VioShowPS(SHORT sDepth, SHORT sWidth, SHORT soffCell,
			  HVPS hvps);

/************************ Public Function ******************************\
 * WinDefAVioWindowProc -- Default message processing for AVio PS's
\***********************************************************************/

MRESULT APIENTRY WinDefAVioWindowProc(HWND hwnd, USHORT msg, MPARAM mp1,
				      MPARAM mp2);
