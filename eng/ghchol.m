function fig = ghchol(varargin);
% ghchol(...)
% Laser
ffig = ne_group(varargin,'Laser','phcholp','phcholv','phchols','phcholstatus','phcholnp');
if nargout > 0 fig = ffig; end
