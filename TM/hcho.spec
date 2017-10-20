tmcbase = base.tmc

genuibase = hcho.genui

# Heater Controller block is hard coded to 10 Hz.
# HtrCtrl.tmc and HtrCtrl.genui could easily be modularized
tmcbase = HtrCtrl.tmc
colbase = HtrCtrl_col.tmc
genuibase = HtrCtrl.genui
cmdbase = HtrCtrl.cmd

tmcbase = TS.tmc
colbase = TS_col.tmc
extbase = TS_conv.tmc
genuibase = TS.genui

Module TMbase
Module BCtr rate=10 NC=29700L

SCRIPT = interact
TGTDIR = $(TGTNODE)/home/hcho
IGNORE = Makefile

hchocol : -lsubbus
hchosrvr : -lsubbus
hchodisp : BCtr_conv.tmc HtrCtrl_conv.tmc TS_conv.tmc HCHO.tbl
doit : hcho.doit
# BCtrext : BCtrext.tmc
