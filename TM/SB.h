#ifndef SB_H_INCLUDED
#define SB_H_INCLUDED

#ifdef __cplusplus

#include "subbuspp.h"

class SB_t {
  public:
    SB_t();
    ~SB_t();
    void init();
    subbuspp *BCtr; // 8
    subbuspp *FCC;  // 10
    subbuspp *FCC2; // 11
  private:
    bool initialized;
    subbuspp *SB1;
    subbuspp *SB2;
    subbuspp *SB3;
    subbuspp *load_lib(const char *name);
    void check_spot(subbuspp *lib, const char *devname,
        subbuspp *&spot, const char *spotname);
};

extern SB_t SB;

extern "C" {

#endif

void SB_init(); // for oui
void tick_sic();
void disarm_sic();

#ifdef __cplusplus
};
#endif

#endif
