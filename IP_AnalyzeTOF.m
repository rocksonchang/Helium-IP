function IP_AnalyzeTOF(h)

load([h.folderName '\IPData']);
%% Deplex and exclude data
range=eval(['[' get(h.edit_exclude,'string') ']']);
x(range)=[]; resultArr(range,:)=[];
%% de-plex data
%h.physicalDataArr(h.ii,:)=[NInt NFitG xG*1e3 yG*1e3 NFitTF xTF*1e3 yTF*1e3 x0*1e3 y0*1e3];
varArr={'NInt' 'NFit' 'widthX' 'widthY' 'NFitTF' 'widthXTF' 'widthYTF' 'centerX' 'centerY' };
for jj=1:length(varArr);
    eval([varArr{jj} '=squeeze(resultArr(:,' num2str(jj) '));' ]);
    eval(['d' varArr{jj} '=squeeze(dresultArr(:,' num2str(jj) '));' ]);
end;
x(length(NFit)+1:end)=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fit TOF x
result = FIT_TOF(x', widthX, [0.5,2], 0);
Est=coeffvalues(result); EstConf=confint(result);
fitResultX=sqrt(Est(1)^2*x.^2+Est(2)^2);
x0=Est(2); Tx=Est(1)^2*(4e-3/6.02e23)/1.38e-23;
dx0=(EstConf(2,2)-EstConf(1,2))/2;
dTx=Tx*(EstConf(2,1)-EstConf(1,1))/Est(1);
Nbar=mean(NFit); dNbar=std(NFit)/sqrt(length(NFit));

%% Fit TOF y
result = FIT_TOF(x', widthY, [0.5,2], 0);
Est=coeffvalues(result); EstConf=confint(result);
fitResultY=sqrt(Est(1)^2*x.^2+Est(2)^2);
y0=Est(2); Ty=Est(1)^2*(4e-3/6.02e23)/1.38e-23;
dy0=(EstConf(2,2)-EstConf(1,2))/2;
dTy=Ty*(EstConf(2,1)-EstConf(1,1))/Est(1);
Nbar=mean(NFit); dNbar=std(NFit)/sqrt(length(NFit));
%% fit x cloud center
result = FIT_Linear(x', centerX, [5,centerX(1),1], 0);
Est=coeffvalues(result); EstConf=confint(result);
fitResX=Est(1)*(x-Est(3))+Est(2); 
vX=Est(1); dvX=(EstConf(2,1)-EstConf(1,1))/2;
%% fit y cloud center
result = FIT_Linear(x', centerY, [5,centerY(1),1], 0);
Est=coeffvalues(result); EstConf=confint(result);
fitResY=Est(1)*(x-Est(3))+Est(2); 
vY=Est(1); dvY=(EstConf(2,1)-EstConf(1,1))/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot N
hf2=figure(2); set(hf2, 'Position', [100 70 700 800],'name','Analysis window');
subplot(311)
% plot(x, NFit, 'ro',x,NInt,'bx'); hold on; legend('NFit', 'NInt');
plot(x, NFit, 'ro'); hold on;
ylabel('N'); 
%% plot width x
subplot(323)
plot(x,widthX,'ro'); hold on;
plot(x,fitResultX,'b-'); 
text(0.3,(max(widthX)-min(widthX))*(1-0.10)+min(widthX),['Tx = ' num2str(Tx*1e6) '\pm ' num2str(dTx*1e6) ' uK']);
text(0.3,(max(widthX)-min(widthX))*(1-0.25)+min(widthX),['x0 = ' num2str(x0) '\pm ' num2str(dx0) ' mm']);
text(0.3,(max(widthX)-min(widthX))*(1-0.40)+min(widthX),['N = ' num2str(Nbar/1e6) '\pm ' num2str(dNbar/1e6) ' M']);ylabel('X width [mm]'); 
%% plot width y
subplot(325)
plot(x,widthY,'ro'); hold on;
plot(x,fitResultY,'b-'); 
text(0.3,(max(widthY)-min(widthY))*(1-0.10)+min(widthY),['Ty = ' num2str(Ty*1e6) '\pm ' num2str(dTy*1e6) ' uK']);
text(0.3,(max(widthY)-min(widthY))*(1-0.25)+min(widthY),['y0 = ' num2str(y0) '\pm ' num2str(dy0) ' mm']);
text(0.3,(max(widthY)-min(widthY))*(1-0.40)+min(widthY),['N = ' num2str(Nbar/1e6) '\pm ' num2str(dNbar/1e6) ' M']);
ylabel('Y width [mm]'); 
%% plot cloud position x
subplot(324); 
plot(x,centerX,'ro'); hold on;
plot(x,fitResX,'b--');
text(1,(max(centerX)-min(centerX))*(1.1)+min(centerX),['v_x = ' num2str(vX,'%05.3f') ' mm/ms']);
ylabel('x center [mm]'); 
%% plot cloud position y
subplot(326); 
plot(x,centerY,'ro'); hold on;
plot(x,fitResY,'b--');
ylabel('y center [mm]'); 
text(1,(max(centerY)-min(centerY))*(1.1)+min(centerY),['v_y = ' num2str(vY,'%05.3f') ' mm/ms']);
%% title
fullPath=h.folderName;
slashList=findstr(fullPath,'\');
folderStr=fullPath(slashList(end)+1:length(fullPath));
subplot(311); title(folderStr); 
x1=0; x2=max(x);
xlabel('TOF [ms]'); xlim([x1,x2]);
for ii=3:6
    subplot(3,2,ii); 
    xlabel('TOF [ms]'); xlim([x1,x2]);
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
saveas(hf2,[h.folderName '\IP_TOF']);
TOFparamsX=[Tx dTx x0 dx0 Nbar dNbar widthX(1) vX dvX];
TOFparamsY=[Ty dTy y0 dy0 Nbar dNbar widthY(1) vY dvY];
save ([h.folderName '\IP_TOFparams'], 'TOFparamsX', 'TOFparamsY', 'range');
