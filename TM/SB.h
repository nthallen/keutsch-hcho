#ifndef SB_H_INCLUDED
#define SB_H_INCLUDED

#include "subbuspp.h"

class SB_t {
  public:
    SB_t();
    ~SB_t();
    subbuspp *BCtr; // 8
    subbuspp *FCC;  // 10
    subbuspp *FCC2; // 11
  private:
    void load_lib(const char *name);
    void check_spot(subbuspp *lib, const char *devname, subbuspp *&spot, const char *spotname);
};

extern SB_t SB;
int tick_sic();
int disarm_sic();

#endif
