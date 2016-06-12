function [Hprof,Vprof]=IP_GenerateProfiles(img,coordinates,width)
%% inputs:
%% ii - image index
%% imgMode - 1 - fluoresence image from top camera
%%         - 2 - absorption image from side camera
%% output:
%% img2 - 2D array containing signal
%% img sum
rge1=1:size(img,1); rge2=1:size(img,2); %y, x
%% generate H profile
% [C,I]=max(max(img2(rge1,rge2)'));
I=round(coordinates(2));
% Hprof=squeeze(img(I,:));
% Hprof=squeeze(sum(img(I+(-width:width),:)))/(2*width+1);
Hprof=squeeze(sum(img(I+(-width:width),:),1))/(2*width+1);
% length(Hprof)

%% generate V profile
% [C,I]=max(max(img2(rge1,rge2)));
I=round(coordinates(1));
% Vprof=squeeze(img(:,I));
Vprof=squeeze(sum(img(:,I+(-width:width)),2))/(2*width+1);