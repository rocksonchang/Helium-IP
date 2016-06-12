function IP_Export2Txt(h,exMode)

if exMode==1 
    %% export fits 
    varNameArr={'imgMode', 'analysisMode', 'BG', 'AG' 'xG' 'yG' 'ATF', 'xTF', 'yTF','x0','y0'};
    for jj=1:length(varNameArr)
        eval([varNameArr{jj} '=h.FitRes(' num2str(jj) ');' ]);
        eval(['d' varNameArr{jj} '=h.FitResErr(' num2str(jj) ');' ]);
    end;    
    fnameTXT='IP_Fits';
    fid = fopen([h.folderName '\' fnameTXT '.txt'], 'w');
    fprintf(fid, ['imgMode = ' num2str(imgMode,'%01.0f') ', analysisMode = ' num2str(analysisMode,'%01.0f') '\n']);
    labels={'x', 'BG', 'AG' 'xG' 'yG' 'ATF', 'xTF', 'yTF','x0','y0'};
    fprintf(fid, '%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t\n', labels{:});
    fclose(fid);
    A=h.x';
    B=h.FitResArr(1:length(h.x),:);        
    data=[A B];
    save([h.folderName '\' fnameTXT '.txt'],'data','-ascii','-tabs','-append');
    
    %% physical quantities    
    %[NInt NFitG xG*1e3 yG*1e3 NFitTF xTF*1e3 yTF*1e3 x0*1e3 y0*1e3]
    labels={'x', 'NInt', 'NFitG', 'xG [m]', 'yG [m]', 'NFitTF', 'xTF [m]', 'yTF [m]', 'x0 [m]','y0 [m]'};
    fnameTXT='IP_PhysicalData';
    fid = fopen([h.folderName '\' fnameTXT '.txt'], 'w');
    fprintf(fid, ['imgMode = ' num2str(imgMode,'%01.0f') ', analysisMode = ' num2str(analysisMode,'%01.0f') '\n']);    
    fprintf(fid, '%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t\n', labels{:});
    fclose(fid);
    A=h.x';
    B=h.physicalDataArr(1:length(h.x),:);        
    data=[A B];    
    save([h.folderName '\' fnameTXT '.txt'],'data','-ascii','-tabs','-append');   
     
end;