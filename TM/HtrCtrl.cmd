%{
  #include "subbus.h"
%}

&command
  : Set &HtrChan Voltage %f * {
      double bits = $4 * 65536. / 5.0;
      unsigned short ibits;

      if (bits < 0) bits = 0;
      if (bits > 65535.) bits = 65535;
      ibits = (unsigned short) bits;
      sbwr($2, ibits);
    }
  ;

&HtrChan <unsigned short>
  : Heater 1 { $0 = 0x51; }
  : Heater 2 { $0 = 0x53; }
  ;
