function phcholstatus(varargin);
% phcholstatus( [...] );
% Laser Status
h = ne_dstat({
  'LV_scanning', 'LV_status', 0; ...
	'LV_is_online', 'LV_status', 1; ...
	'LV_is_offline', 'LV_status', 2 }, 'Status', varargin{:} );
