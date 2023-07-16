%{
  #include <stdint.h>
  #include "SB.h"
%}
&command
  : PPS Rate Adjust %d * {
      if (SB.BCtr)
        SB.BCtr->write_ack(0x61, (uint16_t)$4);
    }
  : PPS Offset Adjust %ld * {
      uint32_t offset = $4;
      if ($4 < 0) {
        msg(2, "PPS Offset must be positive");
      } else if (SB.BCtr) {
        SB.BCtr->write_ack(0x64, (uint16_t)(offset & 0xFFFF));
        SB.BCtr->write_ack(0x65, (uint16_t)((offset>>8) & 0xFFFF));
      }
    }
  ;
