/* SWData.h */
#ifndef SWDATA_H_INCLUDED
#define SWDATA_H_INCLUDED

typedef struct __attribute__((__packed__)) {
  unsigned char SWStat;
  unsigned char Flag;
  unsigned short Drift_Limit;
} SWData_t;
extern SWData_t SWData;

#define SWS_PPS_IDLE 1
#define SWS_PPS_SYNC 2
#define SWS_PCTRL_IDLE 3
#define SWS_PCTRL_ACTIVE 4
#define SWS_CHOP_START 5
#define SWS_CHOP_STOP 6
#define SWS_CHOP_ABORT 7
#define SWS_CHOP_SCAN 8
#define SWS_PEAK_ENABLE 9
#define SWS_PEAK_DISABLE 10
#define SWS_DITHER_ENABLE 11
#define SWS_DITHER_DISABLE 12
#define SWS_TIMEWARP 254
#define SWS_SHUTDOWN 255

#endif
