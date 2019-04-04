implib PmWin.lib    PmWin.def
implib DosCall1.lib DosCall1.def
implib PmGpi.lib    PmGpi.def
implib Mirrors.lib  Mirrors.def
implib pmctls.lib   pmctls.def

del OS2Api.lib
lib OS2Api -+ PmWin.lib,,
lib OS2Api -+ DosCalls.lib,,
lib OS2Api -+ DosCall1.lib,,
lib OS2Api -+ PmGpi.lib,,
lib OS2Api -+ Mirrors.lib,,
lib OS2Api -+ pmctls.lib,,
