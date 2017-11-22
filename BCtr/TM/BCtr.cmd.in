%{
  #include "SB.h"
%}

&command
  : BCtr &BCtr &BCtrCmd * { if (SB.BCtr) SB.BCtr->sbwr($2, $3); }
  ;

&BCtr <unsigned short>
# : 1 { $0 = 0x10; }
  : 2 { $0 = 0x20; }
  ;

&BCtrCmd <unsigned short>
  : Enable { $0 = 1; }
  : Disable { $0 = 0; }
  ;
