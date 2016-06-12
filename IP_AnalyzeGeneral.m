function IP_AnalyzeGeneral(h)

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

hf2=figure(2); set(hf2, 'Position', [100 70 400 800],'name','Analysis window');
% subplot(311); plot(x,NFit, 'ro-',x,NInt,'bo-'); ylabel('N');
subplot(311); plot(x,NFit, 'ro-'); ylabel('N'); 


subplot(312); plot(x,widthX,'ro-',x,widthY,'bo-'); ylabel('width [mm]');
subplot(313); plot(x,centerX,'ro-',x,centerY,'bo-'); ylabel('Position [mm]'); 
x1=min(x); x2=max(x);
for ii=1:3
    subplot(3,1,ii); grid on;
    xlabel('X'); xlim([x1,x2]);
end; 
%% title
fullPath=h.folderName;
slashList=findstr(fullPath,'\');
folderStr=fullPath(slashList(end)+1:length(fullPath));
subplot(311); title(folderStr); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
saveas(hf2,[h.folderName '\IP_General']);