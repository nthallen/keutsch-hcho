%{
  #include <stdint.h>
  #include <math.h>
  #include "SB.h"
%}
&command
  : Laser Set &laserv %f (Enter value in mVolts) * {
      uint16_t usp;
      double sp = floor($4*65536/5000);
      if (sp < 0) sp = 0;
      else if (sp > 65535) sp = 65535;
      usp = floor(sp);

      if (SB.BCtr)
        SB.BCtr->sbwr($3, usp);
    }
  : Laser Command &lasercmd * {
        if (SB.BCtr)
          SB.BCtr->sbwr(0x80, $3);
      }
  ;

&laserv <uint16_t>
  : Setpoint { $0 = 0x81; }
  : Scan Start { $0 = 0x82; }
  : Scan Stop { $0 = 0x83; }
  : Scan Step { $0 = 0x84; }
  : Online { $0 = 0x85; }
  : Offline { $0 = 0x86; }
  : Dither { $0 = 0x87; }
  ;

&lasercmd <uint16_t>
  : Scan Start { $0 = 1; }
  : Scan Abort { $0 = 0; }
  : Drive Online { $0 = 2; }
  : Drive Dither Above Online { $0 = 3; }
  : Drive Dither Below Online { $0 = 4; }
  : Drive Offline { $0 = 5; }
  ;

