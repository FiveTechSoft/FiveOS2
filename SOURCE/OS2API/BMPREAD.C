#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

//----------------------------------------------------------------------------//

CLIPPER READBITMAP()
{
   HDC hDC = _parni( 1 );
   HFILE hFile;
   LONG lSize;
   HANDLE hDib;
   void huge * pData;
   HBITMAP hBitmap = 0;
   BITMAPFILEHEADER Header;
   BOOL bDestroyDC = ( hDC == 0 );

   if( hFile = _lopen( _parc( 2 ), READ ) )
   {
      if( hDib = GlobalAlloc( GMEM_MOVEABLE | GMEM_DISCARDABLE,
                              lSize = _llseek( hFile, 0, 2 ) ) )
      {
         _llseek( hFile, 0, 0 );
         _lread( hFile, &Header, sizeof( BITMAPFILEHEADER ) );
         _hread( hFile, pData = GlobalLock( hDib ),
                 lSize - sizeof( BITMAPFILEHEADER ) );

         if( bDestroyDC )
             hDC = GetDC( 0 );

         hBitmap = CreateDIBitmap( hDC,
                                   pData,
                                   CBM_INIT,
          ( LPSTR ) pData + Header.bfOffBits - sizeof( BITMAPFILEHEADER ),
                                   pData,
                                   DIB_RGB_COLORS );
         if( bDestroyDC )
             ReleaseDC( 0, hDC );

         GlobalUnlock( hDib );
         GlobalFree( hDib );
      }
      _lclose( hFile );
   }
   _retni( hBitmap );
}

//----------------------------------------------------------------------------//
