function varargout = SetPulseITD(varargin)
% SETPULSEITD Application M-file for SetPulseITD.fig
%    FIG = SETPULSEITD launch SetPulseITD GUI.
%    SETPULSEITD('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 27-May-2004 19:20:40

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

    %----------------------------------
    %Initialization Code
    
    %Use the settings used previously
    if exist('SetPulseITD.mat','file')==2
        load('SetPulseITD') %Load the settings

        if exist('Setting','var')==1
            SetSetting(Setting,handles);
        end
        
        %Position in the screen
        if exist('Position','var')==1 
            mypos=get(fig,'Position');
            mypos(1:2)=Position(1:2);
            set(fig,'Position',mypos);
        end
    end   

    %Make sure that the figure is visible on the screen
    movegui(fig,'onscreen');
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


%%%%%%%%%%%%%%% functions created by user %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function Setting = GetSetting(handles)
%Read the current settings
%

Setting=[];

%Pulse Type
Setting.GaussModToneFlag=get(handles.radio_GaussModTone,'Value');
Setting.GaussModNoiseFlag=get(handles.radio_GaussModNoise,'Value');
Setting.GaussPulseFlag=get(handles.radio_GaussPulse,'Value');
Setting.MonoClickFlag=get(handles.radio_MonoClick,'Value');
Setting.BiClickFlag=get(handles.radio_BiClick,'Value');
%
Setting.GaussModToneFreqLeft=get(handles.edit_GaussModToneFreqLeft,'String');
Setting.GaussModToneLeftManualFlag=get(handles.radio_GaussModToneLeftManual,'Value');
Setting.GaussModToneLeftLogSpaceFlag=get(handles.radio_GaussModToneLeftLogSpace,'Value');

Setting.GaussModToneFreqRight=get(handles.edit_GaussModToneFreqRight,'String');
Setting.GaussModToneRightManualFlag=get(handles.radio_GaussModToneRightManual,'Value');
Setting.GaussModToneRightLogSpaceFlag=get(handles.radio_GaussModToneRightLogSpace,'Value');
%
Setting.PositiveFlag=get(handles.check_Positive,'Value');
Setting.NegativeFlag=get(handles.check_Negative,'Value');

%Pulse Width
Setting.PulseWidth=get(handles.edit_PulseWidth,'String');

%Level
Setting.Level=get(handles.edit_Level,'String');

%ITD
Setting.ITD=get(handles.edit_ITD,'String');

%Duration
Setting.OffsetDur=get(handles.edit_OffsetDur,'String');
Setting.TotalDur=get(handles.edit_TotalDur,'String');


% --------------------------------------------------------------------
function varargout = SetSetting(Setting,handles)
%Set the current settings
%

if ~isempty(Setting)

    %Pulse Type
    set(handles.radio_GaussModTone,'Value',Setting.GaussModToneFlag);
    set(handles.radio_GaussModNoise,'Value',Setting.GaussModNoiseFlag);
    set(handles.radio_GaussPulse,'Value',Setting.GaussPulseFlag);
    set(handles.radio_MonoClick,'Value',Setting.MonoClickFlag);
    set(handles.radio_BiClick,'Value',Setting.BiClickFlag);
    %
    set(handles.edit_GaussModToneFreqLeft,'String',Setting.GaussModToneFreqLeft);
    set(handles.radio_GaussModToneLeftManual,'Value',Setting.GaussModToneLeftManualFlag);
    set(handles.radio_GaussModToneLeftLogSpace,'Value',Setting.GaussModToneLeftLogSpaceFlag);
    %
    set(handles.edit_GaussModToneFreqRight,'String',Setting.GaussModToneFreqRight);
    set(handles.radio_GaussModToneRightManual,'Value',Setting.GaussModToneRightManualFlag);
    set(handles.radio_GaussModToneRightLogSpace,'Value',Setting.GaussModToneRightLogSpaceFlag);
    %
    set(handles.check_Positive,'Value',Setting.PositiveFlag);
    set(handles.check_Negative,'Value',Setting.NegativeFlag);
    %% Update radio-button sensitive objects
    if get(handles.radio_GaussModTone,'value')
        radio_GaussModTone_Callback([], [], handles);
    end
    if get(handles.radio_GaussModNoise,'value')
        radio_GaussModNoise_Callback([], [], handles)    
    end
    if get(handles.radio_GaussPulse,'value')
        radio_GaussPulse_Callback([], [], handles)    
    end
    if get(handles.radio_MonoClick,'value')
        radio_MonoClick_Callback([], [], handles)    
    end
    if get(handles.radio_BiClick,'value')
        radio_BiClick_Callback([], [], handles)    
    end
    if get(handles.radio_GaussModToneLeftManual,'value')
        radio_GaussModToneLeftManual_Callback([], [], handles);
    end
    if get(handles.radio_GaussModToneLeftLogSpace,'value')
        radio_GaussModToneLeftLogSpace_Callback([], [], handles);
    end
    if get(handles.radio_GaussModToneRightManual,'value')
        radio_GaussModToneRightManual_Callback([], [], handles);
    end
    if get(handles.radio_GaussModToneRightLogSpace,'value')
        radio_GaussModToneRightLogSpace_Callback([], [], handles);
    end

    %Pulse Width
    set(handles.edit_PulseWidth,'String',Setting.PulseWidth);

    %Level
    set(handles.edit_Level,'String',Setting.Level);

    %ITD
    set(handles.edit_ITD,'String',Setting.ITD);
    
    %Duration
    set(handles.edit_OffsetDur,'String',Setting.OffsetDur);
    set(handles.edit_TotalDur,'String',Setting.TotalDur);
 
end


% --------------------------------------------------------------------
function varargout = MakeStimList(Setting,handles)
%Parse the current settings and make the stim list
%
global STIM

S=Setting;

%%%%%%%%%%%%% Parse the current settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% Pulse Type %%%%%%%%%%%%%%%%%%%%%%%%
if S.GaussModToneFlag
    PulseType='GaussModTone';
    
    %Read the frequency setting for left chan
    mystr=S.GaussModToneFreqLeft;
    if S.GaussModToneLeftManualFlag %Manual setting
        FreqLeft=str2num(mystr);
    else %Log-spaced freq
        
        %Read the setting
        %Format -- Lowest Freq : Step (oct) : Highest Freq
        [Fl,R]=strtok(mystr,':');
        if isempty(Fl) | length(R)<2
            error('Incorrect setting of log-spaced frequency (L)');
        end
        Fl=str2num(Fl);
        [Step,R]=strtok(R(2:end),':');
        if isempty(Step) | length(R)<2
            error('Incorrect setting of log-spaced frequency (L)');
        end
        Step=str2num(Step);
        [Fh,R]=strtok(R,':');
        if isempty(Fh) | ~isempty(R)
            error('Incorrect setting of log-spaced frequency (L)');
        end
        Fh=str2num(Fh);
        
        if Fl <=0 | Fl>Fh
            error('Incorrect setting of log-spaced frequency (L)');
        end
        
        FreqLeft=2.^(log2(Fl):Step:log2(Fh));
    end
    
    %Read the frequency setting for right chan
    mystr=S.GaussModToneFreqRight;
    if S.GaussModToneRightManualFlag %Manual setting
        FreqRight=str2num(mystr);
    else %Log-spaced freq
        
        %Read the setting
        %Format -- Lowest Freq : Step (oct) : Highest Freq
        [Fl,R]=strtok(mystr,':');
        if isempty(Fl) | length(R)<2
            error('Incorrect setting of log-spaced frequency (L)');
        end
        Fl=str2num(Fl);
        [Step,R]=strtok(R(2:end),':');
        if isempty(Step) | length(R)<2
            error('Incorrect setting of log-spaced frequency (L)');
        end
        Step=str2num(Step);
        [Fh,R]=strtok(R,':');
        if isempty(Fh) | ~isempty(R)
            error('Incorrect setting of log-spaced frequency (L)');
        end
        Fh=str2num(Fh);
        
        if Fl <=0 | Fl>Fh
            error('Incorrect setting of log-spaced frequency (L)');
        end
        
        FreqRight=2.^(log2(Fl):Step:log2(Fh));
    end
    
    Polarity=1; %dummy
end

if S.GaussModNoiseFlag
    PulseType='GaussModNoise';
    FreqLeft=0; %dummy
    FreqRight=0; %dummy
    Polarity=1; %dummy
end

if S.GaussPulseFlag
    PulseType='GaussPulse';
    FreqLeft=0; %dummy
    FreqRight=0; %dummy
    
    %Polarity
    mypos=[];    myneg=[];
    if S.PositiveFlag, mypos=1; end
    if S.NegativeFlag, myneg=-1; end
    if ~S.PositiveFlag & ~S.NegativeFlag
        myh=warndlg('No Polarity was selected. Use positive.','Warning');
        uiwait(myh);
        set(handles.check_Positive,'Value',1);
        mypos=1;
    end
    Polarity=[mypos myneg];
end

if S.MonoClickFlag
    PulseType='MonoClick';
    FreqLeft=0; %dummy
    FreqRight=0; %dummy
    
    %Polarity
    mypos=[];    myneg=[];
    if S.PositiveFlag, mypos=1; end
    if S.NegativeFlag, myneg=-1; end
    if ~S.PositiveFlag & ~S.NegativeFlag
        myh=warndlg('No Polarity was selected. Use positive.','Warning');
        uiwait(myh);
        set(handles.check_Positive,'Value',1);
        mypos=1;
    end
    Polarity=[mypos myneg];
end

if S.BiClickFlag
    PulseType='BiClick';
    FreqLeft=0; %dummy
    FreqRight=0; %dummy
    
    %Polarity
    mypos=[];    myneg=[];
    if S.PositiveFlag, mypos=1; end
    if S.NegativeFlag, myneg=-1; end
    if ~S.PositiveFlag & ~S.NegativeFlag
        myh=warndlg('No Polarity was selected. Use positive.','Warning');
        uiwait(myh);
        set(handles.check_Positive,'Value',1);
        mypos=1;
    end
    Polarity=[mypos myneg];
end
FreqLeft=sort(FreqLeft);
NFreqLeft=length(FreqLeft);
FreqRight=sort(FreqRight);
NFreqRight=length(FreqRight);
NPolarity=length(Polarity);


%%%%%%%%%%%% Pulse Width %%%%%%%%%%%%%%%%%%%%%%%%
PulseWidth=sort(str2num(S.PulseWidth));
NPulseWidth=length(PulseWidth);

%%%%%%%%%%%% Level %%%%%%%%%%%%%%%%%%%%%%%%
Level=sort(str2num(S.Level));
NLevel=length(Level);

%%%%%%%%%%%% ITD %%%%%%%%%%%%%%%%%%%%%%%%
ITD=sort(str2num(S.ITD));
NITD=length(ITD);

%%%%%%%%%%%% Duration %%%%%%%%%%%%%%%%%%%%%%%%
OffsetDur=str2num(S.OffsetDur);
if length(OffsetDur)>1
    error('Only one Offset duration is allowed');
end
TotalDur=str2num(S.TotalDur);
if length(TotalDur)>1
    error('Only one Total duration is allowed');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Make a cell array for a stim list %%%%%%%%%%%%%%%%%%%%%%%%
NCond=NFreqLeft * NFreqRight * NPolarity * NPulseWidth * NLevel * NITD;

NParam=8;

mySTIM=cell(NCond,NParam+1);
cnt=0;
for iFreqLeft=1:NFreqLeft %%%%%%%%
    myFreqLeft=FreqLeft(iFreqLeft);
    for iFreqRight=1:NFreqRight %%%%%%%%
        myFreqRight=FreqRight(iFreqRight);
        for iPolarity=1:NPolarity %%%%%%%%
            myPolarity=Polarity(iPolarity);
            for iPulseWidth=1:NPulseWidth %%%%%%%%
                myPulseWidth=PulseWidth(iPulseWidth);
                for iLevel=1:NLevel %%%%%%
                    myLevel=Level(iLevel);
                    for iITD=1:NITD %%%%%%
                        myITD=ITD(iITD);
                        
                        cnt=cnt+1;
                       mySTIM(cnt,:)={'PulseITD',PulseType,num2str(myFreqLeft),num2str(myFreqRight),...
                                num2str(myPolarity),num2str(myPulseWidth),num2str(myLevel),num2str(myITD),...
                                num2str([OffsetDur TotalDur])};
                        
                    end %for iITD=1:NITD
                end %for iLevel=1:NLevel
            end %for iPulseWidth=1:NPulseWidth
        end % for iPolarity=1:NPolarity
    end %for iFreqRight=1:NRight
end %for iFreqLeft=1:NFreqLeft

%Append to STIM
[nrow,ncol]=size(STIM);
d=ncol-(NParam+1);
if d>0
    STIM=[STIM; [mySTIM cell(NCond,d)]];
elseif d<0
    STIM=[[STIM cell(nrow,-d)]; mySTIM];
else
    STIM=[STIM; mySTIM];
end

%Update the number of conditions in the ExptMan
if ~isempty(findobj('tag','fig_exptman'))
    ExptMan('UpdateNCond'); 
end
if ~isempty(findobj('tag','fig_exptmanM'))
    ExptManM('UpdateNCond'); 
end



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
function varargout = push_cancel_Callback(h, eventdata, handles, varargin)

global STIM

%Update the number of conditions in the ExptMan
if ~isempty(findobj('tag','fig_exptman'))
    ExptMan('UpdateNCond'); 
end
if ~isempty(findobj('tag','fig_exptmanM'))
    ExptManM('UpdateNCond'); 
end


closereq %Close the window



% --------------------------------------------------------------------
function varargout = push_finish_Callback(h, eventdata, handles, varargin)

%Get the current setting
Setting=GetSetting(handles);
MakeStimList(Setting,handles);

Position=get(handles.fig_SetPulseITD,'Position');

%Save the current setting
save SetPulseITD Setting Position

closereq %Close the window


% --- Executes on button press in radio_GaussModTone.
function radio_GaussModTone_Callback(hObject, eventdata, handles)
% hObject    handle to radio_GaussModTone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_GaussModTone

h_GaussModToneFreq=[handles.text_GaussModToneFreq, handles.text_GaussModToneLeft, handles.text_GaussModToneRight, ...
        handles.text_GaussModToneManual, handles.text_GaussModToneLogSpace, handles.text_GaussModToneLogNote,...
        handles.edit_GaussModToneFreqLeft, handles.edit_GaussModToneFreqRight, ...
        handles.radio_GaussModToneLeftManual, handles.radio_GaussModToneRightManual, ...
        handles.radio_GaussModToneLeftLogSpace, handles.radio_GaussModToneRightLogSpace, ...
        handles.frame_GaussModToneFreq];
h_OtherRadio=[handles.radio_GaussModNoise, handles.radio_GaussPulse, handles.radio_MonoClick, handles.radio_BiClick];
h_Polarity=[handles.check_Positive, handles.check_Negative];

set(hObject,'Value',1)
set(h_OtherRadio,'Value',0);
set(h_GaussModToneFreq,'Enable','on');
set(h_Polarity,'Enable','off');

% --- Executes on button press in radio_GaussModNoise.
function radio_GaussModNoise_Callback(hObject, eventdata, handles)
% hObject    handle to radio_GaussModNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_GaussModNoise



h_GaussModToneFreq=[handles.text_GaussModToneFreq, handles.text_GaussModToneLeft, handles.text_GaussModToneRight, ...
        handles.text_GaussModToneManual, handles.text_GaussModToneLogSpace, handles.text_GaussModToneLogNote,...
        handles.edit_GaussModToneFreqLeft, handles.edit_GaussModToneFreqRight, ...
        handles.radio_GaussModToneLeftManual, handles.radio_GaussModToneRightManual, ...
        handles.radio_GaussModToneLeftLogSpace, handles.radio_GaussModToneRightLogSpace, ...
        handles.frame_GaussModToneFreq];
h_OtherRadio=[handles.radio_GaussModTone, handles.radio_GaussPulse, handles.radio_MonoClick, handles.radio_BiClick];
h_Polarity=[handles.check_Positive, handles.check_Negative];

set(hObject,'Value',1)
set(h_OtherRadio,'Value',0);
set(h_GaussModToneFreq,'Enable','off');
set(h_Polarity,'Enable','off');


% --- Executes on button press in radio_GaussPulse.
function radio_GaussPulse_Callback(hObject, eventdata, handles)
% hObject    handle to radio_GaussPulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_GaussPulse

h_GaussModToneFreq=[handles.text_GaussModToneFreq, handles.text_GaussModToneLeft, handles.text_GaussModToneRight, ...
        handles.text_GaussModToneManual, handles.text_GaussModToneLogSpace, handles.text_GaussModToneLogNote,...
        handles.edit_GaussModToneFreqLeft, handles.edit_GaussModToneFreqRight, ...
        handles.radio_GaussModToneLeftManual, handles.radio_GaussModToneRightManual, ...
        handles.radio_GaussModToneLeftLogSpace, handles.radio_GaussModToneRightLogSpace, ...
        handles.frame_GaussModToneFreq];
h_OtherRadio=[handles.radio_GaussModTone, handles.radio_GaussModNoise, handles.radio_MonoClick, handles.radio_BiClick];
h_Polarity=[handles.check_Positive, handles.check_Negative];

set(hObject,'Value',1)
set(h_OtherRadio,'Value',0);
set(h_GaussModToneFreq,'Enable','off');
set(h_Polarity,'Enable','on');
    


% --- Executes on button press in radio_MonoClick.
function radio_MonoClick_Callback(hObject, eventdata, handles)
% hObject    handle to radio_MonoClick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_MonoClick

h_GaussModToneFreq=[handles.text_GaussModToneFreq, handles.text_GaussModToneLeft, handles.text_GaussModToneRight, ...
        handles.text_GaussModToneManual, handles.text_GaussModToneLogSpace, handles.text_GaussModToneLogNote,...
        handles.edit_GaussModToneFreqLeft, handles.edit_GaussModToneFreqRight, ...
        handles.radio_GaussModToneLeftManual, handles.radio_GaussModToneRightManual, ...
        handles.radio_GaussModToneLeftLogSpace, handles.radio_GaussModToneRightLogSpace, ...
        handles.frame_GaussModToneFreq];
h_OtherRadio=[handles.radio_GaussModTone, handles.radio_GaussModNoise, handles.radio_GaussPulse, handles.radio_BiClick];
h_Polarity=[handles.check_Positive, handles.check_Negative];

set(hObject,'Value',1)
set(h_OtherRadio,'Value',0);
set(h_GaussModToneFreq,'Enable','off');
set(h_Polarity,'Enable','on');



% --- Executes on button press in radio_BiClick.
function radio_BiClick_Callback(hObject, eventdata, handles)
% hObject    handle to radio_BiClick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_BiClick

h_GaussModToneFreq=[handles.text_GaussModToneFreq, handles.text_GaussModToneLeft, handles.text_GaussModToneRight, ...
        handles.text_GaussModToneManual, handles.text_GaussModToneLogSpace, handles.text_GaussModToneLogNote,...
        handles.edit_GaussModToneFreqLeft, handles.edit_GaussModToneFreqRight, ...
        handles.radio_GaussModToneLeftManual, handles.radio_GaussModToneRightManual, ...
        handles.radio_GaussModToneLeftLogSpace, handles.radio_GaussModToneRightLogSpace, ...
        handles.frame_GaussModToneFreq];
h_OtherRadio=[handles.radio_GaussModTone, handles.radio_GaussModNoise, handles.radio_GaussPulse, handles.radio_MonoClick];
h_Polarity=[handles.check_Positive, handles.check_Negative];

set(hObject,'Value',1)
set(h_OtherRadio,'Value',0);
set(h_GaussModToneFreq,'Enable','off');
set(h_Polarity,'Enable','on');


% --- Executes during object creation, after setting all properties.
function edit_GaussModToneFreqLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_GaussModToneFreqLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_GaussModToneFreqLeft_Callback(hObject, eventdata, handles)
% hObject    handle to edit_GaussModToneFreqLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_GaussModToneFreqLeft as text
%        str2double(get(hObject,'String')) returns contents of edit_GaussModToneFreqLeft as a double



% --- Executes during object creation, after setting all properties.
function edit_GaussModToneFreqRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_GaussModToneFreqRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_GaussModToneFreqRight_Callback(hObject, eventdata, handles)
% hObject    handle to edit_GaussModToneFreqRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_GaussModToneFreqRight as text
%        str2double(get(hObject,'String')) returns contents of edit_GaussModToneFreqRight as a double



% --- Executes on button press in radio_GaussModToneLeftManual.
function radio_GaussModToneLeftManual_Callback(hObject, eventdata, handles)
% hObject    handle to radio_GaussModToneLeftManual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_GaussModToneLeftManual

set(hObject,'Value',1)
set(handles.radio_GaussModToneLeftLogSpace,'Value',0);

% --- Executes on button press in radio_GaussModToneRightManual.
function radio_GaussModToneRightManual_Callback(hObject, eventdata, handles)
% hObject    handle to radio_GaussModToneRightManual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_GaussModToneRightManual

set(hObject,'Value',1)
set(handles.radio_GaussModToneRightLogSpace,'Value',0);
    


% --- Executes on button press in radio_GaussModToneLeftLogSpace.
function radio_GaussModToneLeftLogSpace_Callback(hObject, eventdata, handles)
% hObject    handle to radio_GaussModToneLeftLogSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_GaussModToneLeftLogSpace

set(hObject,'Value',1)
set(handles.radio_GaussModToneLeftManual,'Value',0);


% --- Executes on button press in radio_GaussModToneRightLogSpace.
function radio_GaussModToneRightLogSpace_Callback(hObject, eventdata, handles)
% hObject    handle to radio_GaussModToneRightLogSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_GaussModToneRightLogSpace

set(hObject,'Value',1)
set(handles.radio_GaussModToneRightManual,'Value',0);


% --- Executes on button press in check_Positive.
function check_Positive_Callback(hObject, eventdata, handles)
% hObject    handle to check_Positive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_Positive


% --- Executes on button press in check_Negative.
function check_Negative_Callback(hObject, eventdata, handles)
% hObject    handle to check_Negative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_Negative


% --- Executes during object creation, after setting all properties.
function edit_PulseWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_PulseWidth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Level as text
%        str2double(get(hObject,'String')) returns contents of edit_Level as a double


% --- Executes during object creation, after setting all properties.
function edit_Level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_Level_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Level as text
%        str2double(get(hObject,'String')) returns contents of edit_Level as a double

% --- Executes during object creation, after setting all properties.
function edit_ITD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_ITD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Level as text
%        str2double(get(hObject,'String')) returns contents of edit_Level as a double

% --- Executes during object creation, after setting all properties.
function edit_OffsetDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_OffsetDur_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Level as text
%        str2double(get(hObject,'String')) returns contents of edit_Level as a double


% --- Executes during object creation, after setting all properties.
function edit_TotalDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_TotalDur_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Level as text
%        str2double(get(hObject,'String')) returns contents of edit_Level as a double


