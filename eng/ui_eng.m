function ui_eng
f = ne_dialg('Engineering Data',1);
f = ne_dialg(f, 'add', 0, 1, 'gengtm', 'T Mbase' );
f = ne_dialg(f, 'add', 1, 0, 'pengtmtd', 'T Drift' );
f = ne_dialg(f, 'add', 1, 0, 'pengtmcpu', 'CPU' );
f = ne_dialg(f, 'add', 1, 0, 'pengtmram', 'RAM' );
f = ne_dialg(f, 'add', 1, 0, 'pengtmd', 'Disk' );
f = ne_listdirs(f, 'C:/home/Exp', 15);
f = ne_dialg(f, 'newcol');
ne_dialg(f, 'resize');
