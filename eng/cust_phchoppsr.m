function cust_phchoppsr(h)
% cust_phchoppsr(h)
% Customize plot created by phchoppsr

% phchoppsr's definition:

% function phchoppsr(varargin);
% % phchoppsr( [...] );
% % PPS Raw
% h = timeplot({'PPS_time'}, ...
%       'PPS Raw', ...
%       'Raw', ...
%       {'PPS\_time'}, ...
%       varargin{:} );

% Example customizations include:
 set(h,'LineStyle','none','Marker','.');
%   ax = get(h(1),'parent');
%   set(ax,'ylim',[0 800]);
