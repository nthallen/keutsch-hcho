function ui_hcho(dirfunc, stream)
% ui_hcho
% ui_hcho(dirfunc [, stream])
% dirfunc is a string specifying the name of a function
%   that specifies where data run directories are stored.
% stream is an optional argument specifying which stream
%   the run directories have recorded, e.g. 'SerIn'
if nargin < 1
  dirfunc = 'HCHO_DATA_DIR';
end
if nargin >= 2
  f = ne_dialg(stream, 1);
else
  f = ne_dialg('HCHO Instrument',1);
end
f = ne_dialg(f, 'add', 0, 1, 'ghchom', 'Monitor' );
f = ne_dialg(f, 'add', 1, 0, 'phchomrc', 'Ref Cts' );
f = ne_dialg(f, 'add', 1, 0, 'phchomlp', 'Laser P' );
f = ne_dialg(f, 'add', 1, 0, 'phchomlv', 'Laser V' );
f = ne_dialg(f, 'add', 0, 1, 'ghchoa', 'Analysis' );
f = ne_dialg(f, 'add', 1, 0, 'phchoappb', 'ppb' );
f = ne_dialg(f, 'add', 0, 1, 'ghchopps', 'PPS' );
f = ne_dialg(f, 'add', 1, 0, 'phchoppsd', 'Drift' );
f = ne_dialg(f, 'add', 1, 0, 'phchoppsr', 'Raw' );
f = ne_dialg(f, 'add', 1, 0, 'phchoppsf', 'Fine' );
f = ne_dialg(f, 'add', 0, 1, 'ghchoips', 'IPS' );
f = ne_dialg(f, 'add', 1, 0, 'phchoipsf', 'Fine' );
f = ne_dialg(f, 'add', 1, 0, 'phchoipse', 'Error' );
f = ne_dialg(f, 'add', 1, 0, 'phchoipss', 'Status' );
f = ne_dialg(f, 'add', 0, 1, 'ghchoc', 'Cell' );
f = ne_dialg(f, 'add', 1, 0, 'phchoct', 'T' );
f = ne_dialg(f, 'add', 1, 0, 'phchocp', 'P' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'ghchosws', 'SW Status' );
f = ne_dialg(f, 'add', 1, 0, 'phchoswssws', 'SW Stat' );
f = ne_dialg(f, 'add', 1, 0, 'phchoswsf', 'Flag' );
f = ne_dialg(f, 'add', 1, 0, 'phchoswsd', 'Drift' );
f = ne_dialg(f, 'add', 0, 1, 'ghchohc', 'Htr Ctrl' );
f = ne_dialg(f, 'add', 1, 0, 'phchohcv', 'V' );
f = ne_dialg(f, 'add', 1, 0, 'phchohcs', 'Status' );
f = ne_dialg(f, 'add', 0, 1, 'ghchots', 'Temp Sensors' );
f = ne_dialg(f, 'add', 1, 0, 'phchotsv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'phchotsc', 'Count' );
f = ne_dialg(f, 'add', 0, 1, 'ghchol', 'Laser' );
f = ne_dialg(f, 'add', 1, 0, 'phcholp', 'Power' );
f = ne_dialg(f, 'add', 1, 0, 'phcholv', 'Volts' );
f = ne_dialg(f, 'add', 1, 0, 'phchols', 'Status' );
f = ne_dialg(f, 'add', 0, 1, 'ghcholhk', 'Laser HK' );
f = ne_dialg(f, 'add', 1, 0, 'phcholhks', 'Step' );
f = ne_dialg(f, 'add', 1, 0, 'phcholhknp', 'N Pts' );
f = ne_dialg(f, 'add', 1, 0, 'phcholhkv', 'Volts' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'ghchofcc', 'FCC' );
f = ne_dialg(f, 'add', 1, 0, 'phchofccz', 'Zero' );
f = ne_dialg(f, 'add', 1, 0, 'phchofccs', 'Span' );
f = ne_dialg(f, 'add', 1, 0, 'phchofccb', 'Bypass' );
f = ne_dialg(f, 'add', 1, 0, 'phchofcct', 'Temps' );
f = ne_dialg(f, 'add', 1, 0, 'phchofccstatus', 'Status' );
f = ne_dialg(f, 'add', 0, 1, 'ghchofcc2', 'FCC2' );
f = ne_dialg(f, 'add', 1, 0, 'phchofcc2f', 'Flow' );
f = ne_dialg(f, 'add', 1, 0, 'phchofcc2p', 'P' );
f = ne_dialg(f, 'add', 0, 1, 'ghchotm', 'T Mbase' );
f = ne_dialg(f, 'add', 1, 0, 'phchotmtd', 'T Drift' );
f = ne_dialg(f, 'add', 1, 0, 'phchotmcpu', 'CPU' );
f = ne_dialg(f, 'add', 1, 0, 'phchotmram', 'RAM' );
f = ne_dialg(f, 'add', 1, 0, 'phchotmd', 'Disk' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'ghchobc', 'B Ctr' );
f = ne_dialg(f, 'add', 1, 0, 'phchobcr', 'Reference' );
f = ne_dialg(f, 'add', 1, 0, 'phchobcs', 'Sample' );
f = ne_dialg(f, 'add', 1, 0, 'phchobcnw', 'N Words' );
f = ne_dialg(f, 'add', 1, 0, 'phchobcip', 'I Pnum' );
f = ne_dialg(f, 'add', 1, 0, 'phchobcnt', 'N Trigger' );
f = ne_dialg(f, 'add', 1, 0, 'phchobclv', 'Laser V' );
f = ne_dialg(f, 'add', 1, 0, 'phchobclp', 'Laser P' );
f = ne_dialg(f, 'add', 1, 0, 'phchobcstatus', 'Status' );
f = ne_dialg(f, 'add', 1, 0, 'phchobcnab', 'NAB' );
f = ne_dialg(f, 'add', 0, 1, 'ghchohgs', 'HG Stale' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgsmes', 'ME Stale' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgsshgs', 'SHG Stale' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgsthgs', 'THG Stale' );
f = ne_dialg(f, 'add', 0, 1, 'ghchohge', 'HG Errors' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgeshge', 'SHG Errors' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgethge', 'THG Errors' );
f = ne_dialg(f, 'newcol');
f = ne_dialg(f, 'add', 0, 1, 'ghchohgshg', 'HG SHG' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgshgt', 'Temp' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgshgc', 'Current' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgshgv', 'Voltage' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgshgs', 'Status' );
f = ne_dialg(f, 'add', 0, 1, 'ghchohgthg', 'HG THG' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgthgt', 'Temp' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgthgc', 'Current' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgthgv', 'Voltage' );
f = ne_dialg(f, 'add', 1, 0, 'phchohgthgs', 'Status' );
f = ne_listdirs(f, dirfunc, 15);
f = ne_dialg(f, 'newcol');
ne_dialg(f, 'resize');
