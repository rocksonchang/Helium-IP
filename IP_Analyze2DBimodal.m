function [FitResFinal,FitResErrFinal]  = IP_Analyze2DBimodal(h)
load([h.folderName '\IPData']);
%% Deplex and exclude data
range=eval(['[' get(h.edit_exclude,'string') ']']);
x(range)=[]; resultArr(range,:)=[];
%% de-plex data
% varArr={'NInt' 'NFit' 'centerX' 'centerY' 'widthX' 'widthY'};
%h.physicalDataArr(h.ii,:)=[NInt NFitG xG*1e3 yG*1e3 NFitTF xTF*1e3 yTF*1e3 x0*1e3 y0*1e3];
varArr={'NInt' 'NFit' 'widthX' 'widthY' 'NFitTF' 'widthXTF' 'widthYTF' 'centerX' 'centerY' };
for jj=1:length(varArr);
    eval([varArr{jj} '=squeeze(resultArr(:,' num2str(jj) '));' ]);
    eval(['d' varArr{jj} '=squeeze(dresultArr(:,' num2str(jj) '));' ]);
end;
x(length(NFit)+1:end)=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hf2=figure(2); set(hf2, 'Position', [100 70 800 600],'name','Analysis window');

x1=min(x); x2=max(x);
subplot(221); plot(x,NFit, 'ro-','markerfacecolor','r'); hold on;
plot(x,NFitTF, 'bo-','markerfacecolor','b'); 
xlabel('X'); ylabel('Atom number, N'); xlim([x1,x2]);
legend('N Thermal','N BEC','location','northeast');

f=NFitTF./(NFit+NFitTF);
subplot(222); plot(x,f, 'ro-','markerfacecolor','r'); hold on;
xlabel('X'); ylabel('BEC Fraction'); xlim([x1,x2]);

subplot(223); plot(x,widthX,'ro-','markerfacecolor','r'); hold on;
plot(x,widthY,'bo-','markerfacecolor','b'); 
xlabel('X'); ylabel('Thermal cloud rms width [cm]'); xlim([x1,x2]);
legend('x width','y width','location','northeast');

subplot(224); plot(x,widthXTF,'ro-','markerfacecolor','r'); hold on;
plot(x,widthYTF,'bo-','markerfacecolor','b'); 
xlabel('X'); ylabel('BEC TF width [cm]'); xlim([x1,x2]);
legend('x width','y width','location','northeast');

%% title
fullPath=h.folderName;
slashList=findstr(fullPath,'\');
folderStr=fullPath(slashList(end)+1:length(fullPath));
subplot(221); title(folderStr); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
saveas(hf2,[h.folderName '\IP_Bimodal']);

