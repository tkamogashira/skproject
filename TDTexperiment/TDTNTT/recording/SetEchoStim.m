function varargout = SetEchoStim(varargin)
% SETECHOSTIM Application M-file for SetEchoStim.fig
%    FIG = SETECHOSTIM launch SetEchoStim GUI.
%    SETECHOSTIM('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 19-Jan-2003 16:00:42

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

    %----------------------------------
    %Initialization Code
    
    %Use the settings used previously
    if exist('SetEchoStim.mat','file')==2
        load('SetEchoStim') %Load the settings

        if exist('Setting','var')==1
            SetEchoStim('SetSetting',Setting);
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
   
    %----------------------------------


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

myh=findobj('Tag','fig_setechostim');
Setting=[];
%
if ~isempty(myh)
    myhandles=guihandles(myh);
    
    %Source
    Setting.Noise=get(myhandles.check_noise,'Value');
    Setting.Click=get(myhandles.check_click,'Value');
    Setting.File=get(myhandles.check_file,'Value');
    Setting.FileName=get(myhandles.edit_filename,'String');
    
    %SPL
    Setting.SPL=get(myhandles.edit_spl,'String');

    %Echo amplitude ratio
    Setting.AmpRatio=get(myhandles.edit_ampratio,'String');
    
    %Delay
    Setting.Delay=get(myhandles.edit_delay,'String');
    
    %ITD
    Setting.ITD=get(myhandles.edit_itd,'String');

    %ILD
    Setting.ILD=get(myhandles.edit_ild,'String');
    
    %Duration
    Setting.Silence1=get(myhandles.edit_silence1,'String');
    Setting.NoiseDur=get(myhandles.edit_noisedur,'String');
    Setting.Silence2=get(myhandles.edit_silence2,'String');
    Setting.Ramp=get(myhandles.edit_ramp,'String');
end

% --------------------------------------------------------------------
function varargout = SetSetting(Setting)
%Set the current settings
%

myh=findobj('Tag','fig_setechostim');
if ~isempty(myh) & ~isempty(Setting)
    myhandles=guihandles(myh);
    
    %Source
    set(myhandles.check_noise,'Value',Setting.Noise);
    set(myhandles.check_click,'Value',Setting.Click);
    set(myhandles.check_file,'Value',Setting.File);
    set(myhandles.edit_filename,'String',Setting.FileName);
    
    %SPL
    set(myhandles.edit_spl,'String',Setting.SPL);
    
    %Echo amplitude ratio
    set(myhandles.edit_ampratio,'String',Setting.AmpRatio);
    
    %Delay
    set(myhandles.edit_delay,'String',Setting.Delay);
    
    %ITD
    set(myhandles.edit_itd,'String',Setting.ITD);

    %ILD
    set(myhandles.edit_ild,'String',Setting.ILD);
    
    %Duration
    set(myhandles.edit_silence1,'String',Setting.Silence1);
    set(myhandles.edit_noisedur,'String',Setting.NoiseDur);
    set(myhandles.edit_silence2,'String',Setting.Silence2);
    set(myhandles.edit_ramp,'String',Setting.Ramp);
end

% --------------------------------------------------------------------
function varargout = MakeStimList(Setting)
%Parse the current settings and make the stim list
%
global STIM


%%%%%%%%%%%%% Parse the current settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Source
Source=cell(3,1);
myIdx=[];
if Setting.Noise
    Source{1}='Noise';
    myIdx=[myIdx; 1];
end
if Setting.Click
    Source{2}='Click';
    myIdx=[myIdx; 2];
end
if Setting.File
    if isempty(Setting.FileName)
        error('Filename not specified');
    end
    Source{3}=Setting.FileName;
    myIdx=[myIdx; 3];
end
Source=Source(myIdx);
NSource=length(Source);

%SPL
SPL=str2num(Setting.SPL);
if isempty(SPL)
    error('Invalid SPL setting.');
end
NSPL=length(SPL);

    
%Echo amplitude ratio
AmpRatio=str2num(Setting.AmpRatio);
if isempty(AmpRatio)
    error('Invalid amp. ratio setting.');
end        
NAmpRatio=length(AmpRatio);

%Delay
Delay=str2num(Setting.Delay);
if isempty(Delay)
    error('Invalid Delay setting.');
end        
NDelay=length(Delay);
    
%ITD
ITD=str2num(Setting.ITD);
if isempty(ITD)
    error('Invalid ITD setting.');
end        
NITD=length(ITD);

%ILD
ILD=str2num(Setting.ILD);
if isempty(ILD)
    error('Invalid ILD setting.');
end        
NILD=length(ILD);

%Duration
Silence1=str2num(Setting.Silence1);
if length(Silence1)~=1
    error('Invalid Silence1 setting.');
end  
NoiseDur=str2num(Setting.NoiseDur);
if length(NoiseDur)~=1
    error('Invalid Tone Dur. setting.');
end        
Silence2=str2num(Setting.Silence2);
if length(Silence2)~=1
    error('Invalid Silence2 setting.');
end        
Ramp=str2num(Setting.Ramp);
if length(Ramp)~=1
    error('Invalid Ramp setting.');
end        

%%%%%%%%%%%% Make a cell array for a stim list %%%%%%%%%%%%%%%%%%%%%%%%
NCond=NSource*NSPL*NAmpRatio*NDelay*NITD*NILD;
mySTIM=cell(NCond,8);
cnt=0;
for iSource=1:NSource %%%%%%%%
    mySource=Source{iSource};
    for iSPL=1:NSPL %%%%%%%%
        mySPL=SPL(iSPL);
        for iAmpRatio=1:NAmpRatio %%%%
            myAmpRatio=AmpRatio(iAmpRatio);
            for iDelay=1:NDelay %%%%
                myDelay=Delay(iDelay);
                for iITD=1:NITD %%%%%%
                    myITD=ITD(iITD);
                    for iILD=1:NILD %%%%%
                        myILD=ILD(iILD);
                        
                        cnt=cnt+1;
                        mySTIM(cnt,:)={'EchoStim',mySource, num2str(mySPL),num2str(myAmpRatio),num2str(myDelay),num2str(myITD),...
                                num2str(myILD),num2str([Silence1 NoiseDur Silence2 Ramp])};
                        
                    end %for iILD=1:NILD
                end %for iITD=1:NITD
            end %for iDelay=1:NDelay
        end %for iAmpRatio=1:NAmpRatio
    end %for iSPL=1:NSPL
end %for iBand=1:NBand

%Append to STIM
[nrow,ncol]=size(STIM);
d=ncol-8;
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
function varargout = push_finish_Callback(h, eventdata, handles, varargin)
%Append the current settings to the STIM cell and close the window

%Get the current setting
Setting=SetEchoStim('GetSetting');
MakeStimList(Setting);

%Save the current setting
save SetEchoStim Setting


closereq %Close the window


% --------------------------------------------------------------------
function varargout = push_cancel_Callback(h, eventdata, handles, varargin)
%Close the window without appending the current settings

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
function varargout = edit_spl_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_itd_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_ild_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_silence1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_noisedur_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_silence2_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit_ramp_Callback(h, eventdata, handles, varargin)


% --- Executes during object creation, after setting all properties.
function edit_delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_delay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delay as text
%        str2double(get(hObject,'String')) returns contents of edit_delay as a double


% --- Executes on button press in check_noise.
function check_noise_Callback(hObject, eventdata, handles)
% hObject    handle to check_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_noise


% --- Executes on button press in check_click.
function check_click_Callback(hObject, eventdata, handles)
% hObject    handle to check_click (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_click


% --- Executes on button press in check_file.
function check_file_Callback(hObject, eventdata, handles)
% hObject    handle to check_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_file


% --- Executes during object creation, after setting all properties.
function edit_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_filename as a double


% --- Executes during object creation, after setting all properties.
function edit_ampratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ampratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_ampratio_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ampratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ampratio as text
%        str2double(get(hObject,'String')) returns contents of edit_ampratio as a double


