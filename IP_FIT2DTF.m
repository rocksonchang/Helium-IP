function [FitRes,FitResErr] = IP_FIT2DTF(x_data, y_data, z_data, startPoint)
%% Fit: 'untitled fit 1'.
[xData, yData, zData] = prepareSurfaceData( x_data, y_data, z_data );
% Set up fittype and options.
ft = fittype( 'C1+a1*(1-((x-x0)/sigmax).^2-((y-y0)/sigmay).^2).^(3/2).*heaviside(((((x-x0)/sigmax).^2+((y-y0)/sigmay).^2)<1 )-0.5)', 'independent', {'x', 'y'}, 'dependent', 'z' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [-Inf 0 1 1 0 0];
% opts.StartPoint = [C1_start A1_start sigmax_start sigmay_start x0_start y0_start];
opts.StartPoint = startPoint;
opts.Upper = [Inf Inf Inf Inf Inf Inf];
% BG ATF xTF yTF x0 y0

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );
[FitRes] = coeffvalues(fitresult);
% goodness of fit
%[FitDet] = coeffvalues(gof);
FitResConf=confint(fitresult);
FitResErr=FitResConf(2,:)-FitResConf(1,:);
