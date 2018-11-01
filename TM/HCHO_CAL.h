/* HCHO_CAL_CONSTANT units are
    counts/sec/mW/ppb of HCHO

  2018-09-05 JDS 71.87
  2018-09-07 NTA 2700 based on back-of-the-envelope
  2018-09-07 NTA/JDS 71.87 reverting to Josh's number after power cal

  The laser power calibration from Volts to mW
  is defined in TS.tmc. Record changes here.

  2018-09-07 NTA 3.91 V == 1 mW
  2018-09-07 NTA/JDS nonlinear cal
*/
#define HCHO_CAL_CONSTANT 18.4
