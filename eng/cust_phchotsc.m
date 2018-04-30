function cust_phchotsc(h)
% cust_phchotsc(h)
% Customize plot created by phchotsc

% phchotsc's definition:

% function phchotsc(varargin);
% % phchotsc( [...] );
% % Temp Sensors Count
% h = timeplot({'TS0_cnt','TS1_cnt','TS2_cnt','TS3_cnt','TS4_cnt','TS5_cnt'}, ...
%       'Temp Sensors Count', ...
%       'Count', ...
%       {'TS0\_cnt','TS1\_cnt','TS2\_cnt','TS3\_cnt','TS4\_cnt','TS5\_cnt'}, ...
%       varargin{:} );

% Example customizations include:
set(h,'LineStyle','none','Marker','.');
%   ax = get(h(1),'parent');
%   set(ax,'ylim',[0 800]);
