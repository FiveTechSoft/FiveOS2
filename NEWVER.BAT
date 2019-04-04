cd samples
call clean.bat
cd..

pkzip -P fos0E readme.txt whatsnew.txt order.txt bitmaps\*.* DLL\*.* -xBWCC.dll -x*.~bm
del ide\obj\*.obj
pkzip -P -r fos0E ide\*.* -xide\*.ntx icons\*.* include\*.* -xinclude\api\*.* -x*.map -x*.~dl
pkzip -P fos0E cursors\*.cur
pkzip -P fos0E lib\FiveOs2.lib lib\Os2Api.lib lib\Clp.exe
pkzip -P fos0E manual\*.ng manual\*.hlp
pkzip -P fos0E source\classes\*.* source\function\*.* source\tools\*.* source\winapi\*.*
pkzip -P fos0E -x*.exe samples\*.* -x*.map -x*.ntx
pkzip -P fos0E *.diz
pkzip -z<version fos0E

zip2exe FOs0E.zip
del FOs0E.zip
del FOs0E.ins
ren FOs0E.exe FOs0E.ins
