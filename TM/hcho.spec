tmcbase = base.tmc
tmcbase = BCtr.tmc

colbase = BCtr_col.tmc

Module TMbase

SCRIPT = interact
TGTDIR = $(TGTNODE)/home/hcho
IGNORE = Makefile

hchocol : -lsubbus
hchosrvr : -lsubbus
hchodisp : HCHO.tbl
doit : hcho.doit
