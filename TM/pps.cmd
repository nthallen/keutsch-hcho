%{
  #include <stdint.h>
  #include "SB.h"
%}
&command
  : PPS Rate Adjust %d * {
      if (SB.BCtr)
        SB.BCtr->sbwr(0x61, (short)$4);
    }
  : PPS Offset Adjust %ld * {
      uint32_t offset = $4;
      if ($4 < 0) {
        nl_error(2, "PPS Offset must be positive");
      } else if (SB.BCtr) {
        SB.BCtr->sbwr(0x64, (short)(offset & 0xFFFF));
        SB.BCtr->sbwr(0x65, (short)((offset>>8) & 0xFFFF));
      }
    }
  ;
