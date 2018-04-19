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
    otherwise
        error('Calibration date not recognized!')
end

%do fit and correct input udt to power
fitpar = polyfit(udt_cal,power_cal,2); %assume quadratic
power = polyval(fitpar,udt);

if plotme
    figure;plot(udt_cal,power_cal,'*');
    xlabel('UDT (V)')
    ylabel('Laser Power (mW)')
    title(caldate)
    linefit(udt_cal,power_cal,1,2);
end

