function fig = ghchosws(varargin);
% ghchosws(...)
% SW Status
ffig = ne_group(varargin,'SW Status','phchoswssws','phchoswsf','phchoswsnp','phchoswsd','phchoswsdrift');
if nargout > 0 fig = ffig; end
