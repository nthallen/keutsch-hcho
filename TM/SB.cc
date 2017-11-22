#include "SB.h"
#include "nortlib.h"

SB_t SB;

SB_t::SB_t() {
  BCtr = 0;
  FCC = 0;
  FCC2 = 0;
  SB1 = 0;
  SB2 = 0;
  SB3 = 0;
  initialized = false;
}

void SB_t::init() {
  if (!initialized) {
    SB1 = load_lib("SB1");
    SB2 = load_lib("SB2");
    SB3 = load_lib("SB3");
    initialized = true;
  }
}

SB_t::~SB_t() {
  if (SB1) SB1->subbus_quit();
  if (SB2) SB2->subbus_quit();
  if (SB3) SB3->subbus_quit();
}

void SB_t::check_spot(subbuspp *lib, const char *devname,
    subbuspp *&spot, const char *spotname) {
  if (spot) {
    nl_error(2, "Duplicate %s found on %s", spotname, devname);
  } else {
    spot = lib;
    nl_error(0, "%s lib found at %s", spotname, devname);
  }
}

subbuspp *SB_t::load_lib(const char *devname) {
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
        break;
    }
    return lib;
  } else {
    nl_error(2, "Device %s not found", devname);
    delete lib;
    return 0;
  }
}

void SB_init() {
  SB.init();
}

int tick_sic() {}
int disarm_sic() {}

