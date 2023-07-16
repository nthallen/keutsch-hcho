%{
  #include "SB.h"
%}

&command
  : BCtr &BCtr &BCtrCmd * { if (SB.BCtr) SB.BCtr->write_ack($2, $3); }
  ;

&BCtr <uint16_t>
# : 1 { $0 = 0x10; }
  : 2 { $0 = 0x20; }
  ;

&BCtrCmd <uint16_t>
  : Enable { $0 = 1; }
  : Disable { $0 = 0; }
  ;
