@echo off
cls
ECHO ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
ECHO ³ FiveOS2 0.9 - January 95        CA-Clipper, xBase & OOPS development power ³Ü
ECHO ³ (c) FiveTech, 1993-4             for Microsoft Windows, IBM-OS2 and MsDos  ³Û
ECHO ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
ECHO ÿ ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
clipper %1 %2 /n/w/l/i..\include;c:\clipper5\include
SET LIB=..\LIB;c:\clipper5\lib
blinker fi %1 @..\include\FiveOS2.lnk
rem link /se:700 /NOE /CO %1,,nul,FiveOS2 OS2Api Clipper, ..\include\FiveOS2.def
rem link /se:700 /NOE %1,,nul,FiveOS2 OS2Api Clipper, ..\include\FiveOS2.def
