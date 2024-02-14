function fig = ghchom(varargin);
% ghchom(...)
% Monitor
ffig = ne_group(varargin,'Monitor','phchomrc','phchomlp','phchomlv');
if nargout > 0 fig = ffig; end
