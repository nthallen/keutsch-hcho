function HCHO_startup(ui_func_handle, data_dir_func_name, title)
% getrun_startup(ui_func_handle, data_dir_func_name, title);
% ui_func_handle: handle of the ui_ function to start the instrument's
%   engineering graphing tool
% data_dir_func_name: char array with the name of the data_dir_func.
% title: (optional) char array specifying the title to display on the UI
%
% The directory reported by the data_dir_func is the location where
% runs.dat is located.
pdir = ne_load_runsdir(data_dir_func_name);
cd(pdir);
[fd,~] = fopen('runs.dat','r');
if fd > 0
    tline = fgetl(fd);
    while ischar(tline)
        fprintf(1,'Processing: "%s"\n', tline);
        if exist(tline,'dir') == 7
            oldfolder = cd(tline);
            if exist('BCtrext.csv')
              BCtr = load('BCtrext.csv');
              TBCtr = BCtr(:,1);
              PPSoffset = BCtr(:,2);
              Status = BCtr(:,3);
              NWords = BCtr(:,4);
              IPnum = BCtr(:,5);
              NTrigger = BCtr(:,6)+65536*BCtr(:,7);
              LaserV = BCtr(:,8);
              BCtr0 = BCtr(:,9:2:end);
              BCtr1 = BCtr(:,10:2:end);
              save BCtr.mat TBCtr PPSoffset Status NWords IPnum NTrigger LaserV BCtr0 BCtr1
              movefile('BCtrext.csv','BCtrext.csv.done');
              clear TBCtr BCtr Status NWords NSkip BCtr0 BCtr1
              %delete BCtrext.csv
            end
            csv2mat;
            delete *.csv
            if exist('SSP_xform.m','file') && exist('SSP','dir')
              SSP_xform;
              movefile('SSP','SSP.orig');
              fprintf(1,'Rewriting scans from SSP.orig to SSP\n');
              rewrite_scans('SSP.orig','SSP',M);
              movefile('SSP_xform.m','SSP_xformed.m');
            end
            cd(oldfolder);
        end
        tline = fgetl(fd);
    end
    fclose(fd);
    delete runs.dat
end
clear fd msg oldfolder tline
if nargin < 3
  ui_func_handle(data_dir_func_name);
else
  ui_func_handle(data_dir_func_name, title);
end
