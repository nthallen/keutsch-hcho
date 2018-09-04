#ifndef TFL_INT_H_INCLUDED
#define TFL_INT_H_INCLUDED

#include <termios.h>
#include <stdint.h>
#include "tfl.h"

extern const char *tfl_path;
extern const char *tfl_name;
extern int opt_echo;

#ifdef __cplusplus

#include <string>
#include <vector>
#include "SerSelector.h"

enum TFL_Query_Type { QT_LN, QT_LF, QT_W, QT_SA };

class TFLQuery {
  public:
    TFLQuery();
    int format(TFL_Query_Type QT, const char *cmd,
      uint16_t value, int valuelen, uint16_t min_resp,
      uint16_t *result);
    int write(int fd);
    void abort_write();
    bool write_is_complete();
    std::string query;
    TFL_Query_Type type;
    int request_length;
    int n_transmitted;
    int n_echoed;
    //* min_response_len is the minimum number of characters
    //* expected after the echo
    uint16_t min_response_len;
    //* min_bytes_expected starts with the number of
    //* bytes transmitted, and includes min_response_len
    //* if the entire request has been sent.
    //* parse_response() subtracts the number of chars
    //* received to set cur_min, which update_termios uses
    //* to set VMIN
    uint16_t min_bytes_expected;
    //* If non-zero, result_value points to where cmd_value should
    //* be copied on success.
    uint16_t cmd_value;
    uint16_t *result_value;
};

class TFLCmd : public Ser_Sel {
  public:
    TFLCmd(tfl_tm_t *TM);
    ~TFLCmd();
    int ProcessData(int flag);
    TFLQuery *query();
    void query_complete();
  private:
    TFLQuery CmdQuery;
    tfl_tm_t *TMdata;
};

class TFLSer : public Ser_Sel {
  public:
    TFLSer(const char *ser_dev, tfl_tm_t *data, TFLCmd *HCmd);
    ~TFLSer();
    int ProcessData(int flag);
    Timeout *GetTimeout();
  private:
    void init_termios();
    void update_termios();
    enum TFL_Parse_Resp { TFLP_Die, TFLP_Wait, TFLP_OK };
    TFL_Parse_Resp parse_response();
    int not_channel(const char *name, unsigned int &val, int ndecimals, const char *unit);
    int not_ufixed(unsigned int &val, int ndecimals);
    int not_unsigned(unsigned int &val);
    TFLCmd *Cmd;
    short cur_min;
    termios termios_s;
    Timeout TO;
    tfl_tm_t *TMdata;
    //* List of poll commands
    std::vector<TFLQuery> Qlist;
    TFLQuery *CurQuery;
    unsigned int nq, qn, cmdq;
    enum TFL_State {TFLS_Idle, TFLS_WaitResp} state;
};

#endif // __cplusplus

#endif
