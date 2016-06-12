function IP_AnalyzeResScan(h)

load([h.folderName '\IPData']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
Vc=x;
x=Vc*15.31*2; % Det=(Vc*15.31+175)*2-170*2;    AOM frequency calibration
x(length(NFit)+1:end)=[];

fCalib=(x(2)-x(1))/(Vc(2)-Vc(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fit to Lorenztian
result = FIT_Lorentzian(x', NFit, [max(NFit),0, 5], 0);
Est=coeffvalues(result); EstConf=confint(result);
xx=linspace(x(1),x(end),1000);
fitResult=Est(1)./(1+((xx-Est(2))/Est(3)).^2);
dA=(EstConf(2,1)-EstConf(1,1))/2;
dB=(EstConf(2,2)-EstConf(1,2))/2;
dC=(EstConf(2,3)-EstConf(1,3))/2;
fitStrA = ['Height = ' num2str(Est(1),'%.0f') ' \pm ' num2str(dA)];
fitStrB = ['Center = ' num2str(Est(2),'%.2f') ' \pm ' num2str(dB,'%.2f') ' MHz = ' num2str(Est(2)/fCalib,'%.3f') ' V'];
fitStrC = ['HWHM = ' num2str(Est(3),'%.2f') ' \pm ' num2str(dC,'%.2f') ' MHz'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
hf2=figure(2); set(hf2, 'Position', [100 70 800 400],'name','Analysis window');
plot(x, NFit, 'ro','markerfacecolor','r'); hold on;
xlabel('Detuning [MHz]'); ylabel('N'); xlim([x(1), x(end)]);
plot(xx,fitResult,'b-'); grid on;
text(x(2),max(NFit)*0.9,fitStrA,'fontsize',14);
text(x(2),max(NFit)*0.8,fitStrB,'fontsize',14);
text(x(2),max(NFit)*0.7,fitStrC,'fontsize',14);
% legend('N','N scaled','scaling');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
saveas(hf2,[h.folderName '\IP_ResScan']);

