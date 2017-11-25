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
  : Flag &Flag { SWData.Flag = $2; }
  : Laser NPoints Online &NPts_Online { SWData.NPts_Online = $4; }
  : Laser NPoints Offline &NPts_Offline { SWData.NPts_Offline = $4; }
  : Laser Offline Delta &Offline_Delta { SWData.Offline_Delta = $4; }
  : Laser Drift Limit &Drift_Limit { SWData.Drift_Limit = $4; }
  ;
&SWStat <unsigned char>
  : PPS Idle { $0 = SWS_PPS_IDLE; }
  : Set %d { $0 = $2; }
  : PPS Sync { $0 = SWS_PPS_SYNC; }
  : Pressure Control Idle { $0 = SWS_PCTRL_IDLE; }
  : Pressure Control Activate { $0 = SWS_PCTRL_ACTIVE; }
  : Shutdown { $0 = SWS_SHUTDOWN; }
  ;
&Flag <unsigned char>
  : Set %d { $0 = $2; }
  ;
&NPts_Online <unsigned short>
  : Set %d (Enter number of 100 ms samples) { $0 = $2; }
  ;
&NPts_Offline <unsigned short>
  : Set %d (Enter number of 100 ms samples) { $0 = $2; }
  ;
&Offline_Delta <signed short>
  : Set %d (Enter mVolts) { $0 = $2; }
  ;
&Drift_Limit <unsigned short>
  : Set %d (Enter mV of laser voltage) { $0 = $2; }
  ;
