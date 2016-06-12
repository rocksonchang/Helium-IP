function h=IP_SaveFits(h)
x=h.x; 
dataMode=h.imgMode; imgMode=h.analysisMode;
resultArr=h.physicalDataArr; dresultArr=h.physicalDataArr; % processed data         
save([h.folderName '\IPData'],'x','resultArr','dresultArr','dataMode','imgMode');
IP_Export2Txt(h,1)
fprintf('Fits saved!\n');
