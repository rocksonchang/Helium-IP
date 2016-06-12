function h=IP_Calculate(hObject,h)
% --- Calculate into physical numbers
%% image mode
h.imgMode=get(h.popupmenuImagingMode,'val');
if h.imgMode==1        
        pixelSize =0.125*1e-3;  %% TOP camera - Latest measurements and modelling from OSLO by Tobias, June 5th.
        solid_angle=(0.9*5.08/55)^2/4/pi; %% TOP camera
        gamma=2*3.1415*1.6e6;  %% atomic linewidth of He*
        fluo_rate=gamma/2; % assume on res, fully saturating transition
        w0 = 1.58; %% MOT beam waist [cm]. w0=0.54 for probe beam
        eta = 1/78; %% calibration ADU/photon High Gain - eta=1/1410 for Low Gain
        tau=100e-6;
        ADU_atom=fluo_rate*eta*(tau)*solid_angle;
        normalisation =1/ADU_atom; %% atoms per ADU
elseif h.imgMode==2 %'2: Absorption imaging - SIDE' % User selects fluor abs imaging.            
        pixelSize = 17e-6; %% SIDE camera f=250mm, March 4, 2015: 17 um cal. by gravity, 13.5 um cal. by lattice
        sigmaAbs=3*(1083e-9)^2/2/pi; %% optical abs cross-section, sigma+ assumed, factor of 10/17 for unpolarized
        normalisation=pixelSize^2/sigmaAbs; %% atoms per OD
end
%% Convert into physical numbers...
varNameArr={'imgMode', 'analysisMode', 'BG', 'AG' 'xG' 'yG' 'ATF', 'xTF', 'yTF','x0','y0'};
for jj=1:length(varNameArr)
    eval([varNameArr{jj} '=h.FitRes(' num2str(jj) ');' ]);
    eval(['d' varNameArr{jj} '=h.FitResErr(' num2str(jj) ');' ]);
end;
switch get(h.popupmenuFitModel,'value')
    case 1
        NFitG = AG*2*pi*xG*yG*normalisation;
        NFitTF=0; xTF=0; yTF=0;
    case 2
        NFitTF = ATF*(2/5*pi)*xTF*yTF*normalisation;      
        NFitG=0; xG=0; yG=0;
    case 3        
        NFitTF = ATF*(2/5*pi)*xTF*yTF*normalisation;        
        NFitG  = AG*2*pi*xG*yG*normalisation;                
    case 4
        NFitTF = ATF*(2/5*pi)*xTF*yTF*normalisation;        
        NFitG  = AG*2*pi*xG*yG*normalisation;                
end;
NInt=sum(sum(h.img-BG))*normalisation;
% x=h.xlims(1):h.xlims(2); y=h.ylims(1):h.ylims(2); %% zoomed image size
% imgInt=h.img(max(1,floor(y)),max(1,floor(x)));
% NInt=sum(sum(imgInt-BG))*normalisation;

x0 = x0*pixelSize; y0 = y0*pixelSize;
xG = xG*pixelSize; yG = yG*pixelSize; 
xTF = xTF*pixelSize; yTF = yTF*pixelSize;
%% ... save ...
h.physicalDataArr(h.ii,:)=[NInt NFitG xG*1e3 yG*1e3 NFitTF xTF*1e3 yTF*1e3 x0*1e3 y0*1e3];
% h.physicalDataArr(h.ii,:)=[NInt NFitG x0*1e3 y0*1e3 xG*1e3 yG*1e3 ];
%% and display
if h.imgMode==1 %% fluoresence image from top
    physicalDataOut={NFitG/1e6, xG*1e3, yG*1e3, NFitTF/1e6, xTF*1e3, yTF*1e3, x0*1e3, y0*1e3 }';
    physicalUnitsOut={'  M', '  mm', '  mm', '  k', '  mm', '  mm', '  mm', '  mm'}';
elseif h.imgMode==2 %% absorption image from side
    physicalDataOut={NFitG/1e3, xG*1e6, yG*1e6, NFitTF/1e3, xTF*1e6, yTF*1e6, x0*1e3, y0*1e3 }';
    physicalUnitsOut={'  k', '  um', '  um', '  k', '  um', '  um', '  mm', '  mm'}';
end;
set(h.uitableCloudParams,'data',[physicalDataOut physicalUnitsOut]);
