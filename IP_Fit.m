function h=IP_Fit(hObject,h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\
% --- actually perform fits
if get(h.checkboxFit,'value')==1
    pause(0.001); % ensure completion of execution
    fprintf(['Fitting image ' num2str(h.ii,'%1.0f') '...']);
    %% initial guess coefficients
    x_0=h.coordinates(1); y_0=h.coordinates(2); BG_0 = 0;
    if get(h.checkboxFitAutoGuess,'value')==1
        sx_0=20; A_0=max(max(h.img));
        h.fitData(:,1)=[A_0 sx_0 sx_0 A_0 sx_0 sx_0];
        set(h.uitableFit,'data',h.fitData);
    else
        h.fitData=get(h.uitableFit,'data');
    end;
    %% exclude parameters constant - x center, y center, range    
    const=[x_0, y_0, str2double(get(h.edit_2DexcludeRange,'string'))];
    
    %% do fit
    x=h.xlims(1):h.xlims(2); y=h.ylims(1):h.ylims(2); %% zoomed image size
    imgFit=h.img(max(1,floor(y)),max(1,floor(x)));
    if get(h.popupmenuFitModel,'value')==1
        % BG AG xG yG x0 y0
        A_G=h.fitData(1); sx_G=h.fitData(2); sy_G=h.fitData(3);
        startPoint=[BG_0,A_G,sx_G,sy_G,x_0,y_0];
        [FitRes,FitResErr] = IP_FIT2DGauss(x,y,imgFit,startPoint,const);
        data=[FitRes(1) FitRes(2) FitRes(3) FitRes(4) 0 0 0 FitRes(5) FitRes(6)];
    elseif get(h.popupmenuFitModel,'value')==2
        % BG ATF xTF yTF x0 y0
        A_TF=h.fitData(4); sx_TF=h.fitData(5); sy_TF=h.fitData(6);
        startPoint=[BG_0,A_TF,sx_TF,sy_TF,x_0,y_0];
        [FitRes,FitResErr] = IP_FIT2DTF(x,y,imgFit,startPoint);
        data=[FitRes(1) 0 0 0 FitRes(2) FitRes(3) FitRes(4) FitRes(5) FitRes(6)];
    elseif get(h.popupmenuFitModel,'value')==3
        % BG ATF AG xTF xG yTF yG x0 y0
        A_G=h.fitData(1); sx_TF=h.fitData(2); sy_TF=h.fitData(3); A_TF=h.fitData(4); sx_G=h.fitData(5); sy_G=h.fitData(6);
        startPoint=[BG_0 A_TF A_G sx_TF sx_G sy_TF sy_G x_0 y_0];
        [FitRes,FitResErr] = IP_FIT2DBimodal(x,y,imgFit,startPoint);        
        data=[FitRes(1) FitRes(3) FitRes(5) FitRes(7) FitRes(2) FitRes(4) FitRes(6) FitRes(8) FitRes(9)];
    elseif get(h.popupmenuFitModel,'value')==4        
        A_G=h.fitData(1); sx_TF=h.fitData(2); sy_TF=h.fitData(3); A_TF=h.fitData(4); sx_G=h.fitData(5); sy_G=h.fitData(6);
        startPoint=[BG_0 A_TF A_G sx_TF sx_G sy_TF sy_G x_0 y_0];
        [FitRes,FitResErr] = IP_Analyze2DBimodal(x,y,imgFit,startPoint);
        data=[FitRes(1) FitRes(3) FitRes(5) FitRes(7) FitRes(2) FitRes(4) FitRes(6) FitRes(8) FitRes(9)];
    end;
    h.fitData(:,2)=data(2:7);
    set(h.uitableFit,'data',h.fitData);
    h.FitRes=[h.imgMode get(h.popupmenuFitModel,'value') data 1];
    h.FitResErr=[h.imgMode get(h.popupmenuFitModel,'value') data 1];
    %% save
    h.FitResArr(h.ii,:)=h.FitRes; h.FitResErrArr(h.ii,:)=h.FitResErr;
    fprintf('Done!\n');
end;