function varargout = SampleRateTDT(varargin)
% SAMPLERATETDT M-file for SampleRateTDT.fig
%      SAMPLERATETDT, by itself, creates a new SAMPLERATETDT or raises the existing
%      singleton*.
%
%      H = SAMPLERATETDT returns the handle to a new SAMPLERATETDT or the handle to
%      the existing singleton*.
%
%      SAMPLERATETDT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLERATETDT.M with the given input arguments.
%
%      SAMPLERATETDT('Property','Value',...) creates a new SAMPLERATETDT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SampleRateTDT_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SampleRateTDT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SampleRateTDT

% Last Modified by GUIDE v2.5 05-Mar-2003 16:11:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SampleRateTDT_OpeningFcn, ...
                   'gui_OutputFcn',  @SampleRateTDT_OutputFcn, ...
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


% --- Executes just before SampleRateTDT is made visible.
function SampleRateTDT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SampleRateTDT (see VARARGIN)

% Choose default command line output for SampleRateTDT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SampleRateTDT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SampleRateTDT_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radio_rp2_0.
function radio_rp2_0_Callback(hObject, eventdata, handles)
% hObject    handle to radio_rp2_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_rp2_0
set(hObject,'Value',1);
myh=[handles.radio_rp2_1 handles.radio_rp2_2 handles.radio_rp2_3 handles.radio_rp2_4 handles.radio_rp2_5];
set(myh,'Value',0);


% --- Executes on button press in radio_rp2_1.
function radio_rp2_1_Callback(hObject, eventdata, handles)
% hObject    handle to radio_rp2_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_rp2_1
set(hObject,'Value',1);
myh=[handles.radio_rp2_0 handles.radio_rp2_1 handles.radio_rp2_3 handles.radio_rp2_4 handles.radio_rp2_5];
set(myh,'Value',0);


% --- Executes on button press in radio_rp2_2.
function radio_rp2_2_Callback(hObject, eventdata, handles)
% hObject    handle to radio_rp2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_rp2_2
set(hObject,'Value',1);
myh=[handles.radio_rp2_0 handles.radio_rp2_1 handles.radio_rp2_3 handles.radio_rp2_4 handles.radio_rp2_5];
set(myh,'Value',0);


% --- Executes on button press in radio_rp2_3.
function radio_rp2_3_Callback(hObject, eventdata, handles)
% hObject    handle to radio_rp2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_rp2_3
set(hObject,'Value',1);
myh=[handles.radio_rp2_0 handles.radio_rp2_1 handles.radio_rp2_2 handles.radio_rp2_4 handles.radio_rp2_5];
set(myh,'Value',0);


% --- Executes on button press in radio_rp2_4.
function radio_rp2_4_Callback(hObject, eventdata, handles)
% hObject    handle to radio_rp2_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_rp2_4
set(hObject,'Value',1);
myh=[handles.radio_rp2_0 handles.radio_rp2_1 handles.radio_rp2_2 handles.radio_rp2_3 handles.radio_rp2_5];
set(myh,'Value',0);


% --- Executes on button press in radio_rp2_5.
function radio_rp2_5_Callback(hObject, eventdata, handles)
% hObject    handle to radio_rp2_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_rp2_5
set(hObject,'Value',1);
myh=[handles.radio_rp2_0 handles.radio_rp2_1 handles.radio_rp2_2 handles.radio_rp2_3 handles.radio_rp2_4];
set(myh,'Value',0);


% --- Executes on button press in radio_ra16_0.
function radio_ra16_0_Callback(hObject, eventdata, handles)
% hObject    handle to radio_ra16_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_ra16_0
set(hObject,'Value',1);
myh=[handles.radio_ra16_1 handles.radio_ra16_2 handles.radio_ra16_3];
set(myh,'Value',0);


% --- Executes on button press in radio_ra16_1.
function radio_ra16_1_Callback(hObject, eventdata, handles)
% hObject    handle to radio_ra16_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_ra16_1
set(hObject,'Value',1);
myh=[handles.radio_ra16_0 handles.radio_ra16_2 handles.radio_ra16_3];
set(myh,'Value',0);


% --- Executes on button press in radio_ra16_2.
function radio_ra16_2_Callback(hObject, eventdata, handles)
% hObject    handle to radio_ra16_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_ra16_2
set(hObject,'Value',1);
myh=[handles.radio_ra16_0 handles.radio_ra16_1 handles.radio_ra16_3];
set(myh,'Value',0);


% --- Executes on button press in radio_ra16_3.
function radio_ra16_3_Callback(hObject, eventdata, handles)
% hObject    handle to radio_ra16_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_ra16_3
set(hObject,'Value',1);
myh=[handles.radio_ra16_0 handles.radio_ra16_1 handles.radio_ra16_2];
set(myh,'Value',0);

% --- Executes on button press in push_ok.
function push_ok_Callback(hObject, eventdata, handles)
% hObject    handle to push_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global IdxFsRP2 IdxFsRA16

IdxFsRP2=NaN;
for ii=0:5
    mytag=['radio_rp2_' num2str(ii)];
    if get(findobj(gcf,'tag',mytag),'Value')
        IdxFsRP2=ii;
        break;
    end
end
IdxFsRA16=NaN;
for ii=0:3
    mytag=['radio_ra16_' num2str(ii)];
    if get(findobj(gcf,'tag',mytag),'Value')
        IdxFsRA16=ii;
        break;
    end
end
closereq;

% --- Executes on button press in push_cancel.
function push_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to push_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IdxFsRP2 IdxFsRA16

IdxFsRP2=NaN;
IdxFsRA16=NaN;

closereq %Close the window

