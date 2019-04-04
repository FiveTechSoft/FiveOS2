// bitmap file class definition

// Copyright (C) Joel Barnum, Descriptor Systems, 1993

#define INCL_PM
#include <os2.h>
#include <string.h>
#include <io.h>
#include <stdio.h>
#include <stdlib.h>
#include "bitfile.hpp"

#define	MAXFNAME	255

//*********************************************************
// constructor: create from a file name
//*********************************************************
bitmapfile::bitmapfile ( PSZ pszFnameIn )
{

  // setup

	type = ERROR;
8        pszFname = new char [strlen (pszFnameIn) + 1];

	if ( pszFname )
		strcpy ( pszFname, pszFnameIn );
 	else
		return;

  // open the input file and read
    FILE    *f;             // file descriptor

    f = fopen ( pszFname, "rb" );

  // determine the file's size
    LONG    cbFile;         // file length

    if ( f != NULL )
        cbFile = _filelength ( _fileno ( f ) );
	else
		type = ERROR;

  // allocate memory for the file buffer
    CHAR    *pfile;

    if ( cbFile != 0 )
        pfile = (CHAR *)malloc ( cbFile );
	else
		type = ERROR;

  // read the file
    ULONG   cbRead;

    if ( pfile != 0 )
        cbRead = fread ( pfile, cbFile, 1, f );
	else
		type = ERROR;

  // verify that the file is really an image file
    PBITMAPARRAYFILEHEADER2 pbafh2;
    PBITMAPFILEHEADER2      pbfh2; 		// embedded struct

    if ( cbRead != 0 )
    {
		switch ( *(PUSHORT)pfile )
		{

			case 0x4d42:	// single image bitmap file
				pbfh2 = (PBITMAPFILEHEADER2)pfile;
	
			  // construct a pointer to the bitmap bits
				pbits = (PBYTE)pbfh2 + pbfh2->offBits;
	
				type = BITMAP;
				break;
	
			case 0x4142: 	// multiple image file
	
			  // construct pointer to the embedded
			  // BITMAPFILEHEADER2 struct
				pbafh2 = (PBITMAPARRAYFILEHEADER2)pfile;
				pbfh2 = &pbafh2->bfh2;
	
			  // make sure the it's a bitmap resource
			  // instead of an icon or a pointer
				if ( pbfh2->usType == 0x4d42 )
				{
				  // construct a pointer to the bitmap bits
					pbits = (PBYTE)pbafh2 + pbfh2->offBits;
	
					type = BITMAP;
				}
				else
					type = UNKNOWN;
				break;
	
			default:
				type = UNKNOWN;
				break;
		}
    }
	else
		type = ERROR;

  // build pointers to data within the bitmap file
    if ( type == BITMAP )
    {
      // construct a pointer to the BITMAPINFOHEADER2
      // embedded in the BITMAPILEHEADER2
        pbmp2 = (PBITMAPINFO2)&pbfh2->bmp2;

	  // if it's a 1.x style bitmap stored in the file,
	  // create a 2.x style color table
		if ( pbmp2->cbFix == sizeof ( BITMAPINFOHEADER ) )
		{
		  // allocate memory for a 2.x-style color table
		  // and copy from the 1,x color table stored in the file
			ULONG 	cColors = 1 << getbitsperpel ();
			ULONG	cb;
	
			cb = sizeof ( RGB2 ) * cColors;
			pcolor2x = (PRGB2)malloc ( cb );
	
			if ( pcolor2x )
			{
				for ( int i = 0; i < cColors; i++ )
				{
					pcolor2x[i].bRed = ((PBITMAPINFO)pbmp2)->argbColor[i].bRed;
					pcolor2x[i].bBlue = ((PBITMAPINFO)pbmp2)->argbColor[i].bBlue;
					pcolor2x[i].bGreen = ((PBITMAPINFO)pbmp2)->argbColor[i].bGreen;
					pcolor2x[i].fcOptions = 0;
				}
			}
		}
    }

  // clean up and return
    if ( f != 0 )
        fclose ( f );
}

//*********************************************************
// destructor
//*********************************************************
bitmapfile::~bitmapfile ( void )
{
	if ( pszFname )
		delete [] pszFname;

	if ( pfile )
		free ( pfile );

	if ( pcolor2x )
		free ( pcolor2x );
}


//*********************************************************
// getfname: retrieve the current filename
//*********************************************************
void bitmapfile::getfname ( PSZ pszOut )
{
	if ( pszOut != NULL )
		strcpy ( pszOut, pszFname );
}


//*********************************************************
// gettype: return the file type: bitmap, icon or pointer
//*********************************************************
IMAGETYPE bitmapfile::gettype  ( void )
{
	return type;
}

//*********************************************************
// getbitsperpel: return the number of bits/pixel
//
// A bitmap file can contain 1.x or 2.x style bitmaps.
// We always return as if it's a 2.x style
//*********************************************************
int bitmapfile::getbitsperpel ( void )
{
	if ( pbmp2->cbFix > sizeof (BITMAPINFOHEADER) )
		return pbmp2->cBitCount;
	else if ( pbmp2->cbFix == sizeof (BITMAPINFOHEADER) )
		return ((PBITMAPINFOHEADER)pbmp2)->cBitCount;
	else
		return 0;
}

//*********************************************************
// getwidth: return the bitmap's width
//
// A bitmap file can contain 1.x or 2.x style bitmaps.
// We always return as if it's a 2.x style
//*********************************************************
int bitmapfile::getwidth  ( void )
{
	if ( pbmp2->cbFix > sizeof (BITMAPINFOHEADER) )
		return pbmp2->cx;
	else if ( pbmp2->cbFix == sizeof (BITMAPINFOHEADER) )
		return ((PBITMAPINFOHEADER)pbmp2)->cx;
	else
		return 0;
}

//*********************************************************
// getheigt: return the bitmap's height
//
// A bitmap file can contain 1.x or 2.x style bitmaps.
// We always return as if it's a 2.x style
//*********************************************************
int bitmapfile::getheight ( void )
{
	if ( pbmp2->cbFix > sizeof (BITMAPINFOHEADER) )
		return pbmp2->cy;
	else if ( pbmp2->cbFix == sizeof (BITMAPINFOHEADER) )
		return ((PBITMAPINFOHEADER)pbmp2)->cy;
	else
		return 0;
}

//*********************************************************
// getcolortable: return a pointer to the bitmap's color
//				  table
//
// A bitmap file can contain 1.x or 2.x style bitmaps.
// We always return as if it's a 2.x style
//*********************************************************
PRGB2 bitmapfile::getcolortable ( void )
{
	if ( pbmp2->cbFix > sizeof (BITMAPINFOHEADER) )
		return pbmp2->argbColor;
	else if ( pbmp2->cbFix == sizeof (BITMAPINFOHEADER) )
	{
		return pcolor2x;
	}
	else
		return NULL;
}

//********************************************************
// getbitmapbits: return a pointer to the bitmap data
//*********************************************************
PBYTE bitmapfile::getbitmapbits ( void )
{
	return pbits;
}

//********************************************************
// getbitmapinfo: return a pointer to the bitmap info
//				  structure
//*********************************************************
PBITMAPINFO2 bitmapfile::getbitmapinfo ( void )
{
	return pbmp2;
}


