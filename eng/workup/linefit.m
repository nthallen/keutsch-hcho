function [fitpar,fitunc,r2] = linefit(x,y,plotme,order)
%function [fitpar,yfit] = linefit(x,y,plotme)
%simple line fit and optional plotting of said line.
%INPUTS:
%x,y: x and y vectors.
%plotme: if you want the line plotted on on the current figure, make this 1; otherwise 0.
%order: optional input to specify polynomial order. default is 1
%OUTPUTS:
%fitpar: vector of polynomial coefficients
%fitunc: 1-sigma uncerertainty in coefficients
%r2: correlation coefficient
%080104 GMW
%
%Works better now. 110526 GMW

if nargin<4
    order = 1;
end

%do the fit
i=find(~isnan(x+y));
[fitpar,s] = polyfit(x(i),y(i),order);
yfit = polyval(fitpar,x);
fitunc = sqrt(diag(inv(s.R)*inv(s.R')).*s.normr.^2./s.df); %from polyfit documentation

%correlation coefficient
r = corrcoef(x,y,'rows','pairwise');
r2 = r(1,2).^2;

%plot line and print equation
if plotme
    hold on
    [xsort,i] = sort(x); %sort values
    yfit = yfit(i);
    plot(xsort,yfit,'k-')
    
    xlimits = [nanmin(x) nanmax(x)];
    ylimits = ylim;
    if order==1
        text(xlimits(1,2),ylimits(1,1),['y = (' num2str(fitpar(1),2) '\pm ' num2str(fitunc(1),2) ')*x + (' ...
            num2str(fitpar(2),2) '\pm' num2str(fitunc(1),2) '), r^2 = ' num2str(r2,2)],...
            'fontsize',14,'horizontalalignment','right','verticalalignment','bottom')
    elseif order==2
        text(xlimits(1,2),ylimits(1,1),['y = ' num2str(fitpar(1),2) '*x^2 + ' num2str(fitpar(2),2) '*x + ' num2str(fitpar(3),2) ', r^2 = ' num2str(r2,2)],...
            'fontsize',14,'horizontalalignment','right','verticalalignment','bottom')
    elseif order==3
        text(xlimits(1,2),ylimits(1,1),['y = ' num2str(fitpar(1),2) '*x^3 + ' num2str(fitpar(2),2) '*x^2 + ' num2str(fitpar(3),2) '*x + ' num2str(fitpar(4),2) ', r^2 = ' num2str(r2,2)],...
            'fontsize',14,'horizontalalignment','right','verticalalignment','bottom')
    end
end

