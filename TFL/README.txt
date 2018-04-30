TFL README

This directory contains a driver for the
Thermo Scientific Model TFL 3000 Tunable Fiber Laser

Interfaces:
  DG/data/TFL: Data structure defined in tfl.h
  cmd/TFL: Format Described below
  Serial port

cmd/TFL Formats:
  W\d:\d+ Specifies address and data
  Q       Requests driver to terminate
  
Serial Port Formats:
  Address 0: WS1T\d{3}\n Set Seed diod 1 Temperature xx.x C
  Address 1: WS1L\d{3}\n Set Sed Diode 1 Current xxx mA
  Address 2: WP2L\d{3}\n Set Pump Diod Current x.xx A
  Address 3: WSHG\d{4}\n Set SHG Temperature xx.xx C
  Address 4: WTHG\d{4}\n Set THG Temperature xx.xx C
  Address 5:0 LF\n Laser Off
  Address 5:1 LN\n Laser On
