function varargout = SetAdaptIPD(varargin)
% SETADAPTIPD Application M-file for SetAdaptIPD.fig
%    FIG = SETADAPTIPD launch SetAdaptIPD GUI.
%    SETADAPTIPD('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 08-Apr-2003 16:49:21

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

    %----------------------------------
    %Initialization Code
    
    %Use the settings used previously
    if exist('SetAdaptIPD.mat','file')==2
        load('SetAdaptIPD') %Load the settings

        if exist('Setting','var')==1
            SetAdaptIPD('SetSetting',Setting);
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
function Setting = GetSetting
%Read the current settings
%

myh=findobj('Tag','fig_setadaptipd');
Setting=[];
if ~isempty(myh)
    myhandles=guihandles(myh);
    
    %Adapter
    Setting.AdaptDur=get(myhandles.edit_adaptdur,'String');
    Setting.AdaptFreq=get(myhandles.edit_adaptfreq,'String');
    Setting.AdaptSPL=get(myhandles.edit_adaptspl,'String');
    Setting.AdaptITDRadFlag=get(myhandles.check_adaptitdrad,'Value');
    Setting.AdaptITDRad=get(myhandles.edit_adaptitdrad,'String');
    Setting.AdaptITDusFlag=get(myhandles.check_adaptitdus,'Value');
    Setting.AdaptITDus=get(myhandles.edit_adaptitdus,'String');

    %Probe
    Setting.ProbeDur=get(myhandles.edit_probedur,'String');
    Setting.ProbeFreq=get(myhandles.edit_probefreq,'String');
    Setting.ProbeSPL=get(myhandles.edit_probespl,'String');
    Setting.ProbeITDRadFlag=get(myhandles.check_probeitdrad,'Value');
    Setting.ProbeITDRad=get(myhandles.edit_probeitdrad,'String');
    Setting.ProbeITDusFlag=get(myhandles.check_probeitdus,'Value');
    Setting.ProbeITDus=get(myhandles.edit_probeitdus,'String');

    %Gap
    Setting.GapDur=get(myhandles.edit_gapdur,'String');
    
    %Silence Duration and Ramp Duration
    Setting.Silence1=get(myhandles.edit_silence1dur,'String');
    Setting.Silence2=get(myhandles.edit_silence2dur,'String');
    Setting.Ramp=get(myhandles.edit_rampdur,'String');
    
    %Flag for fixed envelope
    Setting.FixEnvFlag=get(myhandles.check_fixenv,'Value');
end


% --------------------------------------------------------------------
function varargout = SetSetting(Setting)
%Set the current settings
%

myh=findobj('Tag','fig_setadaptipd');
if ~isempty(myh) & ~isempty(Setting)
    myhandles=guihandles(myh);
    
    %Adapter
    set(myhandles.edit_adaptdur,'String',Setting.AdaptDur);
    set(myhandles.edit_adaptfreq,'String',Setting.AdaptFreq);
    set(myhandles.edit_adaptspl,'String',Setting.AdaptSPL);
    set(myhandles.check_adaptitdrad,'Value',Setting.AdaptITDRadFlag);
    if Setting.AdaptITDRadFlag %% Disable the UI controls when the check is off
        set(myhandles.edit_adaptitdrad,'Enable','on');
    else
        set(myhandles.edit_adaptitdrad,'Enable','off');
    end
    set(myhandles.edit_adaptitdrad,'String',Setting.AdaptITDRad);
    if Setting.AdaptITDusFlag %% Disable the UI controls when the check is off
        set(myhandles.edit_adaptitdus,'Enable','on');
    else
        set(myhandles.edit_adaptitdus,'Enable','off');
    end
    set(myhandles.edit_adaptitdus,'String',Setting.AdaptITDus);

    %Gap
    set(myhandles.edit_gapdur,'String',Setting.GapDur);

    %Probe
    set(myhandles.edit_probedur,'String',Setting.ProbeDur);
    set(myhandles.edit_probefreq,'String',Setting.ProbeFreq);
    set(myhandles.edit_probespl,'String',Setting.ProbeSPL);
    set(myhandles.check_probeitdrad,'Value',Setting.ProbeITDRadFlag);
    if Setting.ProbeITDRadFlag %% Disable the UI controls when the check is off
        set(myhandles.edit_probeitdrad,'Enable','on');
    else
        set(myhandles.edit_probeitdrad,'Enable','off');
    end
    set(myhandles.edit_probeitdrad,'String',Setting.ProbeITDRad);
    if Setting.ProbeITDusFlag %% Disable the UI controls when the check is off
        set(myhandles.edit_probeitdus,'Enable','on');
    else
        set(myhandles.edit_probeitdus,'Enable','off');
    end
    set(myhandles.edit_probeitdus,'String',Setting.ProbeITDus);

    %Silence Duration and Ramp Duration
    set(myhandles.edit_silence1dur,'String',Setting.Silence1);
    set(myhandles.edit_silence2dur,'String',Setting.Silence2);
    set(myhandles.edit_rampdur,'String',Setting.Ramp);
    
    %Flag for fixed envelope
    set(myhandles.check_fixenv,'Value',Setting.FixEnvFlag);

end


% --------------------------------------------------------------------
function varargout = MakeStimList(Setting)
%Parse the current settings and make the stim list
%
global STIM


%%%%%%%%%%%%% Parse the current settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Adapter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Duration
AdaptDur=str2num(Setting.AdaptDur);
if isempty(AdaptDur)
    error('Invalid duration setting for the adapter.');
elseif length(AdaptDur)>1
    myh=warndlg({'Your specified more than one Adapter Duration','... Only the first one will be used.'}, 'Warning','modal');
    AdaptDur=AdaptDur(1);
end
if ~(AdaptDur>0)
    error('Invalid duration setting for the adapter.');
end
%Freq
AdaptFreq=str2num(Setting.AdaptFreq);
if isempty(AdaptFreq)
    error('Invalid freq setting for the adapter.');
elseif length(AdaptFreq)>1
    myh=warndlg({'Your specified more than one Adapter Freq','... Only the first one will be used.'}, 'Warning','modal');
    AdaptFreq=AdaptFreq(1);
end
if ~(AdaptFreq>0)
    error('Invalid freq setting for the adapter.');
end
%SPL
AdaptSPL=str2num(Setting.AdaptSPL);
if isempty(AdaptSPL)
    error('Invalid SPL setting for the adapter.');
end
if any(AdaptSPL>100)
    myh=warndlg('>100dB AdaptSPL is included','Warning');
    uiwait(myh);
end
AdaptSPL=sort(AdaptSPL);
NAdaptSPL=length(AdaptSPL);

%ITD
AdaptITD=[];
if Setting.AdaptITDRadFlag %Adapter ITD in radian
    itd=str2num(Setting.AdaptITDRad);
    itd=(1/AdaptFreq)*1e6*itd/(2*pi); %Convert to us
    AdaptITD=[itd(:)'];
end
if Setting.AdaptITDusFlag %Adapter ITD in us
    itd=str2num(Setting.AdaptITDus);
    AdaptITD=[AdaptITD itd(:)'];
end
AdaptITD=sort(AdaptITD); %Sort the ITD
NAdaptITD=length(AdaptITD);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Gap %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GapDur=[];
gap=str2num(Setting.GapDur);
if isempty(gap)
    error('Invalid Gap setting.');
elseif any(gap<0)
    error('Negative Gap not allowed.');
end
GapDur=sort(gap);
NGapDur=length(GapDur);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Probe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Duration
ProbeDur=str2num(Setting.ProbeDur);
if isempty(ProbeDur)
    error('Invalid duration setting for the probe.');
elseif length(ProbeDur)>1
    myh=warndlg({'Your specified more than one Probe Duration','... Only the first one will be used.'}, 'Warning','modal');
    ProbeDur=ProbeDur(1);
end
if ~(ProbeDur>0)
    error('Invalid duration setting for the probe.');
end
%Freq
ProbeFreq=str2num(Setting.ProbeFreq);
if isempty(ProbeFreq)
    error('Invalid freq setting for the probe.');
elseif length(ProbeFreq)>1
    myh=warndlg({'Your specified more than one Probe Freq','... Only the first one will be used.'}, 'Warning','modal');
    ProbeFreq=ProbeFreq(1);
end
if ~(ProbeFreq>0)
    error('Invalid freq setting for the probe.');
end
%SPL
ProbeSPL=str2num(Setting.ProbeSPL);
if isempty(ProbeSPL)
    error('Invalid SPL setting for the probe.');
end
if any(ProbeSPL>100)
    myh=warndlg('>100dB ProbeSPL is included','Warning');
    uiwait(myh);
end
ProbeSPL=sort(ProbeSPL);
NProbeSPL=length(ProbeSPL);

%ITD
ProbeITD=[];
if Setting.ProbeITDRadFlag %Probe ITD in radian
    itd=str2num(Setting.ProbeITDRad);
    itd=(1/ProbeFreq)*1e6*itd/(2*pi); %Convert to us
    ProbeITD=[itd(:)'];
end
if Setting.ProbeITDusFlag %Probe ITD in us
    itd=str2num(Setting.ProbeITDus);
    ProbeITD=[ProbeITD itd(:)'];
end
ProbeITD = sort(ProbeITD); %Sort the ITD
NProbeITD=length(ProbeITD);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Silence and Ramp Durations %%%%%%%%%%%%%%%%%%%%%%%%%%%
%Silence1
Silence1=str2num(Setting.Silence1);
if isempty(Silence1)
    error('Invalid silence1 duration.');
elseif length(Silence1)>1
    myh=warndlg({'Your specified more than one Silence1 Duration','... Only the first one will be used.'}, 'Warning','modal');
    Silence1=Silence1(1);
end
if ~(Silence1>0)
    error('Invalid silence1 duration setting.');
end
%Silence2
Silence2=str2num(Setting.Silence2);
if isempty(Silence2)
    error('Invalid silence1 duration.');
elseif length(Silence2)>1
    myh=warndlg({'Your specified more than one Silence2 Duration','... Only the first one will be used.'}, 'Warning','modal');
    Silence2=Silence2(1);
end
if ~(Silence2>0)
    error('Invalid silence2 duration setting.');
end
%Ramp
Ramp=str2num(Setting.Ramp);
if isempty(Ramp)
    error('Invalid Ramp duration.');
elseif length(Ramp)>1
    myh=warndlg({'Your specified more than one Ramp Duration','... Only the first one will be used.'}, 'Warning','modal');
    Ramp=Ramp(1);
end
if ~(Ramp>0)
    error('Invalid ramp duration setting.');
elseif Ramp*2>AdaptDur | Ramp*2>AdaptDur
    myh=warndlg('Specified ramp duration exceeds the duration of the adapter or the probe.', 'Warning','modal');
end

%%%%%%%%%%%% Fix Envelope
FixEnvFlag=Setting.FixEnvFlag; %Fix envelope

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Make a cell array for a stim list %%%%%%%%%%%%%%%%%%%%%%%%
NCond=NAdaptSPL * NAdaptITD * NGapDur * NProbeSPL * NProbeITD;
mySTIM=cell(NCond,6);
cnt=0;
for iAdaptSPL=1:NAdaptSPL %%%%%%%%
    myAdaptSPL=AdaptSPL(iAdaptSPL);
    for iAdaptITD=1:NAdaptITD %%%%%%%%
        myAdaptITD=AdaptITD(iAdaptITD);
        for iGapDur=1:NGapDur %%%%%%%%
            myGapDur=GapDur(iGapDur);
            for iProbeSPL=1:NProbeSPL %%%%%%%%
                myProbeSPL=ProbeSPL(iProbeSPL);
                for iProbeITD=1:NProbeITD %%%%%%
                    myProbeITD=ProbeITD(iProbeITD);
                    
                    cnt=cnt+1;
                    mySTIM(cnt,:)={'AdaptIPD',num2str([AdaptDur AdaptFreq myAdaptSPL myAdaptITD]),num2str(myGapDur),...
                            num2str([ProbeDur ProbeFreq myProbeSPL myProbeITD]),num2str(FixEnvFlag),...
                            num2str([Silence1 Silence2 Ramp])};
                    
                end %for iProbeITD=1:NProbeITD
            end %for iProbeSPL=1:NProbeSPL
        end %for iGapDur=1:NGapDur
    end %for iAdaptITD=1:NAdaptITD
end %for iAdaptSPL=1:NAdaptSPL

%Append to STIM
[nrow,ncol]=size(STIM);
d=ncol-6;
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
function varargout = edit_adaptfreq_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = edit_adaptspl_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = edit_adaptdur_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = edit_adaptitdus_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = check_adaptitdus_Callback(h, eventdata, handles, varargin)

if get(h,'value')
    set(handles.edit_adaptitdus,'Enable','on');
else
    set(handles.edit_adaptitdus,'Enable','off');
end    


% --------------------------------------------------------------------
function varargout = check_adaptitdrad_Callback(h, eventdata, handles, varargin)

if get(h,'value')
    set(handles.edit_adaptitdrad,'Enable','on');
    set(handles.popup_adaptitdrad,'Enable','on');
else
    set(handles.edit_adaptitdrad,'Enable','off');
    set(handles.popup_adaptitdrad,'Enable','off');
end    




% --------------------------------------------------------------------
function varargout = edit_adaptitdrad_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_gapdur_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_probefreq_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_probespl_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_probedur_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_probeitdus_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = check_probeitdus_Callback(h, eventdata, handles, varargin)

if get(h,'value')
    set(handles.edit_probeitdus,'Enable','on');
else
    set(handles.edit_probeitdus,'Enable','off');
end    




% --------------------------------------------------------------------
function varargout = check_probeitdrad_Callback(h, eventdata, handles, varargin)

if get(h,'value')
    set(handles.edit_probeitdrad,'Enable','on');
    set(handles.popup_probeitdrad,'Enable','on');
else
    set(handles.edit_probeitdrad,'Enable','off');
    set(handles.popup_probeitdrad,'Enable','off');
end    




% --------------------------------------------------------------------
function varargout = edit_probeitdrad_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_silence1dur_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_silence2dur_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = check_fixenv_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = edit_rampdur_Callback(h, eventdata, handles, varargin)




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
Setting=SetAdaptIPD('GetSetting');
MakeStimList(Setting);

%Save the current setting
save SetAdaptIPD Setting

closereq %Close the window




% --------------------------------------------------------------------
function varargout = popup_adaptitdrad_Callback(h, eventdata, handles, varargin)
%Use a preset value for AdaptITD
%Presets are:
%(1) 0
%(2) [NaN -pi -pi/2 0 pi/2]
%(3) Cancel

NList=length(get(h,'String'));
Index=get(h,'Value');

if Index==1
    set(handles.edit_adaptitdrad,'String','0');
elseif Index==2
    set(handles.edit_adaptitdrad,'String','[NaN -pi -pi/2 0 pi/2]');
end    
    
    



% --------------------------------------------------------------------
function varargout = popup_probeitdrad_Callback(h, eventdata, handles, varargin)
%Use a preset value for ProbeITD
%Presets are:
%(1) 0
%(2) 8 divs
%(3) 18 divs
%(4) Cancel

NList=length(get(h,'String'));
Index=get(h,'Value');

if Index==1
    set(handles.edit_probeitdrad,'String','0');
elseif Index==2
    set(handles.edit_probeitdrad,'String','(-0.5 : 1/8 : (0.5-1/8)) * 2*pi');
elseif Index==3
    set(handles.edit_probeitdrad,'String','(-0.5 : 1/17 : (0.5-1/17)) * 2*pi');
end    


% --- Executes on button press in push_copy.
function push_copy_Callback(hObject, eventdata, handles)
% hObject    handle to push_copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of push_copy

%Copy adapt freq to probe setting
mystr=get(handles.edit_adaptfreq,'String');
set(handles.edit_probefreq,'String',mystr);

%Copy adapt SPL to probe setting
mystr=get(handles.edit_adaptspl,'String');
set(handles.edit_probespl,'String',mystr);
