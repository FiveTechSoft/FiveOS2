@echo off
cls
ECHO 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
ECHO � FiveWin 1.8 - January 95        CA-Clipper, xBase & OOPS development power 넵
ECHO � (c) FiveTech, 1993-4             for Microsoft Windows, IBM-OS2 and MsDos  넴
ECHO 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸�
ECHO � 賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�

call build.bat %1

if exist %1.rc goto rc
rc -i ..\include ..\include\fiveos2.rc %1.exe
goto end

:rc
rc -i ..\include %1.rc %1.exe

:end
%1
