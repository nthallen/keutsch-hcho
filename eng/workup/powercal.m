% function power = UDTcal(udt,caldate,plotme)
% feed this function a udt signal (in V) to get back power (in mW). Note
% that using this function requires that you have done a power calibration
% on the UDT, which can change with orientation and time.
% INPUTS:
    % udt: raw udt voltage
    % caldate: date of calibration to use for correction (optional but recommended)
    % plotme: flag for generating a plot of the calibration curve (optional)
%OUTPUT:
    % power: UDT signal corrected to mW of laser power.
%110823 GMW

function power = powercal(udt,caldate,plotme)

%set defaults for optional inputs
if nargin<3
    plotme=0;
    if nargin<2
        caldate = '08MAR2018';
        disp('Using default power function. Your power meters may not be calibrated')
    end
end
    
%Choose calibration curve
switch caldate
    case '08MAR2018' 
        power_cal = [12.1 9.3 10.0 8.3 7.0 6.1 5.0 4.0 3.6 3.1 2.5 2.0 1.5 0.75 0.0];
        udt_cal = [0.272 0.237 0.2450 0.216 0.1880 0.1660 0.1410 0.1190 0.1065 0.0920 0.0770 0.063 0.048 0.025 0.0002]; %LasPwrIn values
    case '24MAR2018' 
        power_cal = [11.65 11.2 10.55 9.45 8.3 7.05 6.15 5.3 4.45 3.95 3.45 3.0 2.65 2.0 1.7 1.4 1.0 0.0];
        udt_cal = [0.281 0.273 0.261 0.244 0.220 0.1940 0.1730 0.1530 0.1340 0.1180 0.1050 0.093 0.082 0.0645 0.056 0.047 0.034 0.0002]; %LasPwrIn values
    case '04APR2018' 
        power_cal = [11.35 9.75 7.95 6.55 5.2 4.25 3.15 2.65];
        udt_cal = [0.2670 0.2500 0.2300 0.2100 0.1910 0.1730 0.1500 0.1360]; %LasPwrIn values
    case '10APR2018' 
        power_cal = [12.9 11.7 10.35 9.05 7.8 7.2 6.35 5.5 4.35 3.45];
        udt_cal = [0.2797 0.2690 0.2555 0.2410 0.2270 0.2200 0.2080 0.1950 0.1760 0.1580]; %LasPwrIn values
    case '14JUN2018' 
        power_cal = [11.5 10.75 10.5 10.15 9.55 8.8 8.2 7.4 6.7 5.95 5.3 5.1 4.55 4.0 3.5];
        udt_cal = [0.2595 0.2520 0.2500 0.2460 0.2390 0.2310 0.2235 0.2140 0.2040 0.1935 0.1835 0.1800 0.1710 0.1605 0.1520]; %LasPwrIn values        
    case '20JUN2018' 
        power_cal = [7.63 6.60 6.85 6.35 5.86 5.34 4.55 3.63 2.88 2.41 2.29 2.06 2.12];
        udt_cal = [0.2113 0.2010 0.2037 0.1983 0.1925 0.1857 0.1745 0.1589 0.1428 0.1306 0.1267 0.1186 0.1211]; %LasPwrIn values         
    case '26JUN2018' 
        power_cal = [5.95 7.54 8.31 8.1 9.1 9.61 7.75 6.41 5.66 5.27 4.17 3.69 3.33 3.10 3.20 2.76 2.26 1.92 1.59 1.31 1.05];
        udt_cal = [0.1933 0.2094 0.2161 0.2145 0.2225 0.2261 0.2125 0.1990 0.1900 0.1846 0.1680 0.1600 0.1530 0.1480 0.1502 0.1400 0.1256 0.1130 0.0985 0.0841 0.0690]; %LasPwrIn values         
    case '12SEPT2018' 
        power_cal = [9.97 8.93 8.08 7.21 6.3 5.34 4.46 3.67 3.02 2.53 2.12 1.76 1.49 0.85];
        udt_cal = [12.29 11.21 10.29 9.24 7.98 6.54 5.15 3.82 2.82 2.21 1.78 1.44 1.21 0.66]; %LasPwrIn values         
    case '14SEPT2018' 
        power_cal = [6.80 6.36 5.70 5.02 4.27 3.44 2.77 2.30 2.06 1.86 1.64 1.35 1.06];
        udt_cal = [4.40 4.22 3.90 3.58 3.18 2.73 2.30 1.96 1.76 1.60 1.42 1.19 0.94]; %LasPwrIn values  
    case '13OCT2018' 
        power_cal = [3.28 2.95 2.65 2.34 2.08 1.84 1.61 1.41 1.21 1.03 0.86];
        udt_cal = [3.65 3.19 2.78 2.39 2.07 1.79 1.54 1.34 1.15 0.983 0.821]; %LasPwrIn values 
    case '28OCT2018' 
        power_cal = [3.88 3.82 3.77 3.63 3.29 3.04 2.84 2.60 2.41 2.18 1.98 1.79 1.58 1.38 1.16 0.98 0.82 0.68 0.56 0.30 0.09];
        udt_cal = [3.48 3.43 3.37 3.27 2.92 2.67 2.46 2.21 2.01 1.80 1.61 1.44 1.26 1.11 0.93 0.79 0.66 0.55 0.45 0.24 0.08]; %LasPwrIn values 		
    otherwise
        error('Calibration date not recognized!')
end

%do fit and correct input udt to power
fitpar = polyfit(udt_cal,power_cal,3); %assume quadratic
power = polyval(fitpar,udt);

if plotme
    figure;plot(udt_cal,power_cal,'*');
    xlabel('UDT (V)')
    ylabel('Laser Power (mW)')
    title(caldate)
    linefit(udt_cal,power_cal,1,3);
end
