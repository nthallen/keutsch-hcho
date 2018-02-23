function phchotfls(varargin);
% phchotfls( [...] );
% TFL Status
h = ne_dstat({
  'Fresh', 'TFL_Status', 0; ...
	'LCmd', 'TFL_Status', 1; ...
	'Laser', 'TFL_Status', 2 }, 'Status', varargin{:} );
