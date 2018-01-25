function cust_phchobcnw(h)
% cust_phchobcnw(h)
% Customize plot created by phchobcnw

% phchobcnw's definition:

% function phchobcnw(varargin);
% % phchobcnw( [...] );
% % B Ctr N Words
% h = timeplot({'BCtr_NWords'}, ...
%       'B Ctr N Words', ...
%       'N Words', ...
%       {'BCtr\_NWords'}, ...
%       varargin{:} );

% Example customizations include:
set(h,'LineStyle','none','Marker','.');
%   ax = get(h(1),'parent');
%   set(ax,'ylim',[0 800]);
