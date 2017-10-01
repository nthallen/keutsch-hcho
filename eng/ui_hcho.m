function ui_hcho
f = ne_dialg('HCHO Instrument',1);
f = ne_dialg(f, 'add', 0, 1, 'ghchotm', 'T Mbase' );
f = ne_dialg(f, 'add', 1, 0, 'phchotmtd', 'T Drift' );
f = ne_dialg(f, 'add', 1, 0, 'phchotmcpu', 'CPU' );
f = ne_dialg(f, 'add', 1, 0, 'phchotmram', 'RAM' );
f = ne_dialg(f, 'add', 1, 0, 'phchotmd', 'Disk' );
f = ne_listdirs(f, 'HCHO_DATA_DIR', 15);
f = ne_dialg(f, 'newcol');
ne_dialg(f, 'resize');
