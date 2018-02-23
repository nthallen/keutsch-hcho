function cust_phchobcnt(h)
% cust_phchobcnt(h)
% Customize plot created by phchobcnt

% phchobcnt's definition:

% function phchobcnt(varargin);
% % phchobcnt( [...] );
% % B Ctr N Trigger
% h = timeplot({'BCtr_NTrigger'}, ...
%       'B Ctr N Trigger', ...
%       'N Trigger', ...
%       {'BCtr\_NTrigger'}, ...
%       varargin{:} );

% Example customizations include:
set(h,'LineStyle','none','Marker','.');
%   ax = get(h(1),'parent');
%   set(ax,'ylim',[0 800]);
