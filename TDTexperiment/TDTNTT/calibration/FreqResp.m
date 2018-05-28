function varargout = FreqResp(varargin)
% FreqResp Application M-file for FreqResp.fig
%    FIG = FreqResp launch FreqResp GUI.
%    FreqResp('callback_name', ...) invoke the named callback.
%
% The program obtains filter coefficients to correct the earphone response.
%
% By SF, 8/1/2001

% Last Modified by GUIDE v2.5 11-Jun-2003 17:34:25

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

load FreqResp LastSetting

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
Rtn=GetFreqResp(ChanNo,PassBand,FileName,InitialAtten,AdjustAttenFlag,MicSensitivity,0);
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
x=Rtn.SysResp.Freq;
semilogx(x(I),y(I),ColorSpec);
xlim([10 Rtn.Fs/2]);
set(handles.EditXLim,'String',sprintf('[10 %.1f]',Rtn.Fs/2));
myylim=ylim;
myylim(1)=max(myylim)-50;
ylim(myylim);
set(handles.EditYLim,'String',sprintf('[%.1f %.1f]',myylim));
title('System Frequency Response')
xlabel('Frequency (Hz)');
ylabel('(dB)');

set(handles.TextData,'String',...
    {sprintf('STD: %4.1f (dB)',Rtn.SysResp.STD),...
        sprintf('InputSPL: %4.1f (dB)',Rtn.InputSPL),...
        sprintf('OutputSPL: %4.1f (dB)',Rtn.OutputSPL)});


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
%Initial Atten
LastSetting.InitialAtten=get(handles.EditInitialAtten,'String'); 
%Initial Atten
LastSetting.AdjustAttenFlag=get(handles.CheckAdjustAtten,'Value'); 
%MicSensitivity
LastSetting.MicSensitivityV=get(handles.EditMicSensitivityV,'String'); 
LastSetting.MicSensitivitySPL=get(handles.EditMicSensitivitySPL,'String'); 
%Fileter filename
LastSetting.FileName=get(handles.EditFileName,'String');
%Sampling frequency
LastSetting.IdxFsRP2=get(handles.PopupFs,'Value');

save FreqResp LastSetting

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
function EditXLim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditXLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function EditXLim_Callback(hObject, eventdata, handles)
% hObject    handle to EditXLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditXLim as text
%        str2double(get(hObject,'String')) returns contents of EditXLim as a double

myxlim=eval(get(hObject,'String'));
if ~isempty(myxlim)
    set(handles.AxesSystemResponse,'XLim',myxlim);
end

% --- Executes during object creation, after setting all properties.
function EditYLim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditYLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function EditYLim_Callback(hObject, eventdata, handles)
% hObject    handle to EditYLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditYLim as text
%        str2double(get(hObject,'String')) returns contents of EditYLim as a double

myylim=eval(get(hObject,'String'));
if ~isempty(myylim)
    set(handles.AxesSystemResponse,'YLim',myylim);
end

