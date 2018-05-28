function varargout = SetILD(varargin)
% SETILD M-file for SetILD.fig
%      SETILD, by itself, creates a new SETILD or raises the existing
%      singleton*.
%
%      H = SETILD returns the handle to a new SETILD or the handle to
%      the existing singleton*.
%
%      SETILD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETILD.M with the given input arguments.
%
%      SETILD('Property','Value',...) creates a new SETILD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SetILD_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SetILD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SetILD

% Last Modified by GUIDE v2.5 16-Dec-2002 10:31:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SetILD_OpeningFcn, ...
                   'gui_OutputFcn',  @SetILD_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%%%%%%%%% Initialization code by SF
%%%%%%%%%

if nargin==0
    myh=findobj('Tag','fig_setild');
    
    %Use the settings used previously
    if exist('SetILD.mat','file')==2
        load('SetILD') %Load the settings
        
        if exist('Setting','var')==1
%            SetFiles('SetSetting',Setting);
            SetSetting(Setting);
        end
        
        %Position in the screen
        if exist('Position','var')==1 
            mypos=get(myh,'Position');
            mypos(1:2)=Position(1:2);
            set(myh,'Position',mypos);
        end
    end   
    %Make sure that the figure is visible on the screen
%    movegui(myh,'onscreen');
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  User defined fucntions

%-------------------------------------------------------------%
function varargout = SetSetting(Setting)
%Set the current settings
%

myh=findobj('Tag','fig_setild');
if ~isempty(myh) & ~isempty(Setting)
    myhandles=guihandles(myh);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Left
    set(myhandles.check_left,'Value',Setting.LeftFlag);
    CheckLeft(myhandles);    
    %
    h_tonemanual=[myhandles.edit_lefttonemanual myhandles.text_lefttonemanualhz];
    h_tonelogspace=[myhandles.edit_lefttonelogspacestart myhandles.edit_lefttonelogspaceend myhandles.edit_lefttonelogspacestep ...
            myhandles.text_lefttonelogspacetild myhandles.text_lefttonelogspacehz myhandles.text_lefttonelogspaceoct];
    h_noise=[myhandles.edit_leftnoisepassband myhandles.text_leftnoisepassbandhz myhandles.edit_leftnoisefiltorder myhandles.text_leftnoisefiltorder];
    %
    set(myhandles.radio_lefttonemanual,'Value',Setting.LeftToneManualFlag);
    set(myhandles.edit_lefttonemanual,'String',Setting.LeftToneManualFreq);
    %
    set(myhandles.radio_lefttonelogspace,'Value',Setting.LeftToneLogSpaceFlag);
    set(myhandles.edit_lefttonelogspacestart,'String',Setting.LeftToneLogSpaceFreqStart);
    set(myhandles.edit_lefttonelogspaceend,'String',Setting.LeftToneLogSpaceFreqEnd);
    set(myhandles.edit_lefttonelogspacestep,'String',Setting.LeftToneLogSpaceFreqStep);
    %
    set(myhandles.radio_leftnoise,'Value',Setting.Left.NoiseFlag);
    set(myhandles.edit_leftnoisepassband,'String',Setting.LeftNoisePassband);
    set(myhandles.edit_leftnoisefiltorder,'String',Setting.LeftNoiseFiltOrder);
    %
    if Setting.LeftToneManualFlag
        set(h_tonemanual,'Enable','on');
        set(h_tonelogspace,'Enable','off');
        set(h_noise,'Enable','off');
    elseif Setting.LeftToneLogSpaceFlag
        set(h_tonemanual,'Enable','off');
        set(h_tonelogspace,'Enable','on');
        set(h_noise,'Enable','off');
    else
        set(h_tonemanual,'Enable','off');
        set(h_tonelogspace,'Enable','off');
        set(h_noise,'Enable','on');
    end
    %
    set(myhandles.edit_leftonset,'String',Setting.LeftOnset);
    set(myhandles.edit_leftduration,'String',Setting.LeftDuration);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Right
    set(myhandles.check_right,'Value',Setting.RightFlag);
    CheckRight(myhandles);    
    %
    h_tonemanual=[myhandles.edit_righttonemanual myhandles.text_righttonemanualhz];
    h_tonelogspace=[myhandles.edit_righttonelogspacestart myhandles.edit_righttonelogspaceend myhandles.edit_righttonelogspacestep ...
            myhandles.text_righttonelogspacetild myhandles.text_righttonelogspacehz myhandles.text_righttonelogspaceoct];
    h_noise=[myhandles.edit_rightnoisepassband myhandles.text_rightnoisepassbandhz myhandles.edit_rightnoisefiltorder myhandles.text_rightnoisefiltorder];
    %
    set(myhandles.radio_righttonemanual,'Value',Setting.RightToneManualFlag);
    set(myhandles.edit_righttonemanual,'String',Setting.RightToneManualFreq);
    %
    set(myhandles.radio_righttonelogspace,'Value',Setting.RightToneLogSpaceFlag);
    set(myhandles.edit_righttonelogspacestart,'String',Setting.RightToneLogSpaceFreqStart);
    set(myhandles.edit_righttonelogspaceend,'String',Setting.RightToneLogSpaceFreqEnd);
    set(myhandles.edit_righttonelogspacestep,'String',Setting.RightToneLogSpaceFreqStep);
    %
    set(myhandles.radio_rightnoise,'Value',Setting.Right.NoiseFlag);
    set(myhandles.edit_rightnoisepassband,'String',Setting.RightNoisePassband);
    set(myhandles.edit_rightnoisefiltorder,'String',Setting.RightNoiseFiltOrder);
    %
    if Setting.RightToneManualFlag
        set(h_tonemanual,'Enable','on');
        set(h_tonelogspace,'Enable','off');
        set(h_noise,'Enable','off');
    elseif Setting.RightToneLogSpaceFlag
        set(h_tonemanual,'Enable','off');
        set(h_tonelogspace,'Enable','on');
        set(h_noise,'Enable','off');
    else
        set(h_tonemanual,'Enable','off');
        set(h_tonelogspace,'Enable','off');
        set(h_noise,'Enable','on');
    end
    %
    set(myhandles.edit_rightonset,'String',Setting.RightOnset);
    set(myhandles.edit_rightduration,'String',Setting.RightDuration);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %SPL
    set(myhandles.edit_spl,'String',Setting.SPL);
    set(myhandles.radio_splleft,'Value',Setting.SPLLeft);
    set(myhandles.radio_splmean,'Value',Setting.SPLMean);
    set(myhandles.radio_splright,'Value',Setting.SPLRight);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %ILD
    set(myhandles.edit_ild,'String',Setting.ILD);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Total Duration
    set(myhandles.edit_totalduration,'String',Setting.TotalDuration);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Ramp Duration
    set(myhandles.edit_rampduration,'String',Setting.RampDuration);
    
end


% --------------------------------------------------------------------
function Setting = GetSetting
%Return the current settings
%

myh=findobj('Tag','fig_setild');
Setting=[];
if ~isempty(myh)
    myhandles=guihandles(myh);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Left
    Setting.LeftFlag=get(myhandles.check_left,'Value');
    %
    Setting.LeftToneManualFlag=get(myhandles.radio_lefttonemanual,'Value');
    Setting.LeftToneManualFreq=get(myhandles.edit_lefttonemanual,'String');
    %
    Setting.LeftToneLogSpaceFlag=get(myhandles.radio_lefttonelogspace,'Value');
    Setting.LeftToneLogSpaceFreqStart=get(myhandles.edit_lefttonelogspacestart,'String');
    Setting.LeftToneLogSpaceFreqEnd=get(myhandles.edit_lefttonelogspaceend,'String');
    Setting.LeftToneLogSpaceFreqStep=get(myhandles.edit_lefttonelogspacestep,'String');
    %
    Setting.Left.NoiseFlag=get(myhandles.radio_leftnoise,'Value');
    Setting.LeftNoisePassband=get(myhandles.edit_leftnoisepassband,'String');
    Setting.LeftNoiseFiltOrder=get(myhandles.edit_leftnoisefiltorder,'String');
    %
    Setting.LeftOnset=get(myhandles.edit_leftonset,'String');
    Setting.LeftDuration=get(myhandles.edit_leftduration,'String');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Right
    Setting.RightFlag=get(myhandles.check_right,'Value');
    %
    Setting.RightToneManualFlag=get(myhandles.radio_righttonemanual,'Value');
    Setting.RightToneManualFreq=get(myhandles.edit_righttonemanual,'String');
    %
    Setting.RightToneLogSpaceFlag=get(myhandles.radio_righttonelogspace,'Value');
    Setting.RightToneLogSpaceFreqStart=get(myhandles.edit_righttonelogspacestart,'String');
    Setting.RightToneLogSpaceFreqEnd=get(myhandles.edit_righttonelogspaceend,'String');
    Setting.RightToneLogSpaceFreqStep=get(myhandles.edit_righttonelogspacestep,'String');
    %
    Setting.Right.NoiseFlag=get(myhandles.radio_rightnoise,'Value');
    Setting.RightNoisePassband=get(myhandles.edit_rightnoisepassband,'String');
    Setting.RightNoiseFiltOrder=get(myhandles.edit_rightnoisefiltorder,'String');
    %
    Setting.RightOnset=get(myhandles.edit_rightonset,'String');
    Setting.RightDuration=get(myhandles.edit_rightduration,'String');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %SPL
    Setting.SPL=get(myhandles.edit_spl,'String');
    Setting.SPLLeft=get(myhandles.radio_splleft,'Value');
    Setting.SPLMean=get(myhandles.radio_splmean,'Value');
    Setting.SPLRight=get(myhandles.radio_splright,'Value');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %ILD
    Setting.ILD=get(myhandles.edit_ild,'String');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Total Duration
    Setting.TotalDuration=get(myhandles.edit_totalduration,'String');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Ramp Duration
    Setting.RampDuration=get(myhandles.edit_rampduration,'String');
end

%-------------------------------------------------------------%
% Enable/disable objects according to the check status for the left
% stimulus
function CheckLeft(handles)


myval=get(handles.check_left,'value');
h_left=[handles.frame_left handles.push_copyrightsetting ...
        handles.text_leftfrequency handles.frame_leftfrequency ...
        handles.text_leftdurationtitle handles.frame_leftduration ...
        handles.text_leftonset handles.edit_leftonset handles.text_leftonsetms ...
        handles.text_leftduration handles.edit_leftduration handles.text_leftdurationms];
h_leftradio=[handles.radio_lefttonemanual handles.edit_lefttonemanual handles.text_lefttonemanualhz ...
        handles.radio_lefttonelogspace handles.edit_lefttonelogspacestart ...
        handles.edit_lefttonelogspaceend handles.edit_lefttonelogspacestep ...
        handles.text_lefttonelogspacetild handles.text_lefttonelogspacehz ...
        handles.text_lefttonelogspaceoct ...
        handles.radio_leftnoise handles.edit_leftnoisepassband handles.text_leftnoisepassbandhz ...
        handles.edit_leftnoisefiltorder handles.text_leftnoisefiltorder];

if myval
    set([h_left h_leftradio],'Enable','on');
    
    %Set the toggle switches
    h_tonemanual=[handles.edit_lefttonemanual handles.text_lefttonemanualhz];
    h_tonelogspace=[handles.edit_lefttonelogspacestart handles.edit_lefttonelogspaceend handles.edit_lefttonelogspacestep ...
            handles.text_lefttonelogspacetild handles.text_lefttonelogspacehz handles.text_lefttonelogspaceoct];
    h_noise=[handles.edit_leftnoisepassband handles.text_leftnoisepassbandhz handles.edit_leftnoisefiltorder handles.text_leftnoisefiltorder];
    
    if get(handles.radio_lefttonemanual,'Value')
        %
        set(handles.radio_lefttonemanual,'Value',1);
        set(h_tonemanual,'Enable','on');
        %
        set(handles.radio_lefttonelogspace,'Value',0);
        set(h_tonelogspace,'Enable','off');
        %
        set(handles.radio_leftnoise,'Value',0);
        set(h_noise,'Enable','off');
        
    elseif get(handles.radio_lefttonelogspace,'Value')
        %
        set(h_tonemanual,'Enable','off');
        set(handles.radio_lefttonemanual,'Value',0);
        %
        set(h_tonelogspace,'Enable','on');
        set(handles.radio_lefttonelogspace,'Value',1);
        %
        set(handles.radio_leftnoise,'Value',0);
        set(h_noise,'Enable','off');
    else
        %
        set(handles.radio_lefttonemanual,'Value',0);
        set(h_tonemanual,'Enable','off');
        %
        set(handles.radio_lefttonelogspace,'Value',0);
        set(h_tonelogspace,'Enable','off');
        %
        set(handles.radio_leftnoise,'Value',1);
        set(h_noise,'Enable','on');
    end
    
else
    set([h_left h_leftradio],'Enable','off');
end

%-------------------------------------------------------------%
% Enable/disable objects according to the check status for the right
% stimulus
function CheckRight(handles)

myval=get(handles.check_right,'value');
h_right=[handles.frame_right handles.push_copyleftsetting ...
        handles.text_rightfrequency handles.frame_rightfrequency ...
        handles.text_rightdurationtitle handles.frame_rightduration ...
        handles.text_rightonset handles.edit_rightonset handles.text_rightonsetms ...
        handles.text_rightduration handles.edit_rightduration handles.text_rightdurationms];
h_rightradio=[handles.radio_righttonemanual handles.edit_righttonemanual handles.text_righttonemanualhz ...
        handles.radio_righttonelogspace handles.edit_righttonelogspacestart ...
        handles.edit_righttonelogspaceend handles.edit_righttonelogspacestep ...
        handles.text_righttonelogspacetild handles.text_righttonelogspacehz ...
        handles.text_righttonelogspaceoct ...
        handles.radio_rightnoise handles.edit_rightnoisepassband handles.text_rightnoisepassbandhz ...
        handles.edit_rightnoisefiltorder handles.text_rightnoisefiltorder];

if myval
    set([h_right h_rightradio],'Enable','on');
    
    %Set the toggle switches
    h_tonemanual=[handles.edit_righttonemanual handles.text_righttonemanualhz];
    h_tonelogspace=[handles.edit_righttonelogspacestart handles.edit_righttonelogspaceend handles.edit_righttonelogspacestep ...
            handles.text_righttonelogspacetild handles.text_righttonelogspacehz handles.text_righttonelogspaceoct];
    h_noise=[handles.edit_rightnoisepassband handles.text_rightnoisepassbandhz handles.edit_rightnoisefiltorder handles.text_rightnoisefiltorder];
    
    if get(handles.radio_righttonemanual,'Value')
        %
        set(handles.radio_righttonemanual,'Value',1);
        set(h_tonemanual,'Enable','on');
        %
        set(handles.radio_righttonelogspace,'Value',0);
        set(h_tonelogspace,'Enable','off');
        %
        set(handles.radio_rightnoise,'Value',0);
        set(h_noise,'Enable','off');
        
    elseif get(handles.radio_righttonelogspace,'Value')
        %
        set(h_tonemanual,'Enable','off');
        set(handles.radio_righttonemanual,'Value',0);
        %
        set(h_tonelogspace,'Enable','on');
        set(handles.radio_righttonelogspace,'Value',1);
        %
        set(handles.radio_rightnoise,'Value',0);
        set(h_noise,'Enable','off');
    else
        %
        set(handles.radio_righttonemanual,'Value',0);
        set(h_tonemanual,'Enable','off');
        %
        set(handles.radio_righttonelogspace,'Value',0);
        set(h_tonelogspace,'Enable','off');
        %
        set(handles.radio_rightnoise,'Value',1);
        set(h_noise,'Enable','on');
    end
    
else
    set([h_right h_rightradio],'Enable','off');
end


% --------------------------------------------------------------------
function varargout = MakeStimList(Setting)
%Parse the current settings and make the stim list
%
global STIM

%Flags for left/right channels
LRFlags=[Setting.LeftFlag; Setting.RightFlag];
if ~LRFlags(1) & ~LRFlags(2)
    error('At least one channels has to be used.');
end


%Left chan
if LRFlags(1)
    if Setting.LeftToneManualFlag
        freq=str2num(Setting.LeftToneManualFreq);
        n=length(freq);
        FreqL=[freq(:) zeros(n,2)];
    elseif Setting.LeftToneLogSpaceFlag
        freq1=str2num(Setting.LeftToneLogSpaceFreqStart);
        freq2=str2num(Setting.LeftToneLogSpaceFreqEnd);
        freq3=str2num(Setting.LeftToneLogSpaceFreqStep);
        if freq1>freq2 
            freq3=-freq3;
        end
        freq=log2(freq1):freq3:log2(freq2); %Equal step in log scale
        freq=2.^freq; %back to linear scale
        n=length(freq);
        FreqL=[freq(:) zeros(n,2)];
    else
        Passband=str2num(Setting.LeftNoisePassband);
        if size(Passband,2)~=2
            error('Left Chan: Invalid passband setting.');
        elseif any(Passband(:,1)==Passband(:,2))
            error('Left Chan: Identical Lo and Hi cut are not allowed.');
        else    
            Passband=sort(Passband,2);
        end
        n=size(Passband,1);    
        FiltOrder=str2num(Setting.LeftNoiseFiltOrder); %filter order
        if length(FiltOrder(:))~=1
            error('Left Chan: Invalid filter order setting.');
        elseif FiltOrder<=0 | floor(FiltOrder)~=FiltOrder
            error('Left Chan: Filter order must be a positive integer');
        end
        FreqL=[Passband ones(n,1)*FiltOrder];
    end
    OnsetDurationL=[str2num(Setting.LeftOnset) str2num(Setting.LeftDuration)];
else
    FreqL=[0 0 0];
    OnsetDurationL=[0 0];
end
NFreqL=size(FreqL,1);

%Right chan
if LRFlags(2)
    if Setting.RightToneManualFlag
        freq=str2num(Setting.RightToneManualFreq);
        n=length(freq);
        FreqR=[freq(:) zeros(n,2)];
    elseif Setting.RightToneLogSpaceFlag
        freq1=str2num(Setting.RightToneLogSpaceFreqStart);
        freq2=str2num(Setting.RightToneLogSpaceFreqEnd);
        freq3=str2num(Setting.RightToneLogSpaceFreqStep);
        if freq1>freq2 
            freq3=-freq3;
        end
        freq=log2(freq1):freq3:log2(freq2); %Equal step in log scale
        freq=2.^freq; %back to linear scale
        n=length(freq);
        FreqR=[freq(:) zeros(n,2)];
    else
        Passband=str2num(Setting.RightNoisePassband);
        if size(Passband,2)~=2
            error('Right Chan: Invalid passband setting.');
        elseif any(Passband(:,1)==Passband(:,2))
            error('Right Chan: Identical Lo and Hi cut are not allowed.');
        else    
            Passband=sort(Passband,2);
        end
        n=size(Passband,1);    
        FiltOrder=str2num(Setting.RightNoiseFiltOrder); %filter order
        if length(FiltOrder(:))~=1
            error('Right Chan: Invalid filter order setting.');
        elseif FiltOrder<=0 | floor(FiltOrder)~=FiltOrder
            error('Right Chan: Filter order must be a positive integer');
        end
        FreqR=[Passband ones(n,1)*FiltOrder];
    end
    OnsetDurationR=[str2num(Setting.RightOnset) str2num(Setting.RightDuration)];
else
    FreqR=[0 0 0];
    OnsetDurationR=[0 0];
end
NFreqR=size(FreqR,1);

%SPL
SPL=str2num(Setting.SPL);
NSPL=length(SPL);
SPL_LRM=0;
if Setting.SPLLeft %the SPL indicates left chan
    SPL_LRM=1;
elseif Setting.SPLRight %the SPL indicates right chan
    SPL_LRM=2;
else %the SPL indicates mean of the 2 chan
    SPL_LRM=0;
end
if ~LRFlags(1) & SPL_LRM==1;
    warndlg('SPL specified for the left chan, while the left chan is inactive. SPL will be interpreted as for the right chan.','Warning');
    SPL_LRM=2;
end
if ~LRFlags(2) & SPL_LRM==2;
    warndlg('SPL specified for the right chan, while the right chan is inactive. SPL will be interpreted as for the left chan.','Warning');
    SPL_LRM=1;
end

%ILD
ILD=str2num(Setting.ILD);
NILD=length(ILD);

%Total Duration
TotalDuration=str2num(Setting.TotalDuration);
if sum(OnsetDurationL)>TotalDuration
    error('Left Chan: Onset+Duration exceeds the total duration');
end
if sum(OnsetDurationR)>TotalDuration
    error('Right Chan: Onset+Duration exceeds the total duration');
end

%Ramp Duration
RampDuration=str2num(Setting.RampDuration);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NCond=NFreqL*NFreqR*NSPL*NILD;
NCol=6;
mySTIM=cell(NCond,NCol);
cnt=0;
for iFreqL=1:NFreqL
    myFreqL=FreqL(iFreqL,:);
    for iFreqR=1:NFreqR
        myFreqR=FreqR(iFreqR,:);
        for iSPL=1:NSPL
            mySPL=SPL(iSPL);
            for iILD=1:NILD
                myILD=ILD(iILD);
                cnt=cnt+1;
                mySTIM(cnt,:)={'ILD',num2str([myFreqL; myFreqR]),num2str([mySPL SPL_LRM]),num2str(myILD),...
                        num2str([OnsetDurationL; OnsetDurationR]),num2str([TotalDuration RampDuration])};
            end    
        end
    end
end

%Append to STIM
[nrow,ncol]=size(STIM);
d=ncol-NCol;
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes just before SetILD is made visible.
function SetILD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SetILD (see VARARGIN)

% Choose default command line output for SetILD
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SetILD wait for user response (see UIRESUME)
% uiwait(handles.fig_setild);


% --- Outputs from this function are returned to the command line.
function varargout = SetILD_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in check_left.
function check_left_Callback(hObject, eventdata, handles)
% hObject    handle to check_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_left

CheckLeft(handles);


% --- Executes on button press in radio_lefttonemanual.
function radio_lefttonemanual_Callback(hObject, eventdata, handles)
% hObject    handle to radio_lefttonemanual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_lefttonemanual

h_tonemanual=[handles.edit_lefttonemanual handles.text_lefttonemanualhz];
h_tonelogspace=[handles.edit_lefttonelogspacestart handles.edit_lefttonelogspaceend handles.edit_lefttonelogspacestep ...
        handles.text_lefttonelogspacetild handles.text_lefttonelogspacehz handles.text_lefttonelogspaceoct];
h_noise=[handles.edit_leftnoisepassband handles.text_leftnoisepassbandhz handles.edit_leftnoisefiltorder handles.text_leftnoisefiltorder];

set(handles.radio_lefttonemanual,'Value',1);
set(h_tonemanual,'Enable','on');
%
set(handles.radio_lefttonelogspace,'Value',0);
set(h_tonelogspace,'Enable','off');
%
set(handles.radio_leftnoise,'Value',0);
set(h_noise,'Enable','off');

% --- Executes on button press in radio_lefttonelogspace.
function radio_lefttonelogspace_Callback(hObject, eventdata, handles)
% hObject    handle to radio_lefttonelogspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_lefttonelogspace

h_tonemanual=[handles.edit_lefttonemanual handles.text_lefttonemanualhz];
h_tonelogspace=[handles.edit_lefttonelogspacestart handles.edit_lefttonelogspaceend handles.edit_lefttonelogspacestep ...
        handles.text_lefttonelogspacetild handles.text_lefttonelogspacehz handles.text_lefttonelogspaceoct];
h_noise=[handles.edit_leftnoisepassband handles.text_leftnoisepassbandhz handles.edit_leftnoisefiltorder handles.text_leftnoisefiltorder];

set(handles.radio_lefttonemanual,'Value',0);
set(h_tonemanual,'Enable','off');
%
set(handles.radio_lefttonelogspace,'Value',1);
set(h_tonelogspace,'Enable','on');
%
set(handles.radio_leftnoise,'Value',0);
set(h_noise,'Enable','off');


% --- Executes during object creation, after setting all properties.
function edit_lefttonemanual_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lefttonemanual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_lefttonemanual_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lefttonemanual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lefttonemanual as text
%        str2double(get(hObject,'String')) returns contents of edit_lefttonemanual as a double


% --- Executes during object creation, after setting all properties.
function edit_lefttonelogspacestart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lefttonelogspacestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_lefttonelogspacestart_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lefttonelogspacestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lefttonelogspacestart as text
%        str2double(get(hObject,'String')) returns contents of edit_lefttonelogspacestart as a double


% --- Executes during object creation, after setting all properties.
function edit_lefttonelogspaceend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lefttonelogspaceend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_lefttonelogspaceend_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lefttonelogspaceend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lefttonelogspaceend as text
%        str2double(get(hObject,'String')) returns contents of edit_lefttonelogspaceend as a double


% --- Executes during object creation, after setting all properties.
function edit_lefttonelogspacestep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lefttonelogspacestep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_lefttonelogspacestep_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lefttonelogspacestep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lefttonelogspacestep as text
%        str2double(get(hObject,'String')) returns contents of edit_lefttonelogspacestep as a double


% --- Executes during object creation, after setting all properties.
function edit_leftnoisepassband_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_leftnoisepassband (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_leftnoisepassband_Callback(hObject, eventdata, handles)
% hObject    handle to edit_leftnoisepassband (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_leftnoisepassband as text
%        str2double(get(hObject,'String')) returns contents of edit_leftnoisepassband as a double


% --- Executes during object creation, after setting all properties.
function edit_leftnoisefiltorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_leftnoisefiltorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_leftnoisefiltorder_Callback(hObject, eventdata, handles)
% hObject    handle to edit_leftnoisefiltorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_leftnoisefiltorder as text
%        str2double(get(hObject,'String')) returns contents of edit_leftnoisefiltorder as a double


% --- Executes on button press in radio_leftnoise.
function radio_leftnoise_Callback(hObject, eventdata, handles)
% hObject    handle to radio_leftnoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_leftnoise

h_tonemanual=[handles.edit_lefttonemanual handles.text_lefttonemanualhz];
h_tonelogspace=[handles.edit_lefttonelogspacestart handles.edit_lefttonelogspaceend handles.edit_lefttonelogspacestep ...
        handles.text_lefttonelogspacetild handles.text_lefttonelogspacehz handles.text_lefttonelogspaceoct];
h_noise=[handles.edit_leftnoisepassband handles.text_leftnoisepassbandhz handles.edit_leftnoisefiltorder handles.text_leftnoisefiltorder];

set(handles.radio_lefttonemanual,'Value',0);
set(h_tonemanual,'Enable','off');
%
set(handles.radio_lefttonelogspace,'Value',0);
set(h_tonelogspace,'Enable','off');
%
set(handles.radio_leftnoise,'Value',1);
set(h_noise,'Enable','on');


% --- Executes during object creation, after setting all properties.
function edit_leftonset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_leftonset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_leftonset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_leftonset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_leftonset as text
%        str2double(get(hObject,'String')) returns contents of edit_leftonset as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_leftduration (see GCBO)
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
% hObject    handle to edit_leftduration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_leftduration as text
%        str2double(get(hObject,'String')) returns contents of edit_leftduration as a double


% --- Executes during object creation, after setting all properties.
function edit_spl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_spl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_spl_Callback(hObject, eventdata, handles)
% hObject    handle to edit_spl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_spl as text
%        str2double(get(hObject,'String')) returns contents of edit_spl as a double


% --- Executes on button press in radio_splleft.
function radio_splleft_Callback(hObject, eventdata, handles)
% hObject    handle to radio_splleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_splleft

set(handles.radio_splleft,'value',1);
set(handles.radio_splmean,'value',0);
set(handles.radio_splright,'value',0);


% --- Executes on button press in radio_splmean.
function radio_splmean_Callback(hObject, eventdata, handles)
% hObject    handle to radio_splmean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_splmean

set(handles.radio_splleft,'value',0);
set(handles.radio_splmean,'value',1);
set(handles.radio_splright,'value',0);


% --- Executes on button press in radio_splright.
function radio_splright_Callback(hObject, eventdata, handles)
% hObject    handle to radio_splright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_splright

set(handles.radio_splleft,'value',0);
set(handles.radio_splmean,'value',0);
set(handles.radio_splright,'value',1);


% --- Executes during object creation, after setting all properties.
function edit_ild_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_ild_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ild as text
%        str2double(get(hObject,'String')) returns contents of edit_ild as a double


% --- Executes during object creation, after setting all properties.
function edit_totalduration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_totalduration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_totalduration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_totalduration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_totalduration as text
%        str2double(get(hObject,'String')) returns contents of edit_totalduration as a double


% --- Executes during object creation, after setting all properties.
function edit_rampduration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rampduration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_rampduration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rampduration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rampduration as text
%        str2double(get(hObject,'String')) returns contents of edit_rampduration as a double


% --- Executes on button press in push_cancel.
function push_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to push_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global STIM

%Update the number of conditions in the ExptMan
if ~isempty(findobj('tag','fig_exptman'))
    ExptMan('UpdateNCond'); 
end
if ~isempty(findobj('tag','fig_exptmanM'))
    ExptManM('UpdateNCond'); 
end


closereq %Close the window


% --- Executes on button press in push_appendandfinish.
function push_appendandfinish_Callback(hObject, eventdata, handles)
% hObject    handle to push_appendandfinish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the current setting
%Setting=SetFiles('GetSetting');
Setting=GetSetting;
MakeStimList(Setting);

%Position
Position=get(handles.fig_setild,'Position');

%Save the current setting
save SetILD Setting Position

closereq %Close the window


% --- Executes on button press in push_copyrightsetting.
function push_copyrightsetting_Callback(hObject, eventdata, handles)
% hObject    handle to push_copyrightsetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.edit_lefttonemanual,'string',get(handles.edit_righttonemanual,'string'));
set(handles.edit_lefttonelogspacestart,'string',get(handles.edit_righttonelogspacestart,'string'));
set(handles.edit_lefttonelogspaceend,'string',get(handles.edit_righttonelogspaceend,'string'));
set(handles.edit_lefttonelogspacestep,'string',get(handles.edit_righttonelogspacestep,'string'));
set(handles.edit_leftnoisepassband,'string',get(handles.edit_rightnoisepassband,'string'));
set(handles.edit_leftnoisefiltorder,'string',get(handles.edit_rightnoisefiltorder,'string'));
set(handles.edit_leftonset,'string',get(handles.edit_rightonset,'string'));
set(handles.edit_leftduration,'string',get(handles.edit_rightduration,'string'));

% --- Executes on button press in check_right.
function check_right_Callback(hObject, eventdata, handles)
% hObject    handle to check_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_right

CheckRight(handles);

% --- Executes on button press in radio_righttonemanual.
function radio_righttonemanual_Callback(hObject, eventdata, handles)
% hObject    handle to radio_righttonemanual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_righttonemanual

h_tonemanual=[handles.edit_righttonemanual handles.text_righttonemanualhz];
h_tonelogspace=[handles.edit_righttonelogspacestart handles.edit_righttonelogspaceend handles.edit_righttonelogspacestep ...
        handles.text_righttonelogspacetild handles.text_righttonelogspacehz handles.text_righttonelogspaceoct];
h_noise=[handles.edit_rightnoisepassband handles.text_rightnoisepassbandhz handles.edit_rightnoisefiltorder handles.text_rightnoisefiltorder];

set(handles.radio_righttonemanual,'Value',1);
set(h_tonemanual,'Enable','on');
%
set(handles.radio_righttonelogspace,'Value',0);
set(h_tonelogspace,'Enable','off');
%
set(handles.radio_rightnoise,'Value',0);
set(h_noise,'Enable','off');

% --- Executes on button press in radio_righttonelogspace.
function radio_righttonelogspace_Callback(hObject, eventdata, handles)
% hObject    handle to radio_righttonelogspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_righttonelogspace

h_tonemanual=[handles.edit_righttonemanual handles.text_righttonemanualhz];
h_tonelogspace=[handles.edit_righttonelogspacestart handles.edit_righttonelogspaceend handles.edit_righttonelogspacestep ...
        handles.text_righttonelogspacetild handles.text_righttonelogspacehz handles.text_righttonelogspaceoct];
h_noise=[handles.edit_rightnoisepassband handles.text_rightnoisepassbandhz handles.edit_rightnoisefiltorder handles.text_rightnoisefiltorder];

%
set(handles.radio_righttonemanual,'Value',0);
set(h_tonemanual,'Enable','off');
%
set(handles.radio_righttonelogspace,'Value',1);
set(h_tonelogspace,'Enable','on');
%
set(handles.radio_rightnoise,'Value',0);
set(h_noise,'Enable','off');


% --- Executes during object creation, after setting all properties.
function edit_righttonemanual_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_righttonemanual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_righttonemanual_Callback(hObject, eventdata, handles)
% hObject    handle to edit_righttonemanual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_righttonemanual as text
%        str2double(get(hObject,'String')) returns contents of edit_righttonemanual as a double


% --- Executes during object creation, after setting all properties.
function edit_righttonelogspacestart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_righttonelogspacestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_righttonelogspacestart_Callback(hObject, eventdata, handles)
% hObject    handle to edit_righttonelogspacestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_righttonelogspacestart as text
%        str2double(get(hObject,'String')) returns contents of edit_righttonelogspacestart as a double


% --- Executes during object creation, after setting all properties.
function edit_righttonelogspaceend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_righttonelogspaceend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_righttonelogspaceend_Callback(hObject, eventdata, handles)
% hObject    handle to edit_righttonelogspaceend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_righttonelogspaceend as text
%        str2double(get(hObject,'String')) returns contents of edit_righttonelogspaceend as a double


% --- Executes during object creation, after setting all properties.
function edit_righttonelogspacestep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_righttonelogspacestep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_righttonelogspacestep_Callback(hObject, eventdata, handles)
% hObject    handle to edit_righttonelogspacestep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_righttonelogspacestep as text
%        str2double(get(hObject,'String')) returns contents of edit_righttonelogspacestep as a double


% --- Executes during object creation, after setting all properties.
function edit_rightnoisepassband_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rightnoisepassband (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_rightnoisepassband_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rightnoisepassband (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rightnoisepassband as text
%        str2double(get(hObject,'String')) returns contents of edit_rightnoisepassband as a double


% --- Executes during object creation, after setting all properties.
function edit_rightnoisefiltorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rightnoisefiltorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_rightnoisefiltorder_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rightnoisefiltorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rightnoisefiltorder as text
%        str2double(get(hObject,'String')) returns contents of edit_rightnoisefiltorder as a double


% --- Executes on button press in radio_rightnoise.
function radio_rightnoise_Callback(hObject, eventdata, handles)
% hObject    handle to radio_rightnoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_rightnoise

h_tonemanual=[handles.edit_righttonemanual handles.text_righttonemanualhz];
h_tonelogspace=[handles.edit_righttonelogspacestart handles.edit_righttonelogspaceend handles.edit_righttonelogspacestep ...
        handles.text_righttonelogspacetild handles.text_righttonelogspacehz handles.text_righttonelogspaceoct];
h_noise=[handles.edit_rightnoisepassband handles.text_rightnoisepassbandhz handles.edit_rightnoisefiltorder handles.text_rightnoisefiltorder];

%
set(handles.radio_righttonemanual,'Value',0);
set(h_tonemanual,'Enable','off');
%
set(handles.radio_righttonelogspace,'Value',0);
set(h_tonelogspace,'Enable','off');
%
set(handles.radio_rightnoise,'Value',1);
set(h_noise,'Enable','on');


% --- Executes during object creation, after setting all properties.
function edit_rightonset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rightonset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_rightonset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rightonset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rightonset as text
%        str2double(get(hObject,'String')) returns contents of edit_rightonset as a double


% --- Executes during object creation, after setting all properties.
function edit_rightduration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rightduration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_rightduration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rightduration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rightduration as text
%        str2double(get(hObject,'String')) returns contents of edit_rightduration as a double


% --- Executes on button press in push_copyleftsetting.
function push_copyleftsetting_Callback(hObject, eventdata, handles)
% hObject    handle to push_copyleftsetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.edit_righttonemanual,'string',get(handles.edit_lefttonemanual,'string'));
set(handles.edit_righttonelogspacestart,'string',get(handles.edit_lefttonelogspacestart,'string'));
set(handles.edit_righttonelogspaceend,'string',get(handles.edit_lefttonelogspaceend,'string'));
set(handles.edit_righttonelogspacestep,'string',get(handles.edit_lefttonelogspacestep,'string'));
set(handles.edit_rightnoisepassband,'string',get(handles.edit_leftnoisepassband,'string'));
set(handles.edit_rightnoisefiltorder,'string',get(handles.edit_leftnoisefiltorder,'string'));
set(handles.edit_rightonset,'string',get(handles.edit_leftonset,'string'));
set(handles.edit_rightduration,'string',get(handles.edit_leftduration,'string'));



% --- Executes during object creation, after setting all properties.
function edit_leftduration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_leftduration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_leftduration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_leftduration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_leftduration as text
%        str2double(get(hObject,'String')) returns contents of edit_leftduration as a double


