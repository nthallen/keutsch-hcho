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
dfs.plot('m', 'label', 'Monitor', 'plots', {'mrc','mlp','mlv'});
dfs.plot('mrc','label','Ref Cts','vars',{'BCtr_0_a'});
dfs.plot('mlp','label','Laser P','vars',{'BCtr_LasIn_mW','LasOut_mW'});
dfs.plot('mlv','label','Laser V','vars',{'BCtr_LaserV'});
dfs.plot('a', 'label', 'Analysis', 'plots', {'appb'});
dfs.plot('appb','label','ppb','vars',{'hcho_mr'});
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
dfs.end_col;
dfs.start_col;
dfs.plot('sws', 'label', 'SW Status', 'plots', {'swssws','swsf','swsd'});
dfs.plot('swssws','label','SW Stat','vars',{'SWStat'});
dfs.plot('swsf','label','Flag','vars',{'Flag'});
dfs.plot('swsd','label','Drift','vars',{'Drift_Limit'});
dfs.plot('hc', 'label', 'Htr Ctrl', 'plots', {'hcv','hcs'});
dfs.plot('hcv','label','V','vars',{'HtrDAC1_SP','HtrDAC1_RB','HtrADC1'});
dfs.plot('hcs','label','Status','vars',{{'name','HtrDAC1_Fresh','var_name','Htr_Status','bit_number',7},{'name','HtrDAC2_Fresh','var_name','Htr_Status','bit_number',11},{'name','HtrADC1_Fresh','var_name','Htr_Status','bit_number',2},{'name','HtrADC2_Fresh','var_name','Htr_Status','bit_number',3}});
dfs.plot('ts', 'label', 'Temp Sensors', 'plots', {'tsv','tsc'});
dfs.plot('tsv','label','Volts','vars',{'TS1_T','TS3_T','TS5_T'});
dfs.plot('tsc','label','Count','vars',{'TS1_cnt','TS3_cnt','TS5_cnt'});
dfs.plot('l', 'label', 'Laser', 'plots', {'lp','lv','ls'});
dfs.plot('lp','label','Power','vars',{'LasIn_mW','LasOut_mW'});
dfs.plot('lv','label','Volts','vars',{'LaserV','LV_start','LV_stop','LV_online','LV_offline'});
dfs.plot('ls','label','Status','vars',{{'name','LV_scanning','var_name','LV_status','bit_number',0},{'name','LV_is_online','var_name','LV_status','bit_number',1},{'name','LV_is_offline','var_name','LV_status','bit_number',2}});
dfs.plot('lhk', 'label', 'Laser HK', 'plots', {'lhks','lhknp','lhkv'});
dfs.plot('lhks','label','Step','vars',{'LV_step','LV_offdelta','LV_dither'});
dfs.plot('lhknp','label','N Pts','vars',{'NPts_Online','NPts_Offline'});
dfs.plot('lhkv','label','Volts','vars',{'LV_online'});
dfs.end_col;
dfs.start_col;
dfs.plot('fcc', 'label', 'FCC', 'plots', {'fccz','fccs','fccb','fcct','fccstatus'});
dfs.plot('fccz','label','Zero','vars',{'FC0_Flow','FC0_Set'});
dfs.plot('fccs','label','Span','vars',{'FC1_Flow','FC1_Set'});
dfs.plot('fccb','label','Bypass','vars',{'FC2_Flow','FC2_Set'});
dfs.plot('fcct','label','Temps','vars',{'FCC_U2_T','FCC_U3_T'});
dfs.plot('fccstatus','label','Status','vars',{{'name','FC0Open','var_name','FCC0_Status','bit_number',0},{'name','FC1Open','var_name','FCC0_Status','bit_number',1},{'name','FC2Open','var_name','FCC0_Status','bit_number',2},{'name','Vlv1','var_name','FCC0_Status','bit_number',3},{'name','FC0Closed','var_name','FCC0_Status','bit_number',4},{'name','FC1Closed','var_name','FCC0_Status','bit_number',5},{'name','FC2Closed','var_name','FCC0_Status','bit_number',6},{'name','Vlv2','var_name','FCC0_Status','bit_number',7}});
dfs.plot('fcc2', 'label', 'FCC2', 'plots', {'fcc2f','fcc2p'});
dfs.plot('fcc2f','label','Flow','vars',{'SampleFlow','PurgeFlow'});
dfs.plot('fcc2p','label','P','vars',{'OmegaP'});
dfs.plot('tm', 'label', 'T Mbase', 'plots', {'tmtd','tmcpu','tmram','tmd'});
dfs.plot('tmtd','label','T Drift','vars',{'SysTDrift'});
dfs.plot('tmcpu','label','CPU','vars',{'CPU_Pct'});
dfs.plot('tmram','label','RAM','vars',{'memused'});
dfs.plot('tmd','label','Disk','vars',{'Disk'});
dfs.end_col;
dfs.start_col;
dfs.plot('bc', 'label', 'B Ctr', 'plots', {'bcr','bcs','bcnw','bcip','bcnt','bclv','bclp','bcstatus','bcnab'});
dfs.plot('bcr','label','Reference','vars',{'BCtr_0_a'});
dfs.plot('bcs','label','Sample','vars',{'BCtr_1_a'});
dfs.plot('bcnw','label','N Words','vars',{'BCtr_NWords'});
dfs.plot('bcip','label','I Pnum','vars',{'BCtr_IPnum'});
dfs.plot('bcnt','label','N Trigger','vars',{'BCtr_NTrigger'});
dfs.plot('bclv','label','Laser V','vars',{'BCtr_LaserV'});
dfs.plot('bclp','label','Laser P','vars',{'BCtr_LasIn_mW'});
dfs.plot('bcstatus','label','Status','vars',{{'name','BCtr_Pfrsh','var_name','BCtr_Pfresh','bit_number',0},{'name','BC_scanning','var_name','BCtr_LVstat','bit_number',0},{'name','BC_Online','var_name','BCtr_LVstat','bit_number',1},{'name','BC_Offline','var_name','BCtr_LVstat','bit_number',2},{'name','BC_Chopping','var_name','BCtr_LVstat','bit_number',3},{'name','BC_PosOVF','var_name','BCtr_LVstat','bit_number',4},{'name','BCtr_Ready','var_name','BCtr_Status','bit_number',5},{'name','BCtr_Enable','var_name','BCtr_Status','bit_number',0},{'name','BCtr_DRdy','var_name','BCtr_Status','bit_number',1},{'name','BCtr_Tx','var_name','BCtr_Status','bit_number',2},{'name','BCtr_CfgOvf','var_name','BCtr_Status','bit_number',3},{'name','BCtr_CfgNAB','var_name','BCtr_Status','bit_number',4},{'name','BCtr_TxOvf','var_name','BCtr_Status','bit_number',9},{'name','BCtr_Expired','var_name','BCtr_Status','bit_number',10}});
dfs.plot('bcnab','label','NAB','vars',{'BCtr_NAB'});
dfs.plot('hgs', 'label', 'HG Stale', 'plots', {'hgsmes','hgsshgs','hgsthgs'});
dfs.plot('hgsmes','label','ME Stale','vars',{'HG_Stale'});
dfs.plot('hgsshgs','label','SHG Stale','vars',{'SHG_Stale'});
dfs.plot('hgsthgs','label','THG Stale','vars',{'THG_Stale'});
dfs.plot('hge', 'label', 'HG Errors', 'plots', {'hgeshge','hgethge'});
dfs.plot('hgeshge','label','SHG Errors','vars',{'SHG_ErrorNumber','SHG_ErrorInstance','SHG_ErrorParameter'});
dfs.plot('hgethge','label','THG Errors','vars',{'THG_ErrorNumber','THG_ErrorInstance','THG_ErrorParameter'});
dfs.end_col;
dfs.start_col;
dfs.plot('hgshg', 'label', 'HG SHG', 'plots', {'hgshgt','hgshgc','hgshgv','hgshgs'});
dfs.plot('hgshgt','label','Temp','vars',{'SHG_T','SHG_Set_T'});
dfs.plot('hgshgc','label','Current','vars',{'SHG_OutputCurrent'});
dfs.plot('hgshgv','label','Voltage','vars',{'SHG_OutputVoltage'});
dfs.plot('hgshgs','label','Status','vars',{'SHG_DevStatus'});
dfs.plot('hgthg', 'label', 'HG THG', 'plots', {'hgthgt','hgthgc','hgthgv','hgthgs'});
dfs.plot('hgthgt','label','Temp','vars',{'THG_T','THG_Set_T'});
dfs.plot('hgthgc','label','Current','vars',{'THG_OutputCurrent'});
dfs.plot('hgthgv','label','Voltage','vars',{'THG_OutputVoltage'});
dfs.plot('hgthgs','label','Status','vars',{'THG_DevStatus'});
dfs.end_col;
dfs.set_connection('127.0.0.1', 1417);
if nargout > 0
  dfs_out = dfs;
else
  dfs.resize(context_level);
end
