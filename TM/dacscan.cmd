%{
  #include <stdint.h>
  #include <math.h>
  #include "SB.h"
%}
&command
  : Laser Voltage Set &laserv %f (Enter Volts) * {
      uint16_t usp;
      double sp = floor($5*65536/5);
      if (sp < 0) sp = 0;
      else if (sp > 65535) sp = 65535;
      usp = floor(sp);

      if (SB.BCtr)
        SB.BCtr->sbwr($4, usp);
    }
  : Laser mVolts Set Step %f (Enter mVolts) * {
      uint16_t usp;
      double sp = floor($5*65536*8/5000);
      if (sp < 0) sp = 0;
      else if (sp > 65535) sp = 65535;
      usp = floor(sp);

      if (SB.BCtr)
        SB.BCtr->sbwr(0x84, usp);
    }
  : Laser &lasercmd * {
        if (SB.BCtr)
          SB.BCtr->sbwr(0x80, $2);
      }
  ;

&laserv <uint16_t>
  : Setpoint { $0 = 0x81; }
  : Scan Start { $0 = 0x82; }
  : Scan Stop { $0 = 0x83; }
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

