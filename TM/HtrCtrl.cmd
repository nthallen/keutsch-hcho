%{
  #include "SB.h"
%}

&command
  : Set &HtrChan Voltage %f * {
      double bits = $4 * 65536. / 5.0;
      uint16_t ibits;

      if (bits < 0) bits = 0;
      if (bits > 65535.) bits = 65535;
      ibits = (uint16_t) bits;
      if (SB.BCtr) SB.BCtr->write_ack($2, ibits);
    }
  ;

&HtrChan <uint16_t>
  : Heater 1 { $0 = 0x51; }
# : Heater 2 { $0 = 0x53; }
  ;
