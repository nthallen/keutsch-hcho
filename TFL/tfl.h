#ifndef TFL_H_INCLUDED
#define TFL_H_INCLUDED
#include <stdint.h>

typedef struct __attribute__((__packed__)) {
  uint16_t SD_I; //*< Seed Diode Current, mA
  uint16_t SD_T; //*< Seed Diode Temp, 0.1 C
  uint16_t P1D_I; //*< 1st Pump Diode Current, 0.01 A
  uint16_t P1D_T; //*< 1st Pump Diode Temperature, 0.1 C
  uint16_t SDM_P; //*< Seed Diode Monitor Power, 0.01 V
  uint16_t P2D_I; //*< 2nd Pump Diode Current, mA
  uint16_t P2D_T; //*< 1st Pump Diode Temperature, 0.1 C
  uint16_t P2DMin_P; //*< Monitor Power Input into 2nd
  uint16_t P2DMout_P; //*< Monitor Power Diode 2nd Pump Output
  uint16_t SHG_T; //*< SHG Temperature, 0.01 C
  uint16_t THG_T; //*< THG Temperature, 0.01 C
  uint16_t SD_T_SP; //*< Seed Diode Temp Setpoint, 0.1C
  uint16_t SD_I_SP; //*< Seed Diode Current Setpoint, mA
  uint16_t P1D_I_SP; //*< Pump Diode Current Setpoint 0.01 A
  uint16_t SHG_T_SP; //*< SHG Temperature Setpoint, 0.01 C
  uint16_t THG_T_SP; //*< SHG Temperature Setpoint, 0.01 C
  uint16_t Status;
} tfl_tm_t;

#define TFL_TM_Fresh 1
#define TFL_LCMD_Responded 2
#define TFL_Laser_On 4

#endif

