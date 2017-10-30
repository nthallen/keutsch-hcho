%{
  #include <stdint.h>
%}
&command
  : PPS Rate Adjust %d * {
      sbwr(0x61, (short)$4);
    }
  : PPS Offset Adjust %ld * {
      uint32_t offset = $4;
      if ($4 < 0) {
        nl_error(2, "PPS Offset must be positive");
      } else {
        sbwr(0x64, (short)(offset & 0xFFFF));
        sbwr(0x65, (short)((offset>>8) & 0xFFFF));
      }
    }
  ;
