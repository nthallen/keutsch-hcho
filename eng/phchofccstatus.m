function phchofccstatus(varargin);
% phchofccstatus( [...] );
% FCC Status
h = ne_dstat({
  'FC0Open', 'FCC0_Status', 0; ...
	'FC1Open', 'FCC0_Status', 1; ...
	'FC2Open', 'FCC0_Status', 2; ...
	'Vlv1', 'FCC0_Status', 3; ...
	'FC0Closed', 'FCC0_Status', 4; ...
	'FC1Closed', 'FCC0_Status', 5; ...
	'FC2Closed', 'FCC0_Status', 6; ...
	'Vlv2', 'FCC0_Status', 7 }, 'Status', varargin{:} );
