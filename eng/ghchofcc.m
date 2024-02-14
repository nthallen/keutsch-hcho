function fig = ghchofcc(varargin);
% ghchofcc(...)
% FCC
ffig = ne_group(varargin,'FCC','phchofccz','phchofccs','phchofccb','phchofcct','phchofccstatus');
if nargout > 0 fig = ffig; end
