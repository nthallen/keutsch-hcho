#include "SB.h"
#include "nortlib.h"

SB_t SB;

SB_t::SB_t() {
  BCtr = 0;
  FCC = 0;
  FCC2 = 0;
  
  load_lib("SB1");
  load_lib("SB1");
  load_lib("SB1");
}

SB_t::~SB_t() {}

void SB_t::check_spot(subbuspp *lib, const char *devname,
    subbuspp *&spot, const char *spotname) {
  if (spot) {
    nl_error(2, "Duplicate %s found on %s", spotname, devname);
    delete lib;
  } else {
    spot = lib;
    nl_error(0, "%s lib found at %s", spotname, devname);
  }
}

void SB_t::load_lib(const char *devname) {
  subbuspp *lib;
  
  lib = new subbuspp(devname);
  if (lib->load()) {
    uint16_t BdID = lib->sbrd(3);
    switch (BdID) {
      case 8:
        check_spot(lib, devname, BCtr, "BCtr");
        break;
      case 10:
        check_spot(lib, devname, FCC, "FCC");
        break;
      case 11:
        check_spot(lib, devname, FCC2, "FCC2");
        break;
      default:
        nl_error(3, "Unknown device code %d on device %s", BdID, devname);
        delete lib;
    }
  } else {
    nl_error(2, "Device %s not found", devname);
    delete lib;
  }
}

int tick_sic() {}
int disarm_sic() {}

