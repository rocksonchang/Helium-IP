function [FitRes,FitResErr]  = IP_FIT2DBimodal2(x, y, img2,startPoint)
% (x_data, y_data, z_data, C1_start, A1_start, sigmax_start, sigmay_start,x0_start,y0_start, b1_start, sigmax2_start, sigmay2_start)                                   
%% Fit: 'untitled fit 1'.
[xInput, yInput, zOutput] = prepareSurfaceData( x, y, img2 );

% Set up fittype and options.
ft = fittype( 'C1+a1*max((1-((x-x0)/sigmax).^2-((y-y0)/sigmay).^2),0).^(3/2)+(b1*exp(-(x-x0).^2/(2*sigmax2^2)-(y-y0).^2/(2*sigmay2^2)))', 'indep', {'x', 'y'}, 'depend', 'z' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [0 0 0 1 1 1 1 0 0];
opts.StartPoint = startPoint;
%  C1 a1 b1 sigmax sigmax2 sigmay sigmay2 x0 y0;
%  BG ATF AG xTF xG yTF yG x0 y0
opts.Upper = [4000 4000 4000 500 500 500 500 1000 1000];
opts.TolX=5e-4;

% Fit model to data.
[fitresult, gof] = fit( [xInput, yInput], zOutput, ft, opts );


% Fit model to data.
% [fitresult, gof] = fit( [xData, yData], zData, ft, opts );
[FitRes] = coeffvalues(fitresult);
% goodness of fit
%[FitDet] = coeffvalues(gof);
FitResConf=confint(fitresult);
FitResErr=FitResConf(2,:)-FitResConf(1,:);

% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, [xInput, yInput], zOutput );
% legend( h, 'untitled fit 1', 'img2 vs. x, y', 'Location', 'NorthEast' );
% % Label axes
% xlabel( 'x' );
% ylabel( 'y' );
% zlabel( 'img2' );
% grid on
% view( 48.5, -50 );


