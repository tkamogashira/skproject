function varargout = FlatSpec(varargin)
% FlatSpec Application M-file for FlatSpec.fig
%    FIG = FlatSpec launch FlatSpec GUI.
%    FlatSpec('callback_name', ...) invoke the named callback.
%
% The program obtains filter coefficients to correct the earphone response.
%
% By SF, 8/1/2001

% Last Modified by GUIDE v2.5 11-Jun-2003 15:50:22

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

    
    %Codes added by Shig start here ---------------------
    %Set default parameters
    %SetDefaultParam(handles);
    
    %Set parameters used last time
    SetLastParam(handles);
        
    %--------------------- Codes added by Shig end here
    
	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SetLastParam(handles)

load FlatSpec LastSetting

%Set the radio buttons for L chan
if LastSetting.ChanNo==1
    set(handles.RadioLeft,'Value',1);
    set(handles.RadioRight,'Value',0);
else
    set(handles.RadioLeft,'Value',0);
    set(handles.RadioRight,'Value',1);
end
%Passband
set(handles.EditPassband,'String',LastSetting.PassBand); 
%No of filter coefficients
set(handles.EditNFilt,'String',LastSetting.NFiltCoef);
%Initial Atten
set(handles.EditInitialAtten,'String',LastSetting.InitialAtten);
%AdjustAtten
set(handles.CheckAdjustAtten,'Value',LastSetting.AdjustAttenFlag);
%Mic Sensitivity
set(handles.EditMicSensitivityV,'String',LastSetting.MicSensitivityV);
set(handles.EditMicSensitivitySPL,'String',LastSetting.MicSensitivitySPL);
%Filename for saving or appending
set(handles.EditFileName,'String',LastSetting.FileName);
%Sampling freq
set(handles.PopupFs,'Value',LastSetting.IdxFsRP2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SetDefaultParam(handles)
% Subfunction to set default parameters

%Set the radio buttons for L chan
set(handles.RadioLeft,'Value',1);
set(handles.RadioRight,'Value',0);
%Passband
set(handles.EditPassband,'String','[100 10000]'); 
%No of filter coefficients
set(handles.EditNFilt,'String','256');
%Initial Atten
set(handles.EditInitialAtten,'String','99');
%AdjustAtten
set(handles.CheckAdjustAtten,'Value',1);
%Mic Sensitivity
set(handles.EditMicSensitivityV,'String','1e-6');
set(handles.EditMicSensitivitySPL,'String','0');
%Filename for saving or appending
set(handles.EditFileName,'String',SpkrFile);
%Sampling freq
set(handles.PopupFs,'Value',4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ActivateObjects(handles,OnOff);

hvec=[handles.PushGo];

if strcmpi(OnOff,'off');
    set(hvec,'Enable','off');
else
    set(hvec,'Enable','on');
end    



%%%%%%%%%%  %%%%%%%%%%%%%%%%%%%%%

%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



% --------------------------------------------------------------------
function varargout = RadioLeft_Callback(h, eventdata, handles, varargin)

set(handles.RadioLeft,'Value',1);
set(handles.RadioRight,'Value',0);


% --------------------------------------------------------------------
function varargout = RadioRight_Callback(h, eventdata, handles, varargin)

set(handles.RadioLeft,'Value',0);
set(handles.RadioRight,'Value',1);



% --------------------------------------------------------------------
function varargout = EditPassband_Callback(h, eventdata, handles, varargin)



% --------------------------------------------------------------------
function varargout = EditNFilt_Callback(h, eventdata, handles, varargin)



% --------------------------------------------------------------------
function varargout = EditFileName_Callback(h, eventdata, handles, varargin)



% --------------------------------------------------------------------
function varargout = PushBrowseFile_Callback(h, eventdata, handles, varargin)
%Browse the output file and set the file name in the edit box

[FileName,PathName] = uigetfile('*.mat','File name for saving or appending the data');
if isstr(FileName) & isstr(PathName)
    mystr=fullfile(PathName,FileName);
    set(handles.EditFileName,'String',mystr);
end


% --------------------------------------------------------------------
function varargout = PushGo_Callback(h, eventdata, handles, varargin)
% Run the program
global IdxFsRP2

%Inactivate some objects
ActivateObjects(handles,'off');
cla(handles.AxesSystemResponse);
cla(handles.AxesFiltCoef);
cla(handles.AxesFlatNoise);


%%% Get parameters %%%%%%%%%%%%
%Channel specification
if get(handles.RadioRight,'Value');
    ChanNo=2; %Right Channel
    ColorSpec='r';
else
    ChanNo=1; %Left Channel
    ColorSpec='b';
end
%Passband
PassBand=eval(get(handles.EditPassband,'String')); 
%No of filter coefficients
NFiltCoef=eval(get(handles.EditNFilt,'String')); 
%Initial Atten
InitialAtten=eval(get(handles.EditInitialAtten,'String')); 
%Initial Atten
AdjustAttenFlag=get(handles.CheckAdjustAtten,'Value'); 
%MicSensitivity
MicSensitivityV=eval(get(handles.EditMicSensitivityV,'String')); 
MicSensitivitySPL=eval(get(handles.EditMicSensitivitySPL,'String')); 
MicSensitivity=[MicSensitivityV MicSensitivitySPL];
%Filename for saving or appending
FileName=get(handles.EditFileName,'String');
%Sampling frequency
IdxFsRP2=get(handles.PopupFs,'Value');

%%% Run the computation function %%%%%%%%%%%%
Rtn=GetFiltCoef(ChanNo,PassBand,NFiltCoef,InitialAtten,AdjustAttenFlag,MicSensitivity,0);
if isempty(Rtn) %The program not succesful
    errofdlg(lasterr);
    
    %Activate some objects
    ActivateObjects(handles,'on');
    
    return;
end



%%% Display the results %%%%%%%%%%%%
%Sampling Frequency
set(handles.TextFs,'String',sprintf('%.1f',Rtn.Fs));


%System Freq response
axes(handles.AxesSystemResponse);
I=find(Rtn.SysResp.Freq>0);
warning off
y=20*log10(abs(Rtn.SysResp.H));
warning on
% x=Rtn.SysResp.Freq/1000;
% %semilogx(x,y,ColorSpec);
% plot(x,y,ColorSpec);
% xlim([10 Rtn.Fs/2/1000]);
x=Rtn.SysResp.Freq;
semilogx(x(I),y(I),ColorSpec);
xlim([10 Rtn.Fs/2]);
myylim=ylim;
myylim(1)=max(y(:))-50;
ylim(myylim);
title('System Freq Response');
%xlabel('Frequency (kHz)');
xlabel('Frequency (Hz)');
ylabel('(dB)');

%Filter coefficients
axes(handles.AxesFiltCoef);
plot(Rtn.FiltCoef,ColorSpec);
xlim([1 NFiltCoef])
myylim=ylim;
ylim([-1 1]*max(myylim));
title(sprintf('Filter Coefficients: Gain %.1fdB; Delay %dpts',Rtn.FiltGain,Rtn.FiltDelayPts));

%Spectrum of the flat noise
axes(handles.AxesFlatNoise);
I=find(Rtn.FlatNoise.Freq>0);
y=20*log10(abs(Rtn.FlatNoise.AmpSpec));
% x=Rtn.FlatNoise.Freq/1000;
% plot(x,y,ColorSpec);
% xlim([10 Rtn.Fs/2/1000]);
x=Rtn.FlatNoise.Freq;
semilogx(x(I),y(I),ColorSpec);
xlim([10 Rtn.Fs/2]);
myylim=ylim;
myylim(1)=max(y(:))-50;
ylim(myylim);
%Get STD within the passband
Iin=find(abs(Rtn.FlatNoise.Freq)>=min(PassBand) & abs(Rtn.FlatNoise.Freq)<=max(PassBand));
STD=std(y(Iin));
title(sprintf('Flattened Noise: STD %.1fdB',STD));
%xlabel('Frequency (kHz)');
xlabel('Frequency (Hz)');
ylabel('(dB)');

%%%% Save the results %%%%%%%%%%%%%%%%%%
if ~exist(FileName) %File does not exist
    %Check if the directory exists
    [PATH,NAME,EXT]=fileparts(FileName);
    if exist(PATH,'dir')~=7
        %Ask if making the directory
        ButtonName=questdlg(['Directory ' PATH ' does not exist. Create it?'], ...
            ' ','Yes','No','Yes');
        if strcmp(ButtonName,'Yes')
            dos(['mkdir ' PATH]);
        else
            %Activate the button
            ActivateObjects(handles,'on');
        end
    end
    
    %Save the data
    if ChanNo==1;
        L=Rtn;
        save(FileName,'L');
    else
        R=Rtn;
        save(FileName,'R');
    end

else %The file already exists -- append the data
    if ChanNo==1;
        L=Rtn;
        save(FileName,'L','-append');
    else
        R=Rtn;
        save(FileName,'R','-append');
    end
end

%Save the filter coefficients in binary format
[PATH,NAME,EXT]=fileparts(FileName);
myFileName=fullfile(PATH,['FIRCoeff' num2str(ChanNo) '.f32']);
fid=fopen(myFileName,'wb');
fwrite(fid,Rtn.FiltCoef,'float32');
fclose(fid);

%Activate the button
ActivateObjects(handles,'on');

% --------------------------------------------------------------------
function varargout = PushDefault_Callback(h, eventdata, handles, varargin)
%Set default parameters

SetDefaultParam(handles);

% --------------------------------------------------------------------
function varargout = PushQuit_Callback(h, eventdata, handles, varargin)
%Close the window

%%% Save the parameters %%%%%%%%%%%%
LastSetting=[];
%Channel specification
if get(handles.RadioRight,'Value');
    LastSetting.ChanNo=2; %Right Channel
else
    LastSetting.ChanNo=1; %Left Channel
end
%Passband
LastSetting.PassBand=get(handles.EditPassband,'String'); 
%No of filter coefficients
LastSetting.NFiltCoef=get(handles.EditNFilt,'String'); 
%Initial Atten
LastSetting.InitialAtten=get(handles.EditInitialAtten,'String'); 
%Initial Atten
LastSetting.AdjustAttenFlag=get(handles.CheckAdjustAtten,'Value'); 
%MicSensitivity
LastSetting.MicSensitivityV=get(handles.EditMicSensitivityV,'String'); 
LastSetting.MicSensitivitySPL=get(handles.EditMicSensitivitySPL,'String'); 
%Filename for saving or appending
LastSetting.FileName=get(handles.EditFileName,'String');
%Sampling frequency
LastSetting.IdxFsRP2=get(handles.PopupFs,'Value');

save FlatSpec LastSetting

%Close
close(handles.FigFlatSpec);

% --- Executes during object creation, after setting all properties.
function PopupFs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopupFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in PopupFs.
function PopupFs_Callback(hObject, eventdata, handles)
% hObject    handle to PopupFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns PopupFs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PopupFs


% --- Executes on button press in PushReset.
function PushReset_Callback(hObject, eventdata, handles)
% hObject    handle to PushReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ActivateObjects(handles,'on');


% --- Executes during object creation, after setting all properties.
function EditInitialAtten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditInitialAtten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function EditInitialAtten_Callback(hObject, eventdata, handles)
% hObject    handle to EditInitialAtten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditInitialAtten as text
%        str2double(get(hObject,'String')) returns contents of EditInitialAtten as a double


% --- Executes on button press in CheckAdjustAtten.
function CheckAdjustAtten_Callback(hObject, eventdata, handles)
% hObject    handle to CheckAdjustAtten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckAdjustAtten


% --- Executes during object creation, after setting all properties.
function EditMicSensitivityV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditMicSensitivityV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function EditMicSensitivityV_Callback(hObject, eventdata, handles)
% hObject    handle to EditMicSensitivityV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditMicSensitivityV as text
%        str2double(get(hObject,'String')) returns contents of EditMicSensitivityV as a double


% --- Executes during object creation, after setting all properties.
function EditMicSensitivitySPL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditMicSensitivitySPL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function EditMicSensitivitySPL_Callback(hObject, eventdata, handles)
% hObject    handle to EditMicSensitivitySPL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditMicSensitivitySPL as text
%        str2double(get(hObject,'String')) returns contents of EditMicSensitivitySPL as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditMicSensitivityV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to EditMicSensitivityV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditMicSensitivityV as text
%        str2double(get(hObject,'String')) returns contents of EditMicSensitivityV as a double


