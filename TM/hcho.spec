tmcbase = base.tmc
cmdbase = /usr/local/share/huarp/phrtg.cmd
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

tmcbase = pps.tmc
cmdbase = pps.cmd

Module TMbase
Module BCtr rate=10 NC=29700L
# This invocation was for slower baud rate, went with 'a' and 'b'
# suffix in VERSION
#Module BCtr rate=10 NC=29700L NA=2,220 NB=50,1 NW=105 from=8 to=48

SCRIPT = interact
TGTDIR = $(TGTNODE)/home/hcho
IGNORE = Makefile

hchocol : -lsubbus
hchosrvr : -lsubbus
hchodisp : BCtr_conv.tmc HtrCtrl_conv.tmc TS_conv.tmc HCHO.tbl
hchortgext : BCtr_conv.tmc rtg.tmc /usr/local/share/oui/cic.oui
TSrawext : TSraw.cdf
doit : hcho.doit
hchoalgo : hcho.tma
