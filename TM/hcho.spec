tmcbase = base.tmc

genuibase = hcho.genui

Module TMbase
Module BCtr rate=10 NC=29700L

SCRIPT = interact
TGTDIR = $(TGTNODE)/home/hcho
IGNORE = Makefile

hchocol : -lsubbus
hchosrvr : -lsubbus
hchodisp : BCtr_conv.tmc HCHO.tbl
doit : hcho.doit
# BCtrext : BCtrext.tmc
