function varargout = HorizontalBar(varargin)

% HORIZONTALBAR M-file for HorizontalBar.fig
%      HORIZONTALBAR, by itself, creates a new HORIZONTALBAR or raises the existing
%      singleton*.
%
%      H = HORIZONTALBAR returns the handle to a new HORIZONTALBAR or the handle to
%      the existing singleton*.
%
%      HORIZONTALBAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HORIZONTALBAR.M with the given input arguments.
%
%      HORIZONTALBAR('Property','Value',...) creates a new HORIZONTALBAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HorizontalBar_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HorizontalBar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HorizontalBar

% Last Modified by GUIDE v2.5 22-Oct-2007 18:05:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HorizontalBar_OpeningFcn, ...
                   'gui_OutputFcn',  @HorizontalBar_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before HorizontalBar is made visible.
function HorizontalBar_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HorizontalBar (see VARARGIN)

% Choose default command line output for HorizontalBar
if nargin ==0
    handles.Angle=0;
else
    handles.Angle=varargin{1};
end
handles.output = handles.Angle;

% Update handles structure
guidata(hObject, handles);

set(hObject,'Position',[34 -2 100 50]);
% This sets up the initial plot - only do when we are invisible
% so window can get raised using HorizontalBar.

if strcmp(get(hObject,'Visible'),'off')
    x=cos(2*pi*handles.Angle/360);y=sin(2*pi*handles.Angle/360);
    X=x*[-1.5 -1.25 -1 -.75 -.5 -.25 0 .25 .5 .75 1 1.25 1.5];
    Y=y*[-1.5 -1.25 -1 -.75 -.5 -.25 0 .25 .5 .75 1 1.25 1.5];
    plot(X,Y,'ro');axis([-2 2 -2 2]);axis equal;
    set(gca,'Color',[0 0 0]);
   
    grid off
end

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
% UIWAIT makes HorizontalBar wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HorizontalBar_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% The figure can be deleted now
delete(handles.figure1);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)




% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UserInput=get(hObject,'CurrentKey');
Step=0.2;
switch UserInput
    case 'numpad6'

        handles.Angle=handles.Angle-Step;
        guidata(hObject,handles)
        x=cos(2*pi*handles.Angle/360);y=sin(2*pi*handles.Angle/360);
        X=x*[-1.5 -1.25 -1 -.75 -.5 -.25 0 .25 .5 .75 1 1.25 1.5];
        Y=y*[-1.5 -1.25 -1 -.75 -.5 -.25 0 .25 .5 .75 1 1.25 1.5];
        plot(X,Y,'ro');axis([-2 2 -2 2]);axis equal;
        set(gca,'Color',[0 0 0]);
    case 'numpad4'
        handles.Angle=handles.Angle+Step;
        guidata(hObject,handles)
        x=cos(2*pi*handles.Angle/360);y=sin(2*pi*handles.Angle/360);
        X=x*[-1.5 -1.25 -1 -.75 -.5 -.25 0 .25 .5 .75 1 1.25 1.5];
        Y=y*[-1.5 -1.25 -1 -.75 -.5 -.25 0 .25 .5 .75 1 1.25 1.5];
        plot(X,Y,'ro');axis([-2 2 -2 2]);axis equal;
        set(gca,'Color',[0 0 0]);
    case 'return'
        handles.Angle
        handles.output=handles.Angle;
        guidata(hObject,handles);
        % Use UIRESUME instead of delete because the OutputFcn needs

        % to get the updated handles structure.
        uiresume(handles.figure1);
end

