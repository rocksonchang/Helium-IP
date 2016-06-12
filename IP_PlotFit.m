function h=IP_PlotFit(hObject,h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\
% --- perform fits
%% unpack fit results and uncertainties
h.FitRes=h.FitResArr(h.ii,:); h.FitResErr=h.FitResErrArr(h.ii,:);
varNameArr={'imgMode', 'analysisMode', 'BG', 'AG' 'xG' 'yG' 'ATF', 'xTF', 'yTF','x0','y0','fitted'};
for jj=1:length(varNameArr)
    eval([varNameArr{jj} '=h.FitRes(' num2str(jj) ');' ]);
    eval(['d' varNameArr{jj} '=h.FitResErr(' num2str(jj) ');' ]);
end;
if fitted==1 % plot only if fit exists
    %% prepare plots
    [y1,x1]=size(h.img); x=1:x1; y=1:y1; %% full image size
    y1=h.coordinates(2);  x1=h.coordinates(1);
    if get(h.popupmenuFitModel,'value')==1
        f1D_x = BG + AG*exp(-(x-x0).^2/(2*xG^2))*exp(-(y1-y0).^2/(2*yG^2));
        f1D_y = BG + AG*exp(-(x1-x0).^2/(2*xG^2))*exp(-(y-y0).^2/(2*yG^2));
    elseif get(h.popupmenuFitModel,'value')==2
        f1D_x = BG + ATF*(1-((x-x0)/xTF).^2-((y1-y0)/yTF).^2).^(3/2).*heaviside(((((x-x0)/xTF).^2+((y1-y0)/yTF).^2)<1 )-0.5);
        f1D_y = BG + ATF*(1-((x1-x0)/xTF).^2-((y-y0)/yTF).^2).^(3/2).*heaviside(((((x1-x0)/xTF).^2+((y-y0)/yTF).^2)<1 )-0.5);
    elseif get(h.popupmenuFitModel,'value')>=3
        f1D_x = BG+ATF*max((1-((x-x0)/xTF).^2-((y1-y0)/yTF).^2),0).^(3/2)+(AG*exp(-(x-x0).^2/(2*xG^2)-(y1-y0).^2/(2*yG^2)));
        f1D_y = BG+ATF*max((1-((x1-x0)/xTF).^2-((y-y0)/yTF).^2),0).^(3/2)+(AG*exp(-(x1-x0).^2/(2*xG^2)-(y-y0).^2/(2*yG^2)));    
    end;
    axes(h.axesHprof); hold on; %set(get(gca,'Children'),'marker','o','linestyle','none','color','r','markerfacecolor','r','markersize',4);
    plot(f1D_x,'b-','linewidth',2); hold off;
    axes(h.axesVprof); hold on; %set(get(gca,'Children'),'marker','o','linestyle','none','color','r','markerfacecolor','r','markersize',4);
    plot(f1D_y,'b-','linewidth',2); hold off;
end;
