tmcbase = base.tmc
tmcbase = BCtr.tmc

colbase = BCtr_col.tmc

cmdbase = BCtr.cmd

genuibase = hcho.genui

Module TMbase

SCRIPT = interact
TGTDIR = $(TGTNODE)/home/hcho
IGNORE = Makefile

hchocol : -lsubbus
hchosrvr : -lsubbus
hchodisp : BCtr_conv.tmc HCHO.tbl
doit : hcho.doit
BCtrext : BCtrext.tmc
