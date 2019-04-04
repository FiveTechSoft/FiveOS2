// bitmap file class definition

// Copyright (C) Joel Barnum, Descriptor Systems, 1993

#ifndef _BITMAPFILE_HPP_
#define _BITMAPFILE_HPP_

typedef enum IMAGETYPE { BITMAP, ICON, POINTER, UNKNOWN, ERROR };

class	bitmapfile
{
private:
	PSZ					pszFname;	// bitmap file name
	IMAGETYPE			type;		// bitmap, icon or pointer
	PBITMAPINFO2		pbmp2;		// bitmap info pointer
	PBYTE				pbits;		// bitmap bits pointer
	PBYTE				pfile;		// file data

	PRGB2				pcolor2x;	// 2.x style color table pointer


public:
//********** CONSTRUCTORS *********************************
	bitmapfile ( PSZ pszFnameIn );

//********** DESTRUCTOR ***********************************
	~bitmapfile ( void );

//********** GET/SET MEMBER FUNCTIONS *********************

	void			getfname ( PSZ pszOut );
	IMAGETYPE		gettype  ( void );

	int			getbitsperpel ( void );	// number of bits/pel
	int			getwidth  ( void );		// bitmap width
	int			getheight (	void );		// bitmap height
	PRGB2		getcolortable ( void );	// bitmap color table
	PBYTE		getbitmapbits ( void );	// bitmap data
	PBITMAPINFO2 getbitmapinfo ( void ); // bitmap info structure

};
#endif
