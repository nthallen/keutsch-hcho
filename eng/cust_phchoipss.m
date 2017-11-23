function cust_phchoipss(h)
% cust_phchoipss(h)
% Customize plot created by phchoipss

% phchoipss's definition:

% function phchoipss(varargin);
% % phchoipss( [...] );
% % IPS Status
% h = timeplot({'IPS_status'}, ...
%       'IPS Status', ...
%       'Status', ...
%       {'IPS\_status'}, ...
%       varargin{:} );

% Example customizations include:
set(h,'LineStyle','none','Marker','.');
%   ax = get(h(1),'parent');
%   set(ax,'ylim',[0 800]);
