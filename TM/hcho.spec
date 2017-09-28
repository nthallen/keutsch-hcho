Module TMbase

SCRIPT = interact
TGTDIR = $(TGTNODE)/home/hcho

hchocol : -lsubbus
hchosrvr : -lsubbus
hchodisp : HCHO.tbl
doit : hcho.doit
