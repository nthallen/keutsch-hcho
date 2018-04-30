function cust_phchotflhgt(h)
% cust_phchotflhgt(h)
% Customize plot created by phchotflhgt

% phchotflhgt's definition:

% function phchotflhgt(varargin);
% % phchotflhgt( [...] );
% % TFL HGT
% h = timeplot({'TFL_SHG','TFL_THG'}, ...
%       'TFL HGT', ...
%       'HGT', ...
%       {'TFL\_SHG','TFL\_THG'}, ...
%       varargin{:} );

% Example customizations include:
set(h,'LineStyle','none','Marker','.');
%   ax = get(h(1),'parent');
%   set(ax,'ylim',[0 800]);
