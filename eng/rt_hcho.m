function dfs_out = rt_hcho(dfs)
% dfs = rt_hcho()
%   Create a data_fields object and setup all the buttons for realtime
%   plots
% dfs_out = rt_hcho(dfs)
%   Use the data_fields object and setup all the buttons for realtime plots
if nargin < 1
  dfs = data_fields('title', 'HCHO Instrument', ...
    'Color', [.8 .8 1], ...
    'h_leading', 8, 'v_leading', 2, ...
    'btn_fontsize', 12, ...
    'txt_fontsize', 12);
  context_level = dfs.rt_init;
else
  context_level = 1;
end
dfs.start_col;
dfs.plot('pps', 'label', 'PPS', 'plots', {'ppsd','ppsr','ppsf'});
dfs.plot('ppsd','label','Drift','vars',{'PPS_drift','PPS_min_drift'});
dfs.plot('ppsr','label','Raw','vars',{'PPS_time'});
dfs.plot('ppsf','label','Fine','vars',{'PPS_fine'});
dfs.plot('ips', 'label', 'IPS', 'plots', {'ipsf','ipse','ipss'});
dfs.plot('ipsf','label','Fine','vars',{'IPS_fine'});
dfs.plot('ipse','label','Error','vars',{'IPS_err'});
dfs.plot('ipss','label','Status','vars',{'IPS_status'});
dfs.plot('c', 'label', 'Cell', 'plots', {'ct','cp'});
dfs.plot('ct','label','T','vars',{'CellT'});
dfs.plot('cp','label','P','vars',{'OmegaP'});
dfs.plot('sws', 'label', 'SW Status', 'plots', {'swssws','swsf','swsd'});
dfs.plot('swssws','label','SW Stat','vars',{'SWStat'});
dfs.plot('swsf','label','Flag','vars',{'Flag'});
dfs.plot('swsd','label','Drift','vars',{'Drift_Limit'});
dfs.plot('hc', 'label', 'Htr Ctrl', 'plots', {'hcv','hcs'});
dfs.plot('hcv','label','V','vars',{'HtrDAC1_SP','HtrDAC1_RB','HtrADC1'});
dfs.plot('hcs','label','Status','vars',{{'name','HtrDAC1_Fresh','var_name','Htr_Status','bit_number',7},{'name','HtrDAC2_Fresh','var_name','Htr_Status','bit_number',11},{'name','HtrADC1_Fresh','var_name','Htr_Status','bit_number',2},{'name','HtrADC2_Fresh','var_name','Htr_Status','bit_number',3}});
dfs.end_col;
dfs.start_col;
dfs.plot('ts', 'label', 'Temp Sensors', 'plots', {'tst','tsc'});
dfs.plot('tst','label','Temp','vars',{'TS0_T','TS1_T','TS2_T','TS3_T','TS4_T','TS5_T'});
dfs.plot('tsc','label','Count','vars',{'TS0_cnt','TS1_cnt','TS2_cnt','TS3_cnt','TS4_cnt','TS5_cnt'});
dfs.plot('l', 'label', 'Laser', 'plots', {'lp','lv','ls','lstatus','lnp'});
dfs.plot('lp','label','Power','vars',{'LasIn_mW','LasOut_mW'});
dfs.plot('lv','label','Volts','vars',{'LaserV','LV_start','LV_stop','LV_online','LV_offline'});
dfs.plot('ls','label','Step','vars',{'LV_step','LV_offdelta','LV_dither'});
dfs.plot('lstatus','label','Status','vars',{{'name','LV_scanning','var_name','LV_status','bit_number',0},{'name','LV_is_online','var_name','LV_status','bit_number',1},{'name','LV_is_offline','var_name','LV_status','bit_number',2}});
dfs.plot('lnp','label','N Pts','vars',{'NPts_Online','NPts_Offline'});
dfs.plot('fcc', 'label', 'FCC', 'plots', {'fccf','fccflow1','fccflow2','fcct','fccs'});
dfs.plot('fccf','label','Flow 0','vars',{'FC0_Flow','FC0_Set'});
dfs.plot('fccflow1','label','Flow 1','vars',{'FC1_Flow','FC1_Set'});
dfs.plot('fccflow2','label','Flow 2','vars',{'FC2_Flow','FC2_Set'});
dfs.plot('fcct','label','Temps','vars',{'FCC_U2_T','FCC_U3_T'});
dfs.plot('fccs','label','Status','vars',{{'name','FC0Open','var_name','FCC0_Status','bit_number',0},{'name','FC1Open','var_name','FCC0_Status','bit_number',1},{'name','FC2Open','var_name','FCC0_Status','bit_number',2},{'name','Vlv1','var_name','FCC0_Status','bit_number',3},{'name','FC0Closed','var_name','FCC0_Status','bit_number',4},{'name','FC1Closed','var_name','FCC0_Status','bit_number',5},{'name','FC2Closed','var_name','FCC0_Status','bit_number',6},{'name','Vlv2','var_name','FCC0_Status','bit_number',7}});
dfs.plot('fcc2', 'label', 'FCC2', 'plots', {'fcc2f','fcc2p'});
dfs.plot('fcc2f','label','Flow','vars',{'SampleFlow','PurgeFlow'});
dfs.plot('fcc2p','label','P','vars',{'OmegaP'});
dfs.end_col;
dfs.start_col;
dfs.plot('tm', 'label', 'T Mbase', 'plots', {'tmtd','tmcpu','tmram','tmd'});
dfs.plot('tmtd','label','T Drift','vars',{'SysTDrift'});
dfs.plot('tmcpu','label','CPU','vars',{'CPU_Pct'});
dfs.plot('tmram','label','RAM','vars',{'memused'});
dfs.plot('tmd','label','Disk','vars',{'Disk'});
dfs.plot('bc', 'label', 'B Ctr', 'plots', {'bcc','bcnw','bcip','bcnt','bclv','bclp','bcs','bcnab'});
dfs.plot('bcc','label','Cts','vars',{'BCtr_0_a','BCtr_1_a'});
dfs.plot('bcnw','label','N Words','vars',{'BCtr_NWords'});
dfs.plot('bcip','label','I Pnum','vars',{'BCtr_IPnum'});
dfs.plot('bcnt','label','N Trigger','vars',{'BCtr_NTrigger'});
dfs.plot('bclv','label','Laser V','vars',{'BCtr_LaserV'});
dfs.plot('bclp','label','Laser P','vars',{'BCtr_LasIn_mW'});
dfs.plot('bcs','label','Status','vars',{{'name','BCtr_Pfrsh','var_name','BCtr_Pfresh','bit_number',0},{'name','BC_scanning','var_name','BCtr_LVstat','bit_number',0},{'name','BC_Online','var_name','BCtr_LVstat','bit_number',1},{'name','BC_Offline','var_name','BCtr_LVstat','bit_number',2},{'name','BC_Chopping','var_name','BCtr_LVstat','bit_number',3},{'name','BC_PosOVF','var_name','BCtr_LVstat','bit_number',4},{'name','BCtr_Ready','var_name','BCtr_Status','bit_number',5},{'name','BCtr_Enable','var_name','BCtr_Status','bit_number',0},{'name','BCtr_DRdy','var_name','BCtr_Status','bit_number',1},{'name','BCtr_Tx','var_name','BCtr_Status','bit_number',2},{'name','BCtr_CfgOvf','var_name','BCtr_Status','bit_number',3},{'name','BCtr_CfgNAB','var_name','BCtr_Status','bit_number',4},{'name','BCtr_TxOvf','var_name','BCtr_Status','bit_number',9},{'name','BCtr_Expired','var_name','BCtr_Status','bit_number',10}});
dfs.plot('bcnab','label','NAB','vars',{'BCtr_NAB'});
dfs.end_col;
dfs.resize(context_level);
dfs.set_connection('127.0.0.1', 1080);
if nargout > 0
  dfs_out = dfs;
end
