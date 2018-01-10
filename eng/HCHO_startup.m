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
ui_hcho;
