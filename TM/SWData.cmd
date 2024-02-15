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
  : Laser Drift Limit &Drift_Limit { SWData.Drift_Limit = $4; }
  ;
&SWStat <uint8_t>
  : PPS Idle { $0 = SWS_PPS_IDLE; }
  : Set %d { $0 = $2; }
  : PPS Sync { $0 = SWS_PPS_SYNC; }
  : Pressure Control Idle { $0 = SWS_PCTRL_IDLE; }
  : Pressure Control Activate { $0 = SWS_PCTRL_ACTIVE; }
  : Chop Start 1 Minute Scan Interval  { $0 = SWS_CHOP_START_1; }
  : Chop Start 5 Minute Scan Interval  { $0 = SWS_CHOP_START_5; }
  : Chop Start 10 Minute Scan Interval  { $0 = SWS_CHOP_START_10; }
  : Chop Start 30 Minute Scan Interval  { $0 = SWS_CHOP_START_30; }
  : Chop Stop { $0 = SWS_CHOP_STOP; }
  : Peak Detect Enable { $0 = SWS_PEAK_ENABLE; }
  : Peak Detect Disable { $0 = SWS_PEAK_DISABLE; }
  : Chop Dither Enable { $0 = SWS_DITHER_ENABLE; }
  : Chop Dither Disable { $0 = SWS_DITHER_DISABLE; }
  : THG Peakup Enable { $0 = SWS_THG_PEAKUP_ENABLE; }
  : THG Peakup Disable { $0 = SWS_THG_PEAKUP_DISABLE; }
  : Cal Idle { $0 = SWS_CAL_IDLE; }
  : Cal Zero 60min { $0 = SWS_CAL_ZERO_60MIN; }
  : Cal Zero 15min { $0 = SWS_CAL_ZERO_15MIN; }
  : Cal Span SingleConc { $0 = SWS_CAL_SPAN_SINGLE; }
  : Cal Span StepConc { $0 = SWS_CAL_SPAN_STEPPED; }
  : PumpPurge Enable { $0 = SWS_PUMPPURGE_ENABLE; }
  : PumpPurge Disable { $0 = SWS_PUMPPURGE_DISABLE; }
  : PumpPurge Idle { $0 = SWS_PUMPPURGE_IDLE; }
  : Overnight Flow Idle { $0 = SWS_OVERNIGHT_FLOW_IDLE; }
  : Overnight Flow Activate { $0 = SWS_OVERNIGHT_FLOW_ACTIVATE; }
  : Overnight Flow Execute { $0 = SWS_OVERNIGHT_FLOW_EXECUTE; }
  : LC Steps Idle { $0 = SWS_LC_STEPS_IDLE; }
  : LC Steps Activate { $0 = SWS_LC_STEPS_ACTIVATE; }
  : Daily Saverun Enable { $0 = SWS_DAILY_SAVERUN_ENABLE; }
  : Daily Saverun Disable { $0 = SWS_DAILY_SAVERUN_DISABLE; }
  : Daily Saverun Execute { $0 = SWS_DAILY_SAVERUN_EXECUTE; }
  : Full Shutdown { $0 = SWS_FULL_SHUTDOWN; }
  : Time Warp { $0 = SWS_TIMEWARP; }
  : Shutdown { $0 = SWS_SHUTDOWN; }
  ;
&Flag <uint8_t>
  : Set %d { $0 = $2; }
  ;
&Drift_Limit <uint16_t>
  : Set %d (Enter mV of laser voltage) { $0 = $2; }
  ;
