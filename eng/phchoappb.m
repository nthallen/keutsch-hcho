function phchoappb(varargin);
% phchoappb( [...] );
% Analysis ppb
h = timeplot({'hcho_mr'}, ...
      'Analysis ppb', ...
      'ppb', ...
      {'hcho\_mr'}, ...
      varargin{:} );
