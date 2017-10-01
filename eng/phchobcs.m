function phchobcs(varargin);
% phchobcs( [...] );
% B Ctr Status
h = ne_dstat({
  'BCtr_Ready', 'BCtr_Status', 5; ...
	'BCtr_Enable', 'BCtr_Status', 0; ...
	'BCtr_DRdy', 'BCtr_Status', 1; ...
	'BCtr_Tx', 'BCtr_Status', 2; ...
	'BCtr_CfgOvf', 'BCtr_Status', 3; ...
	'BCtr_CfgNAB', 'BCtr_Status', 4; ...
	'BCtr_TxOvf', 'BCtr_Status', 9 }, 'Status', varargin{:} );
