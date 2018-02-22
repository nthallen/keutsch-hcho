#include <stdarg.h>
#include <errno.h>
#include <string.h>
#include <math.h>
#include "tfl_int.h"
#include "oui.h"
#include "nortlib.h"
#include "nl_assert.h"

const char *tfl_path = "/dev/ser1";
const char *tfl_name = "TFL";
int tfl_channels = 4;
int opt_echo = 1;

int main(int argc, char **argv) {
  oui_init_options(argc, argv);
  nl_error( 0, "Starting V1.0" );
  { Selector S;
    TFLCmd TFLC;
    tfl_tm_t TMdata;
    TFLSer TFL(tfl_path, &TMdata, &TFLC);
    TM_Selectee TM(tfl_name, &TMdata, sizeof(TMdata));
    S.add_child(&TFLC);
    S.add_child(&TFL);
    S.add_child(&TM);
    S.event_loop();
  }
  nl_error( 0, "Terminating" );
}

TFLQuery::TFLQuery() {
  type = QT_LN;
  min_response_len = 0;
}

/**
 * @return non-zero on error
 */
int TFLQuery::format(TFL_Query_Type QT, const char *cmd,
        uint16_t value, int valuelen, uint16_t min_resp) {
  type = QT;
  query.clear();
  query.append(cmd);
  if (valuelen) {
    char vbuf[5];
    int nvc = snprintf(vbuf, 5, "%0*u", valuelen, value);
    if (nvc != valuelen) return 1;
    query.append(vbuf, valuelen);
  }
  query.append("\n",1);
  min_response_len = min_resp;
  if (opt_echo)
    min_response_len += query.length();
  return 0;
}

/**
 * Will inherit from Ser_Sel although not a serial interface per se. I
 * just want access to all the parsing and error reporting functions.
 * I won't call setup(), which is the only device-specific function.
 */
TFLCmd::TFLCmd() : Ser_Sel() {
  char shortname[40];
  int nc;
  nc = snprintf(shortname, 40, "cmd/%s", tfl_name);
  if (nc >= 40) {
    nl_error(3, "Specified name '%s' is too long", tfl_name);
  }
  init( tm_dev_name(shortname), O_RDONLY|O_NONBLOCK, 50 );
}

TFLCmd::~TFLCmd() {
}

/**
 * Process commands from command server:
cmd/TFL Formats:
  W\d:\d+ Specifies address and data
  Q       Requests driver to terminate
  
Serial Port Formats:
  Address 0: WS1T\d{3}\n Set Seed diod 1 Temperature xx.x C
  Address 1: WS1L\d{3}\n Set Sed Diode 1 Current xxx mA
  Address 2: WP2L\d{3}\n Set Pump Diod Current x.xx A
  Address 3: WSHG\d{4}\n Set SHG Temperature xx.xx C
  Address 4: WTHG\d{4}\n Set THG Temperature xx.xx C
  Address 5:0 LF\n Laser Off
  Address 5:1 LN\n Laser On

 > TFL Set Seed Diode 1 Temperature xx.x C: WS1Txxx W0
 > TFL Set Seed Diode 1 Current xxx mA: WS1Lxxx W1
 > TFL Set Pump Diode Current x.xx A: WP2Lxxx W2
 > TFL Set SHG Temperature xx.xx C: WSHGxxxx W3
 > TFL Set THG Temperature xx.xx C WTHGxxxx W4
 > TFL Laser On: LN W5:1
 > TFL Laser Off: LF W5:0

 */
int TFLCmd::ProcessData(int flag) {
  nc = cp = 0;
  int address, value, nwdigits, min_resp;
  const char *cmd;
  TFL_Query_Type QT;
  if (fillbuf()) return 1;
  if (nc == 0 || buf[0] == 'Q') return 1;
  if (not_str("W",1) ||
      not_int(address) ||
      not_str(":",1) ||
      not_int(value) ||
      not_str("\n",1)) {
    report_err("Unrecognized command");
    consume(nc);
    return 0;
  }
  QT = QT_W;
  min_resp = 11; // default for QT_W
  switch (address) {
    case 0: cmd = "WS1T"; nwdigits = 3; break;
    case 1: cmd = "WS1L"; nwdigits = 3; break;
    case 2: cmd = "WP2L"; nwdigits = 3; break;
    case 3: cmd = "WSHG"; nwdigits = 4; break;
    case 4: cmd = "WTHG"; nwdigits = 4; break;
    case 5:
      cmd = value ? "LN" : "LF";
      QT = value ? QT_LN : QT_LF;
      nwdigits = 0;
      min_resp = 3;
      break;
    default:
      report_err("Invalid command");
      consume(nc);
      return 0;
  }
  if (CmdQuery.format(QT, cmd, value, nwdigits, min_resp)) {
    report_err("nwdigits fail: %d %d", nwdigits, value);
    consume(nc);
    return 0;
  }

  flags = 0; // Don't listen for more commands
  Stor->set_gflag(1);
  report_ok();
  consume(cp);
  return 0;
}

TFLQuery *TFLCmd::query() {
  if ( flags ) {
    nl_error( 2, "TFLCmd::query() called when flags != 0" );
    return NULL;
  }
  return &CmdQuery;
}

void TFLCmd::query_complete() {
  flags = Selector::Sel_Read; // listen again
}

/* Buf Size arbitrarily set to 50 for now */
TFLSer::TFLSer(const char *ser_dev, tfl_tm_t *data, TFLCmd *TFL_Cmd)
  : Ser_Sel( ser_dev, O_RDWR|O_NONBLOCK, 200 ) {
  Cmd = TFL_Cmd;
  setup(38400, 8, 'n', 1, 45, 1 ); // Let's go with the timeout
  flags |= Selector::gflag(0) | Selector::gflag(1) | Selector::Sel_Timeout;
  TMdata = data;
  // Initialize TMdata to zeros?
  TMdata->Status = 0;
  // Initialize queries 
  Qlist.resize(1);
  Qlist[0].format(QT_SA, "SA", 0, 0, 162);
  CurQuery = 0;
  nq = qn = 0;
  cmdq = 0;
  state = TFLS_Idle;
  do {
    nc = cp = 0;
  } while (fillbuf() == 0 && nc > 0);
  cur_min = 1;
  init_termios();
}

TFLSer::~TFLSer() {
}

int TFLSer::ProcessData(int flag) {
  int nbw;
  if (flag & Selector::gflag(0)) { // TM
    TMdata->Status &= ~(TFL_TM_Fresh | TFL_LCMD_Responded);
    nq = Qlist.size();
  }
  if (flag & Selector::gflag(1)) { // Command Received
    cmdq = 1;
  }
  if (flag & (Selector::Sel_Read | Selector::Sel_Timeout)) {
    switch (parse_response()) {
      case TFLP_Die: return 1;
      case TFLP_Wait:
        if (TO.Expired()) {
          report_err("Timeout: Query was: '%s'",
            ascii_escape(CurQuery->query));
          break;
        } else {
          update_termios();
          return 0;
        }
      case TFLP_OK:
        break;
      default:
        nl_error(4, "Invalid return code from parse_response()");
    }
    if (CurQuery) {
      if (CurQuery->type == QT_SA) {
        // These are the internal polling commands
        if (++qn == Qlist.size())
          qn = 0;
        --nq;
      } else {
        // All the rest come from the command interface
        Cmd->query_complete();
      }
      CurQuery = 0;
    }
  }
  if (CurQuery) {
    update_termios();
    return 0;
  }
  if (cmdq) {
    CurQuery = Cmd->query();
    cmdq = 0;
  }
  if ((CurQuery == 0) && nq) {
    CurQuery = &Qlist[qn];
  }
  if (CurQuery == 0) {
    state = TFLS_Idle;
    TO.Clear();
    cur_min = 1;
    update_termios();
    return 0;
  }
  nbw = write(fd, CurQuery->query.c_str(), CurQuery->query.length());
  nc = cp = 0; // flush input buffer
  if (nbw == -1) {
    nl_error(2, "Error on write to device: %s", strerror(errno));
    return 1; // terminate
  } else if ((unsigned)nbw != CurQuery->query.length()) {
    report_err("Incomplete write: expected %d, wrote %d",
      CurQuery->query.length(), nbw);
  }
  if (CurQuery->type == QT_SA) {
    TO.Set(0, 70); // This probably needs to be longer
  } else {
    // nl_error(-2, "Set command timeout");
    TO.Set(1, 0);
  }
  state = TFLS_WaitResp;
  cur_min = CurQuery->min_response_len;
  update_termios();
  return 0;
}

/**
 * @return TFLP_OK means we are done with this query, good or bad.
 *   TFLP_Wait means we have not received what we're looking for.
 *   TFLP_Die means a serious error occurred and the driver should terminate.
 */
TFLSer::TFL_Parse_Resp TFLSer::parse_response() {
  cp = 0;
  if (fillbuf()) return TFLP_Die; // Die on read error
  if (CurQuery == 0) {
    report_err("Unexpected input");
    consume(nc);
    return TFLP_OK;
  }
  cur_min = CurQuery->min_response_len - cp;
  if (opt_echo &&
      not_str(CurQuery->query.c_str(), CurQuery->query.length())) {
    if (cp >= nc) {
      return TFLP_Wait;
    } else {
      report_err("Echo garbled");
      consume(nc);
      return TFLP_OK;
    }
  }
  switch (CurQuery->type) {
    case QT_LN:
      if (not_str("on\n",3)) {
        if (cp >= nc) return TFLP_Wait;
        report_err("Unrecognized response to LN");
        consume(nc);
        return TFLP_OK;
      } else {
        TMdata->Status |= TFL_Laser_On | TFL_LCMD_Responded;
      }
      break;
    case QT_LF:
      if (not_str("off\n",4)) {
        if (cp >= nc) return TFLP_Wait;
        report_err("Unrecognized response to LF");
        consume(nc);
        return TFLP_OK;
      } else {
        TMdata->Status &= ~TFL_Laser_On;
        TMdata->Status |= TFL_LCMD_Responded;
      }
      break;
    case QT_W:
      if (not_str("  Sending \n")) {
        if (cp >= nc) return TFLP_Wait;
        report_err("Urecognized response");
        consume(nc);
        return TFLP_OK;
      }
      break;
    case QT_SA:
      { unsigned int CH0, CH1, CH2, CH3, CH4, CH8;
        unsigned int CH9, CH12, CH13, CH14, CH15;
        if (not_str("CH0",3) || not_unsigned(CH0) ||
            not_str(" mA\nCH1") || not_ufixed(CH1,1) ||
            not_str(" C\nCH2") || not_ufixed(CH2,2) ||
            not_str(" A\nCH3") || not_ufixed(CH3,1) ||
            not_str(" C\nCH4") || not_ufixed(CH4,2) ||
            not_str(" V\nCH8") || not_unsigned(CH8) ||
            not_str(" mA\nCH9") || not_ufixed(CH9,1) ||
            not_str(" C\nCH10 0.00 A\nCH11 >50  C\nCH12") ||
                                   not_ufixed(CH12,2) ||
            not_str(" V\nCH13") || not_ufixed(CH13,2) ||
            not_str(" V\nCH14") || not_ufixed(CH14,2) ||
            not_str(" C\nCH15") || not_ufixed(CH15,2) ||
            not_str(" C\n\n")
            ) {
          if (cp < nc) {
            consume(nc);
            return TFLP_OK;
          } else return TFLP_Wait;
        }
        TMdata->SD_I = CH0;
        TMdata->SD_T = CH1;
        TMdata->P1D_I = CH2;
        TMdata->P1D_T = CH3;
        TMdata->SDM_P = CH4;
        TMdata->P2D_I = CH8;
        TMdata->P2D_T = CH9;
        TMdata->P2DMin_P = CH12;
        TMdata->P2DMout_P = CH12;
        TMdata->SHG_T = CH14;
        TMdata->THG_T = CH15;
        TMdata->Status |= TFL_TM_Fresh;
      }
      break;
    default:
      nl_error(4, "Invalid query type code in parse_response: %d",
        CurQuery->type);
  }
  cur_min = 1;
  consume(nc);
  report_ok();
  return TFLP_OK;
}

// Looking for int "." int and converting to a fixed float stored as 1 int
int TFLSer::not_ufixed(unsigned int &val, int ndecimals) {
  val = 0;
  int nd = 0;
  while (cp < nc && isspace(buf[cp]))
    ++cp;
  if (cp < nc) {
    if (!isdigit(buf[cp]) && buf[cp] != '.') {
      report_err("Expected digit or decimal at column %d", cp);
      return 1;
    }
  } else return 1;
  while (cp < nc && isdigit(buf[cp])) {
    val = val*10 + buf[cp++] - '0';
  }
  if (cp >= nc) {
    return 1;
  } else if (buf[cp] != '.') {
    report_err("Expected decimal in not_ufixed at column %d", cp);
    return 1;
  }
  ++cp;
  while (cp < nc && nd < ndecimals && isdigit(buf[cp])) {
    val = val*10 + buf[cp++] - '0';
    ++nd;
  }
  if (nd < ndecimals) {
    if (cp < nc)
      report_err("Expected %d decimals, saw %d", ndecimals, nd);
    return 1;
  }
  return 0;
}

// Looking for at least one digit
int TFLSer::not_unsigned(unsigned int &val) {
  val = 0;
  while (cp < nc && isspace(buf[cp]))
    ++cp;
  if (cp < nc) {
    if (!isdigit(buf[cp])) {
      report_err("Expected digit column %d", cp);
      return 1;
    }
  } else return 1;
  while (cp < nc && isdigit(buf[cp])) {
    val = val*10 + buf[cp++] - '0';
  }
  return 0;
}

Timeout *TFLSer::GetTimeout() {
  return state == TFLS_Idle ? 0 : &TO;
}

void TFLSer::init_termios() {
  if (tcgetattr(fd, &termios_s)) {
    nl_error(2, "Error from tcgetattr: %s", strerror(errno));
  }
}

/**
 * Adapted from TwisTorr. Adjusts the VMIN termios value
 * based on the specific command. This version is incomplete.
 * It adjusts for the request size so we can skip over the RS485 echo,
 * but it does not anticipate any more than the minimal response
 * of 6 characters. We could add command-specific response size
 * as noted in the comments. We could also adjust the VTIME
 * parameter, but it may be redundant, since we have the overriding
 * Selector timeout working for us.
 */
void TFLSer::update_termios() {
  if (cur_min < 1) cur_min = 1;
  if (cur_min != termios_s.c_cc[VMIN]) {
    termios_s.c_cc[VMIN] = cur_min;
    if (tcsetattr(fd, TCSANOW, &termios_s)) {
      nl_error(2, "Error from tcsetattr: %s", strerror(errno));
    }
  }
}
