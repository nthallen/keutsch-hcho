tmcbase = base.tmc
genuibase = hcho.genui
cmdbase = loop.cmd

tmcbase = SWStat.tmc
genuibase = SWStat.genui
swsbase = hcho.sws

# Heater Controller block is hard coded to 1 Hz.
# HtrCtrl.tmc and HtrCtrl.genui could easily be modularized
tmcbase = HtrCtrl.tmc
colbase = HtrCtrl_col.tmc
genuibase = HtrCtrl.genui
cmdbase = HtrCtrl.cmd

tmcbase = TS.tmc TS_T_t.tmc
colbase = TS_col.tmc
extbase = TS_conv.tmc
genuibase = TS.genui

tmcbase = pps.tmc
colbase = SB.cc SB.oui
cmdbase = pps.cmd

tmcbase = dacscan.tmc
colbase = dacscan_col.tmc
cmdbase = dacscan.cmd
genuibase = dacscan.genui

tmcbase = fcc.tmc
colbase = fcc_col.tmc
cmdbase = fcc.cmd
genuibase = fcc.genui

Module TMbase
Module Email dest=/home/CH2O/bin/Email
Module BCtr rate=10 NA=1,90 from=10 to=43
Module Meerstetter mode=ignore name=HG src=HG.txt
tmcbase = pps_time.tmc

Module anal

# Module TFL mode=absent

SCRIPT = interact
DISTRIB = services USB.id
TGTDIR = $(TGTNODE)/home/CH2O
IGNORE = Makefile "*.exe" "*.stackdump"

hchocol : -lsubbuspp
hchosrvr : SB.cc SB.oui -lsubbuspp
hchodisp : BCtr_conv.tmc HtrCtrl_conv.tmc TS_conv.tmc fcc_conv.tmc \
           HCHO.tbl HCHO_Eng.tbl
hchojsonext : BCtr_conv.tmc HtrCtrl_conv.tmc TS_conv.tmc fcc_conv.tmc \
           $genuibase
# TSrawext : TSraw.cdf
doit : hcho.doit
hchoalgo : BCtr_conv.tmc TS_conv.tmc hcho.tma hcho.sws
normctsext : BCtr_conv.tmc normcts.cdf

%%
CXXFLAGS=-g

