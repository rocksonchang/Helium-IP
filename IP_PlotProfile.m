function h=IP_PlotProfile(hObject,h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- plot profile
%% generate 1D slice
width=str2double(get(h.editProfWidth,'string'));
[h.Hprof,h.Vprof]=IP_GenerateProfiles(h.img,h.coordinates,width);
%% H prof
axes(h.axesHprof); 
if get(h.checkboxProfScale,'value')==0
    ProfYLim1=str2double(get(h.editProfYLim1,'string'));
    ProfYLim2=str2double(get(h.editProfYLim2,'string'));
else
    ProfYLim1=min(h.Hprof);
    ProfYLim2=max(h.Hprof);
end;
plot(h.Hprof,'r-'); grid on;
xlim([h.xlims(1),h.xlims(2)]);
ylim([ProfYLim1,ProfYLim2]);
%% V prof
axes(h.axesVprof); 
if get(h.checkboxProfScale,'value')==0
    ProfYLim1=str2double(get(h.editProfYLim1,'string'));
    ProfYLim2=str2double(get(h.editProfYLim2,'string'));
else
    ProfYLim1=min(h.Vprof);
    ProfYLim2=max(h.Vprof);
end;
plot(h.Vprof,'r-'); grid on;
xlim([h.ylims(1),h.ylims(2)]);
ylim([ProfYLim1,ProfYLim2]);
