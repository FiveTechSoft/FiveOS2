@echo off
cls
ECHO 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
ECHO � FiveOS2 0.9 - January 95        CA-Clipper, xBase & OOPS development power 넵
ECHO � (c) FiveTech, 1993-4             for Microsoft Windows, IBM-OS2 and MsDos  넴
ECHO 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
ECHO � 賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
clipper %1 %2 /n/w/l/i..\include;c:\clipper5\include
SET LIB=..\LIB;c:\clipper5\lib
blinker fi %1 @..\include\FiveOS2.lnk
rem link /se:700 /NOE /CO %1,,nul,FiveOS2 OS2Api Clipper, ..\include\FiveOS2.def
rem link /se:700 /NOE %1,,nul,FiveOS2 OS2Api Clipper, ..\include\FiveOS2.def
