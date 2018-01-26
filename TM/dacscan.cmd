%{
  #include <stdint.h>
  #include <math.h>
  #include "SB.h"
%}
&command
  : Laser Set &laserv %f (Enter value in mVolts) * {
      uint16_t usp;
      double sp = floor($4*65536/5000);
      if ($3 == 0x84) sp = sp*8; // The Step has *8 resolution
      if ($3 == 0x86) { // offline delta is signed
        int16_t ssp;
        if (sp < -32768.) ssp = -32768;
        else if (sp > 32767) ssp = 32767;
        else ssp = floor(sp);
        usp = (uint16_t)ssp;
      } else {
        if (sp < 0) sp = 0;
        else if (sp > 65535) sp = 65535;
        usp = floor(sp);
      }

      if (SB.BCtr)
        SB.BCtr->sbwr($3, usp);
    }
  : Laser Chop NPts &NPtsOnOff %d * {
      if (SB.BCtr)
        SB.BCtr->sbwr($4, $5);
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
  : Online Position { $0 = 0x85; }
  : Offline Delta { $0 = 0x86; }
  : Online Dither { $0 = 0x87; }
  ;

&NPtsOnOff <uint16_t>
  : Online { $0 = 0x88; }
  : Offline { $0 = 0x89; }
  ;

&lasercmd <uint16_t>
  : Scan Start { $0 = 1; }
  : Scan Abort { $0 = 0; }
  : Drive Online { $0 = 2; }
  : Dither Online Up { $0 = 3; }
  : Dither Online Down { $0 = 4; }
  : Drive Offline { $0 = 5; }
  : Chop Mode Begin { $0 = 6; }
  : Chop Mode End { $0 = 7; }
  ;

