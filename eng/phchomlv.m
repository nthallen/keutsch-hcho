function phchomlv(varargin);
% phchomlv( [...] );
% Monitor Laser V
h = timeplot({'BCtr_LaserV'}, ...
      'Monitor Laser V', ...
      'Laser V', ...
      {'BCtr\_LaserV'}, ...
      varargin{:} );
