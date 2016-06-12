function img2=IP_GenerateImage(ii,folderName,imgMode,N,RefScale)
%% inputs:
%% ii - image index
%% imgMode - 1 - fluoresence image from top camera
%%         - 2 - absorption image from side camera
%% output:
%% img2 - 2D array containing signal
if imgMode==2 %% absorption image with dark
    Nseq=3; imagenum=(ii-1)*Nseq;
    %% load image files
    filename = [folderName '\' sprintf('im_%d.png',imagenum)]; img = double(imread(filename));
    filename_bg = [folderName '\' sprintf('im_%d.png',imagenum+1)]; img_bg = double(imread(filename_bg));
    filenameDark = [folderName '\' sprintf('im_%d.png',imagenum+2)];   img_dk = imread(filenameDark);
    %% scale reference image manually
    img_bg=img_bg*(1+RefScale/100);
    %% generate signal
    imgTemp1=(double(img(:,:,1))-double(img_dk(:,:,1)));
    imgTemp2=(1.003*double(img_bg(:,:,1))-double(img_dk(:,:,1)));
    img2=-log(imgTemp1./imgTemp2);
    %% filter bad values
    img2(isinf(img2))=0; img2(imag(img2)~=0)=0;
else %% fluoresence imaging
    Nseq=2; imagenum=(ii-1)*Nseq;
    %% load image files
    filename = [folderName '\' sprintf('im_%d.png',imagenum)]; img = double(imread(filename));
    filename_bg = [folderName '\' sprintf('im_%d.png',imagenum+1)]; img_bg = double(imread(filename_bg));    
    %% generate signal
    img2=img-img_bg; 
end;
%% smoothing
% img2 = IP_Smooth2a(img2,N,N);
if N>0
    img2 = IP_2DConv(img2,N,N);
end;


