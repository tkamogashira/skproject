function varargout = SetFiles(varargin)
% SETFILES M-file for SetFiles.fig
%      SETFILES, by itself, creates a new SETFILES or raises the existing
%      singleton*.
%
%      H = SETFILES returns the handle to a new SETFILES or the handle to
%      the existing singleton*.
%
%      SETFILES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETFILES.M with the given input arguments.
%
%      SETFILES('Property','Value',...) creates a new SETFILES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SetFiles_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SetFiles_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SetFiles

% Last Modified by GUIDE v2.5 12-Dec-2002 18:27:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SetFiles_OpeningFcn, ...
                   'gui_OutputFcn',  @SetFiles_OutputFcn, ...
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
    myh=findobj('Tag','fig_setfiles');
    
    %Use the settings used previously
    if exist('SetFiles.mat','file')==2
        load('SetFiles') %Load the settings
        
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


%-------------------------------------------------------------%
function varargout = SetSetting(Setting)
%Set the current settings
%

myh=findobj('Tag','fig_setfiles');
if ~isempty(myh) & ~isempty(Setting)
    myhandles=guihandles(myh);
    
    %Pathname
    set(myhandles.text_pathname,'String',Setting.PathName);
    
    %Filenames
    set(myhandles.list_filenames,'String',Setting.FileNames);
    SetFiles('NofFiles');

    %Silence period
    set(myhandles.edit_silence1,'String',Setting.Silence1);
    set(myhandles.edit_silence2,'String',Setting.Silence2);

    %SPL
    set(myhandles.edit_spl,'String',Setting.SPL);
    
    %Radio buttons
    set(myhandles.radio_minspl,'Value',Setting.MinMedMax(1));
    set(myhandles.radio_medspl,'Value',Setting.MinMedMax(2));
    set(myhandles.radio_maxspl,'Value',Setting.MinMedMax(3));
end
NofFiles


% --------------------------------------------------------------------
function Setting = GetSetting
%Return the current settings
%

myh=findobj('Tag','fig_setfiles');
Setting=[];
if ~isempty(myh)
    myhandles=guihandles(myh);
    
    %Pathname
    Setting.PathName=get(myhandles.text_pathname,'String');
        
    %Filenames
    Setting.FileNames=get(myhandles.list_filenames,'String');
    
    %Silence period
    Setting.Silence1=get(myhandles.edit_silence1,'String');
    Setting.Silence2=get(myhandles.edit_silence2,'String');
    
    %SPL
    Setting.SPL=get(myhandles.edit_spl,'String');

    Setting.MinMedMax=zeros(3,1);
    %Radio buttons
    if get(myhandles.radio_minspl,'Value')
        Setting.MinMedMax(1)=1;
    elseif get(myhandles.radio_medspl,'Value')
        Setting.MinMedMax(2)=1;
    else
        Setting.MinMedMax(3)=1;
    end
end


%-------------------------------------------------------------%
function varargout = NofFiles
%Update the number of files specified

myh=findobj('Tag','fig_setfiles');
if ~isempty(myh)
    myhandles=guihandles(myh);
    mystr=get(myhandles.list_filenames,'String');
    if iscell(mystr)
        NFiles=length(mystr);
        set(myhandles.text_nooffiles,'String',num2str(NFiles));
    end
end

% --------------------------------------------------------------------
function varargout = MakeStimList(Setting)
%Parse the current settings and make the stim list
%
global STIM

%Filenames
NFiles=length(Setting.FileNames);

%Silence period
Silence1=str2num(Setting.Silence1);
if isempty(Silence1)
    Silence1=0;
end
Silence2=str2num(Setting.Silence2);
if isempty(Silence2)
    Silence2=0;
end
Silence=[Silence1(1) Silence2(1)];

%SPL
SPL=str2num(Setting.SPL);
if isempty(SPL)
    error('Invalid SPL setting.');
end
if any(SPL>100)
    myh=warndlg('>100dB SPL is included','Warning');
    uiwait(myh);
end
NSPL=length(SPL);

if Setting.MinMedMax(1)
    MinMedMax='Min';
elseif Setting.MinMedMax(2)
    MinMedMax='Med';
else
    MinMedMax='Max';
end    
 
%
NCond=NFiles*NSPL;
mySTIM=cell(NCond,6);
cnt=0;
for iFiles=1:NFiles
    myFile=Setting.FileNames;
    for iSPL=1:NSPL
      cnt=cnt+1;
      mySTIM(cnt,:)={'Files',Setting.PathName,Setting.FileNames{iFiles},num2str(Silence),num2str(SPL(iSPL)),MinMedMax};
    end
end

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



%%%%%%%%%%%%% Parse the current settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes just before SetFiles is made visible.
function SetFiles_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SetFiles (see VARARGIN)

% Choose default command line output for SetFiles
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SetFiles wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SetFiles_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function list_filenames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_filenames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in list_filenames.
function list_filenames_Callback(hObject, eventdata, handles)
% hObject    handle to list_filenames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns list_filenames contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_filenames


% --- Executes on button press in push_openfiles.
function push_openfiles_Callback(hObject, eventdata, handles)
% hObject    handle to push_openfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% mypath=get(findobj('Tag','text_pathname'),'String');
% origpath=pwd;
% if exist(mypath,'dir')==7
%     cd (mypath);
% end
[FileNames, PathName]=uigetfiles('*.wav','Select Wave files');
if ~isempty(FileNames)
    set(handles.text_pathname,'String',PathName);
    set(handles.list_filenames,'String',FileNames);
end
% cd(origpath);

NofFiles;


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in push_append.
function push_append_Callback(hObject, eventdata, handles)
% hObject    handle to push_append (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the current setting
%Setting=SetFiles('GetSetting');
Setting=GetSetting;
MakeStimList(Setting);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in push_finish.
function push_finish_Callback(hObject, eventdata, handles)
% hObject    handle to push_finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get the current setting
%Setting=SetFiles('GetSetting');
Setting=GetSetting;
MakeStimList(Setting);

%Save the current setting
save SetFiles Setting

closereq %Close the window


% --- Executes on button press in radio_minspl.
function radio_minspl_Callback(hObject, eventdata, handles)
% hObject    handle to radio_minspl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

state= get(hObject,'Value'); % toggle state of radio_minspl
if state
    set(handles.radio_medspl,'Value',0);
    set(handles.radio_maxspl,'Value',0);
end   

% --- Executes on button press in radio_medspl.
function radio_medspl_Callback(hObject, eventdata, handles)
% hObject    handle to radio_medspl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

state= get(hObject,'Value'); %returns toggle state of radio_medspl
if state
    set(handles.radio_minspl,'Value',0);
    set(handles.radio_maxspl,'Value',0);
end   


% --- Executes on button press in radio_maxspl.
function radio_maxspl_Callback(hObject, eventdata, handles)
% hObject    handle to radio_maxspl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

state= get(hObject,'Value'); %returns toggle state of radio_maxspl
if state
    set(handles.radio_minspl,'Value',0);
    set(handles.radio_medspl,'Value',0);
end   


% --- Executes during object creation, after setting all properties.
function edit_silence1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_silence1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_silence1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_silence1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_silence1 as text
%        str2double(get(hObject,'String')) returns contents of edit_silence1 as a double


% --- Executes during object creation, after setting all properties.
function edit_silence2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_silence2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_silence2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_silence2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_silence2 as text
%        str2double(get(hObject,'String')) returns contents of edit_silence2 as a double


% --- Executes on button press in radio_medspl.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radio_medspl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_medspl


% --- Executes on button press in radio_maxspl.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radio_maxspl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_maxspl


