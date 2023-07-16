function phchobcs(varargin);
% phchobcs( [...] );
% B Ctr Status
h = ne_dstat({
  'BCtr_Pfrsh', 'BCtr_Pfresh', 0; ...
	'BC_scanning', 'BCtr_LVstat', 0; ...
	'BC_Online', 'BCtr_LVstat', 1; ...
	'BC_Offline', 'BCtr_LVstat', 2; ...
	'BC_Chopping', 'BCtr_LVstat', 3; ...
	'BC_PosOVF', 'BCtr_LVstat', 4; ...
	'BCtr_Ready', 'BCtr_Status', 5; ...
	'BCtr_Enable', 'BCtr_Status', 0; ...
	'BCtr_DRdy', 'BCtr_Status', 1; ...
	'BCtr_Tx', 'BCtr_Status', 2; ...
	'BCtr_CfgOvf', 'BCtr_Status', 3; ...
	'BCtr_CfgNAB', 'BCtr_Status', 4; ...
	'BCtr_TxOvf', 'BCtr_Status', 9; ...
	'BCtr_Expired', 'BCtr_Status', 10 }, 'Status', varargin{:} );
