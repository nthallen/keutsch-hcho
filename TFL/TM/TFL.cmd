%{
  typedef struct {
    int address;
    double value;
    int scale;
  } TFL_Cmd;
%}
%INTERFACE <TFL>

&command
  : TFL Set &tfl_valcmd * {
      if_TFL.Turf("W%d:%.0lf\n", $3.address, $3.value * $3.scale); }
  : TFL Laser &tfl_on_off * { if_TFL.Turf("W5:%d\n", $3); }
  ;
&tfl_valcmd <TFL_Cmd>
  : Seed Diode 1 Temperature %lf (Celcius) C {
      $0.address = 0;
      $0.value = $5;
      $0.scale = 10;
    }
  : Seed Diode 1 Current %lf (Enter mA) mA {
      $0.address = 1;
      $0.value = $5;
      $0.scale = 1;
    }
  : Pump Diode Current %lf (Enter Amps) A {
      $0.address = 2;
      $0.value = $4;
      $0.scale = 100;
    }
  : SHG Temperature %lf (Enter Celcius) C {
      $0.address = 3;
      $0.value = $3;
      $0.scale = 100;
    }
  : THG Temperature %lf (Enter Celcius) C {
      $0.address = 4;
      $0.value = $3;
      $0.scale = 100;
    }
  ;
&tfl_on_off <int>
  : on { $0 = 1; }
  : off { $0 = 0; }
  ;

