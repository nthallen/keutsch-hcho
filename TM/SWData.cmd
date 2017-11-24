%{
  #include "SWData.h"
  #ifdef SERVER
    SWData_t SWData;
  #endif
%}

%INTERFACE <SWData:DG/data>

&command
  : &SWTM * { if_SWData.Turf(); }
  ;
&SWTM
  : SWStat &SWStat { SWData.SWStat = $2; }
  ;
&SWStat <unsigned char>
  : PPS Idle { $0 = SWS_PPS_IDLE; }
  : Set %d { $0 = $2; }
  : PPS Sync { $0 = SWS_PPS_SYNC; }
  : Shutdown { $0 = SWS_SHUTDOWN; }
  ;
