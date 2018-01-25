function cust_phchobcip(h)
% cust_phchobcip(h)
% Customize plot created by phchobcip

% phchobcip's definition:

% function phchobcip(varargin);
% % phchobcip( [...] );
% % B Ctr I Pnum
% h = timeplot({'BCtr_IPnum'}, ...
%       'B Ctr I Pnum', ...
%       'I Pnum', ...
%       {'BCtr\_IPnum'}, ...
%       varargin{:} );

% Example customizations include:
set(h,'LineStyle','none','Marker','.');
%   ax = get(h(1),'parent');
%   set(ax,'ylim',[0 800]);
