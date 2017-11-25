/* SWData.h */
#ifndef SWDATA_H_INCLUDED
#define SWDATA_H_INCLUDED

typedef struct __attribute__((__packed__)) {
  unsigned char SWStat;
  unsigned char Flag;
  unsigned short NPts_Online;
  unsigned short NPts_Offline;
  signed short Offline_Delta;
  unsigned short Drift_Limit;
} SWData_t;
extern SWData_t SWData;

#define SWS_PPS_IDLE 1
#define SWS_PPS_SYNC 2
#define SWS_PCTRL_IDLE 3
#define SWS_PCTRL_ACTIVE 4
#define SWS_SHUTDOWN 255

#endif
