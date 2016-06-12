function varargout = HeliumIP(varargin)
% HELIUMIP MATLAB code for HeliumIP.fig
%      HELIUMIP, by itself, creates a new HELIUMIP or raises the existing
%      singleton*.
%
%      H = HELIUMIP returns the handle to a new HELIUMIP or the handle to
%      the existing singleton*.
%
%      HELIUMIP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HELIUMIP.M with the given input arguments.
%
%      HELIUMIP('Property','Value',...) creates a new HELIUMIP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HeliumIP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HeliumIP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HeliumIP

% Last Modified by GUIDE v2.5 12-Jun-2016 14:55:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @HeliumIP_OpeningFcn, ...
    'gui_OutputFcn',  @HeliumIP_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Internal GUI functions -------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Initialize -------------------------------------------------------- %
% --- Executes just before HeliumIP is made visible --------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function HeliumIP_OpeningFcn(hObject, eventdata, h, varargin)
clc; fprintf('Initializing...');
h.ii = uint16(1);                      
%% init modes 
h.analysisMode = 1;
h.imgMode = 2;
set(h.popupmenuImagingMode, 'val', h.imgMode);
set(h.popupmenu_AnalysisMode, 'val', h.analysisMode);
%% init pretty
%h.folderName='D:\Research\Projects\Helium\DATA\2015\2015 02 17 - BEC\03 ODT\18 Balanced trap evaporation - ODT1 18W ODT2 08W\16 ODT1 hold at 1W - grad 3.0V - TOF 4 ms - hold time 0 up by 10 ms';
h.folderName='Data\01 BEC Transition';
ind=strfind(h.folderName,'\'); h.rootFolderName=h.folderName(1:ind(end));
h.coordinates=[137,76];
set(h.textProfCoords,'String',['(' num2str(h.coordinates(1),'%3.0f') ', ' num2str(h.coordinates(2),'%3.0f') ')' ]);
set(h.listboxFileNames, 'String', '');
%% init initial fit guess params 
h.fitData=zeros(6,2); h.fitData(:,1)=[0.2 10 10 1 5 5];
set(h.uitableFit,'data',h.fitData);
h.FitResArr=zeros(100,12); h.FitResErrArr=zeros(100,12);
set(h.checkboxFit,'value',0);
%% init image and profile scaling
set(h.edit_RefScale,'string','0');
h.img=zeros(256,320);
axes(h.axesImage); 
h.imgHandle=image(h.img);
h.xlims=[1,320]; h.ylims=[1,256];
h.NSmooth=str2double(get(h.editNSmooth,'string'));
set(h.editImageScale,'string','100');  % image scale value
set(h.checkboxImageScale,'value',1); % image scale toggle
set(h.editProfYLim1,'string','-0.1');  % profile scale value
set(h.editProfYLim2,'string','1');  % profile scale value
set(h.checkboxProfScale,'value',1); % profile scale toggle
set(h.checkboxAutoRefresh,'value',0); % auto-refresh toggle
%% init x label programming
set(h.popupmenu_xChoice,'val',1);
set(h.editxV0,'string','1');
set(h.editxdV,'string','1');
set(h.edit_xEquation,'string','1 1 2 3 5 8 13');
%% init notes
set(h.editNotes,'string','Notes');
h=IP_ReadNotes(h); 
%% timer object to query files
h.NFiles=0;
h.timer = timer(...
    'ExecutionMode', 'fixedRate', ...   % Run timer repeatedly
    'Period', 1, ...                % Initial period is 1 sec.
    'TimerFcn', {@IP_TimerAutoCheck,hObject}); % Specify callback
%% system
h.output = hObject;
guidata(hObject, h);
fprintf('Done! \n');
%% call refresh
h=IP_Refresh(hObject,eventdata,h,varargin);
% --- Outputs from this function are returned to the command line.
function varargout = HeliumIP_OutputFcn(hObject, eventdata, h)
varargout{1} = h.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- timer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function IP_TimerAutoCheck(hObject,eventdata,h)
h = guidata(h);
NFilesInit=h.NFiles;
h=IP_QueryFiles(hObject,eventdata,h);
if h.NFiles~=NFilesInit
    h=IP_Refresh(hObject,eventdata,h);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Refresh ----------------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h=IP_Refresh(hObject,eventdata,h,varargin)
%% Query files
h=IP_QueryFiles(hObject,eventdata,h,varargin);
%% generate image labels
switch get(h.popupmenu_xChoice,'val')
    case 1 % auto generate
        h.V0=str2double(get(h.editxV0,'string'));
        h.dV=str2double(get(h.editxdV,'string'));
        h.x=((1:h.NImgs)-1)*h.dV+h.V0;        
    case 2 % user generate
        temp=eval(['[' get(h.edit_xEquation,'string') ']']);
        temp=temp(1:(min(length(h.x),length(temp))));
        h.x(1:length(temp))=temp;
end
set(h.listboxx, 'String', h.x);
%% Highlight listboxes
set(h.listboxx,'value',h.ii);
% set(h.listboxFileNames,'value',(1:(h.imgMode+1))+(h.imgMode+1)*(h.ii-1));
set(h.listboxFileNames,'value',h.ii);
%% Generate images, plot, and fit
h=IP_PlotImage(hObject,eventdata,h,varargin);
h=IP_PlotProfile(hObject,h);
h=IP_Fit(hObject,h);
h=IP_PlotFit(hObject,h);
h=IP_Calculate(hObject,h); %% calculate physical quantities
%% Store handles
guidata(hObject, h);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Query Files-------------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h=IP_QueryFiles(hObject,eventdata,h,varargin)
%% folder selection stuff
ind=strfind(h.folderName,'\');
h.rootFolderName=h.folderName(1:ind(end));
%% Query folders in directory
d = dir(h.rootFolderName);
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
set(h.listbox_directory,'string',nameFolds);
for jj=1:length(nameFolds)    
    if isempty(strfind(h.folderName,nameFolds{jj}))
    else
        set(h.listbox_directory,'val',jj);
    end;
end;
%% non png files in directory
[Files,Bytes,Names] = FN_DIRR(h.folderName,'name');
kk=0;Names2=[];
for jj=1:length(Names)
    temp=Names{jj};
    ind=strfind(temp,'\')    ;
    Names{jj}=temp((ind(end)+1):end);    
    if isempty(strfind(Names{jj},'.png'))
        kk=kk+1;
        Names2{kk}=temp((ind(end)+1):end);  
    end;
end;
set(h.listbox_directoryFiles,'string',Names2);
%% Query files in folder
[Files,Bytes,Names] = FN_DIRR(h.folderName,'\.png\>','name');
h.NFiles=length(Names); h.NImgs=floor(h.NFiles/(h.imgMode+1));
%% Generate list of images and print
h.fNames=[];
% for jj=1:h.NFiles
for jj=1:h.NImgs
%     h.fNames{jj}=['im_' num2str(jj,'%1.0f') '.png'];
    h.fNames{jj}=[num2str(jj,'%1.0f')];
end;
set(h.listboxFileNames, 'String', h.fNames);
set(h.textFolderName,'String',h.folderName);

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- plot image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h=IP_PlotImage(hObject,eventdata,h,varargin)
refScale=str2num(get(h.edit_RefScale,'string'));
h.img=IP_GenerateImage(h.ii,h.folderName,h.imgMode,h.NSmooth,refScale);
%% generate signal, scale, plot
if get(h.checkboxImageScale,'value')==1
    scale_img  = 50/max(max(h.img));
else
    scale_img = str2double(get(h.editImageScale,'string'));
end;
axes(h.axesImage);
h.xlims=(get(h.axesImage,'xlim')); h.ylims=(get(h.axesImage,'ylim')); % get current image size 
h.imgHandle=image(h.img*scale_img);
%h.imgHandle=image(h.img/max(max(h.img))*scale_img);
xlim([h.xlims(1),h.xlims(2)]); ylim([h.ylims(1),h.ylims(2)]);     % reset current image size
set(h.imgHandle,'ButtonDownFcn',{@ImageClickCallback,hObject,h}); % creates image click callback
%% draw cross-hair
line([h.coordinates(1),h.coordinates(1)],[1,500],'color',[1,1,1],'HitTest','off');
line([1,500],[h.coordinates(2),h.coordinates(2)],'color',[1,1,1],'HitTest','off');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- USER INPUTS --------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- click on image callback
function ImageClickCallback(hObjectLocal,eventdata,varargin)
axesHandle  = get(hObjectLocal,'Parent');
hObject=varargin{1}; h=varargin{2};
temp = get(axesHandle,'CurrentPoint');
h.coordinates = round(temp(1,1:2));
set(h.textProfCoords,'String',['(' num2str(h.coordinates(1),'%3.0f') ', ' num2str(h.coordinates(2),'%3.0f') ')' ]);
h=IP_Refresh(hObject,eventdata,h);
% --- keyboard input callback
function figure1_WindowKeyPressFcn(hObject, eventdata, h)
switch eventdata.Key
    case 'leftarrow'
        h.ii=h.ii-1;
        if h.ii<1
            h.ii=h.NImgs;
        end;        
        h=IP_Refresh(hObject,eventdata,h);
    case 'rightarrow'
        h.ii=h.ii+1;
        if h.ii>h.NImgs
            h.ii=1;
        end;
        h=IP_Refresh(hObject,eventdata,h);
    case 'escape'
        close all;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- GUI Objects --------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- toolbar
function uitoggletool1_ClickedCallback(hObject, eventdata, h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- checkbox do fit
function checkboxFit_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
guidata(hObject, h);
% --- popupmenu fit model
function popupmenuFitModel_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
guidata(hObject, h);
function popupmenuFitModel_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes when entered data in editable cell(s) in uitableFit.
function uitableFit_CellEditCallback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);  
% --- Executes on button press in checkboxFitAutoGuess.
function checkboxFitAutoGuess_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Image filename listbox
function listboxFileNames_Callback(hObject, eventdata, h)
h.ii=round(get(h.listboxFileNames,'value'));
h=IP_Refresh(hObject,eventdata,h);

function listboxFileNames_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Imaging mode popupmenu
function popupmenuImagingMode_Callback(hObject, eventdata, h)
h.imgMode=get(h.popupmenuImagingMode,'val');
h=IP_Refresh(hObject,eventdata,h);
function popupmenuImagingMode_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- push button to initiate fitter
function pushbutton_RunFitter_Callback(hObject, eventdata, h)
fprintf('Fitting... \n');
h.FitResArr=zeros(100,12); h.FitResErrArr=zeros(100,12);
h.physicalDataArr=[]; %h.h.physicalDataErrArr=[];
set(h.checkboxFit,'value',1);
for jj=1:h.NImgs
    h.ii=jj;    
    h=IP_Refresh(hObject,eventdata,h);  
end;
set(h.checkboxFit,'value',0);
fprintf('Done! \n');
h=IP_SaveFits(h);
h=IP_Refresh(hObject,eventdata,h);
% --- Analysis mode popupmenu
function popupmenu_AnalysisMode_Callback(hObject, eventdata, h)
h.analysisMode=get(h.popupmenu_AnalysisMode,'val');
if h.analysisMode==4 % 1-2 res scan
    set(h.editxV0,'string',num2str(-0.30));
    set(h.editxdV,'string',num2str(0.025));
elseif h.analysisMode==3 % TOF
    if h.imgMode==1
        set(h.editxV0,'string',num2str(0));
        set(h.editxdV,'string',num2str(2));
    elseif h.imgMode==2
        set(h.editxV0,'string',num2str(0));
        set(h.editxdV,'string',num2str(0.2));
    end;
end;
h=IP_Refresh(hObject,eventdata,h);
function popupmenu_AnalysisMode_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in pushbutton_RunAnalysis.
function pushbutton_RunAnalysis_Callback(hObject, eventdata, h)
close(findobj('type','figure','name','Analysis window'));
switch h.analysisMode
    case 1
        % view image, do nothing
    case 2        
        fprintf('Run General Analysis \n');
        IP_AnalyzeGeneral(h);  
    case 3        
        fprintf('Run TOF Analysis \n');
        IP_AnalyzeTOF(h);        
    case 4
        fprintf('Run 1-2 Resonance scan \n');
        IP_AnalyzeResScan(h);        
    case 5
        fprintf('Run Bimodal Analysis \n');
        IP_Analyze2DBimodal(h);        
end;        
h=IP_Refresh(hObject,eventdata,h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Image scaling checkbox
function checkboxImageScale_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
function editImageScale_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
function editImageScale_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- edit N smooth
function editNSmooth_Callback(hObject, eventdata, h)
h.NSmooth=str2double(get(h.editNSmooth,'string'));
h=IP_Refresh(hObject,eventdata,h);
guidata(hObject, h);
function editNSmooth_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Profile scaling YLim1
function editProfYLim1_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
guidata(hObject, h);
function editProfYLim1_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Profile scaling YLim2
function editProfYLim2_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
guidata(hObject, h);
function editProfYLim2_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Profile scaling checkbox
function checkboxProfScale_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Notes editbox
function editNotes_Callback(hObject, eventdata, h)
function editNotes_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Notes pushbutton for export
function pushbuttonNotes_Callback(hObject, eventdata, h)
fname=[h.folderName '\Notes.txt'];
fid = fopen(fname, 'wt');
s = get(h.editNotes,'string'); %h_edit is the handle to the edit box
[row, column] = size(s);
for jj = 1:row
    fprintf(fid,[char(s(jj,:)) '\n']); %evaluate each line as in MATLAB command prompt
end
fclose(fid);
guidata(hObject, h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- pushbutton Save fits
function pushbuttonSaveFits_Callback(hObject, eventdata, h)
h=IP_SaveFits(h);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- x listbox
function listboxx_Callback(hObject, eventdata, h)
h.ii=round(get(h.listboxx,'value'));
h=IP_Refresh(hObject,eventdata,h);
guidata(hObject, h);
function listboxx_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- V0 editbox
function editxV0_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
guidata(hObject, h);
function editxV0_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- dV editbox
function editxdV_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
guidata(hObject, h);
function editxdV_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- x equation editbox
function edit_xEquation_Callback(hObject, eventdata, h)
function edit_xEquation_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- popupmenu x program choice
function popupmenu_xChoice_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
function popupmenu_xChoice_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- textbox working folder
function textFolderName_Callback(hObject, eventdata, h)
h.folderName=get(h.textFolderName,'string');
h=IP_Refresh(hObject,eventdata,h);
% --- pushbutton get folder
function pushbuttonFolderSelect_Callback(hObject, eventdata, h)
temp=uigetdir(h.folderName,'Choose Image Directory');
if temp==0
    % cancelled, do nothing
else
    h.folderName = temp;
    h.ii=1;
    h=IP_ReadNotes(h);
    h=IP_Refresh(hObject,eventdata,h);
    guidata(hObject, h);
end;
function pushbuttonFolderSelect_ButtonDownFcn(hObject, eventdata, h)
% --- push button opens explorer window in working directory
function pushbuttonOpenExplorer_Callback(hObject, eventdata, h)
winopen(h.folderName);
% ---  push button goes to current matlab directory
function pushbutton_pwd_Callback(hObject, eventdata, h)
h.folderName = pwd;
h.ii=1;
h=IP_ReadNotes(h);
h=IP_Refresh(hObject,eventdata,h);
% ---  push button goes to Montalbano
function pushbuttonFolderMontalbano_Callback(hObject, eventdata, h)
temp=uigetdir('\\Montalbano-hp\2015\','Choose Image Directory');
if temp==0
    % cancelled, do nothing
else
    h.folderName = temp;
    h.ii=1;
    h=IP_ReadNotes(h);
    h=IP_Refresh(hObject,eventdata,h);
end;
% --- root folder directory 
function listbox_directory_Callback(hObject, eventdata, h)
val=get(h.listbox_directory,'val');
str=get(h.listbox_directory,'string');
h.folderName=[h.rootFolderName  str{val}];
h=IP_ReadNotes(h);  
h.FitResArr(:,12)=0;
h.ii=1;
h=IP_Refresh(hObject,eventdata,h);
function listbox_directory_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- current folder non .png files
function listbox_directoryFiles_Callback(hObject, eventdata, h)
%% double click hax
if get(hObject, 'UserData') == get(hObject, 'Value')
    val=get(h.listbox_directoryFiles,'val');
    str=get(h.listbox_directoryFiles,'str');
    fname=[h.folderName '\' str{val}];
    winopen(fname);
end
set(hObject, 'UserData', get(hObject, 'Value'));
function listbox_directoryFiles_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_clearFits.
function pushbutton_clearFits_Callback(hObject, eventdata, h)
h.physicalDataArr=[];
h=IP_Refresh(hObject,eventdata,h);


function edit_exclude_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
function edit_exclude_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
        
function edit_RefScale_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
function edit_RefScale_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_loadFits.
function pushbutton_loadFits_Callback(hObject, eventdata, h)
% h.FitResArr(h.ii,:)=h.FitRes; h.FitResErrArr(h.ii,:)=h.FitResErr;
% 
% x=h.x; 
% dataMode=h.imgMode; imgMode=h.analysisMode;
% resultArr=h.physicalDataArr; dresultArr=h.physicalDataArr; % processed data         
% save([h.folderName '\IPData'],'x','resultArr','dresultArr','dataMode','imgMode');
% fprintf('Fits saved!\n');
h=IP_Refresh(hObject,eventdata,h);


function editProfWidth_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
% --- Executes during object creation, after setting all properties.
function editProfWidth_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkboxAutoRefresh.
function checkboxAutoRefresh_Callback(hObject, eventdata, h)
if get(h.checkboxAutoRefresh,'value')==0
    if strcmp(get(h.timer, 'Running'), 'on')
        stop(h.timer);
    end
else
    if strcmp(get(h.timer, 'Running'), 'off')
        start(h.timer);
    end
end;

function edit_2DexcludeRange_Callback(hObject, eventdata, h)
h=IP_Refresh(hObject,eventdata,h);
function edit_2DexcludeRange_CreateFcn(hObject, eventdata, h)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ExportImage.
function pushbutton_ExportImage_Callback(hObject, eventdata, h)

hf2=figure(2);
%% generate signal, scale, plot
if get(h.checkboxImageScale,'value')==1
    scale_img  = 50/max(max(h.img));
else
    scale_img = str2double(get(h.editImageScale,'string'));
end;
h.xlims=(get(h.axesImage,'xlim')); h.ylims=(get(h.axesImage,'ylim')); % get current image size 
h.imgHandle=image(h.img*scale_img);
xlim([h.xlims(1),h.xlims(2)]); ylim([h.ylims(1),h.ylims(2)]);

fname='image';
% saveas(h.axesImage,fname);
FN_ExportImage(fname,'jpg');
close(hf2);
