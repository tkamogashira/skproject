function varargout = dspAudioPosGui(varargin)

%   Copyright 2007-2011 The MathWorks, Inc.

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @dspAudioPosGui_OpeningFcn, ...
    'gui_OutputFcn',  @dspAudioPosGui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end

% --- Executes just before dspAudioPosGui is made visible.
function dspAudioPosGui_OpeningFcn(hObject, eventdata, handles, varargin)

% Get the position input
if length(varargin) >= 1
    if(length(varargin{1}) ~= 2 || ...
            ~isnumeric(varargin{1}))
        error(message('dsp:dspAudioPosGui:invalidInput1'));
    end
    handles.sourceLoc = varargin{1};
else
    handles.sourceLoc = [-.5 .5];    
end

% Get the setter, if one is supplied
if length(varargin) == 3
    if ~isa(varargin{3}, 'function_handle')
        error(message('dsp:dspAudioPosGui:invalidInput2'));
    end
    handles.block     = varargin{2};
    handles.setter    = varargin{3};
else
    handles.block  = [];
    handles.setter = [];
end

handles.output   = handles.sourceLoc;
handles.dragging = false;

% Draw the unit circle
clr = [0.3922 0.5882 0.7059];
t = linspace(0, 2*pi, 100);
h = patch(cos(t), sin(t), clr, 'parent', handles.axes);
set(h, 'hittest', 'off');

% Create an axes for initial display of images
a = axes;

% Draw the speakers
wid = 0.28;
I = imread('speaker.jpg');
h = image([0 1], [0 1], I, 'parent', a);
set(h, 'parent', handles.axes);
set(h, 'xdata', [-1 -1+wid], 'ydata', [1 1-wid]);
h = copyobj(h,handles.axes);
set(h, 'xdata', [-1 -1+wid], 'ydata', [-1+wid -1]);
h = copyobj(h,handles.axes);
set(h, 'xdata', [1-wid 1], 'ydata', [1 1-wid]);
h = copyobj(h,handles.axes);
set(h, 'xdata', [1-wid 1], 'ydata', [-1+wid -1]);
h = copyobj(h,handles.axes);
set(h, 'xdata', [-wid/2 wid/2], 'ydata', [1+wid 1]);

% Draw the stick figure
legs = [-.1 -.1; 0 0; .1 -.1];
h(1) = line(legs(:,1), legs(:,2)-.05,...
    'color', [0,0,0], 'linewidth',2, 'parent',handles.axes);
arms = [-.1 .1; 0 0; .1 .1];
h(2) = line(arms(:,1), arms(:,2)+.05,...
    'color', [0,0,0], 'linewidth',2, 'parent',handles.axes);
body = [0 -.05; 0 .10];
h(3) = line(body(:,1), body(:,2),...
    'color', [0,0,0], 'linewidth',2, 'parent',handles.axes);
head = [cos(t)' sin(t)'];
h(4) = line(head(:,1)*0.03, head(:,2)*0.03 + 0.13,...
    'color', [0,0,0], 'linewidth',2, 'parent',handles.axes);

% Draw the helicopter
I = imread('helicopter.jpg');
handles.source = image([-0.28 0.28], [0.10 -0.10], I, 'parent', a);
set(handles.source, 'parent', handles.axes);

% delete axes for images
delete(a);

% Set the helcopter position
updateHelicopterPosition(handles, true);

% Update handles structure
guidata(hObject, handles);

% wait for user response
if isempty(handles.setter)
    uiwait(handles.figure1);
end
end

% --- Outputs from this function are returned to the command line.
function varargout = dspAudioPosGui_OutputFcn(hObject, eventdata, handles)
    if isempty(handles.setter)
        varargout{1} = handles.output;
        delete(handles.figure1);
    else
        % Return the handle so that it can be closed by the model.
        varargout{1} = handles.figure1;
    end
end

function windowClose(hObject, eventdata, handles)
    handles.output = handles.sourceLoc;
    guidata(hObject, handles);
    if isempty(handles.setter)
        uiresume(handles.figure1);
    else
        delete(handles.figure1);
    end
end

function buttonDown(hObject, eventdata, handles)
    updateHelicopterPosition(handles)
end

function windowButtonDown(hObject, eventdata, handles)
    handles.dragging = 1;
    guidata(hObject, handles);
end

function windowButtonMotion(hObject, eventdata, handles)
persistent lasttime
if isempty(lasttime)
    lasttime = now;
end

% 1/20 of a second between calls
callAgain = now - lasttime > 1/24 * 1/60 * 1/60 * 1/20;

if callAgain && handles.dragging
    lasttime = now;
    updateHelicopterPosition(handles);
end
end

function windowButtonUp(hObject, eventdata, handles)
handles.dragging = false;
guidata(hObject, handles);
end

function updateHelicopterPosition(handles, firstCall)
    coord(1:2) = get(handles.source, 'Xdata');
    coord(3:4) = get(handles.source, 'Ydata');
    pos = [coord(2)-coord(1) coord(3)-coord(4)]/2;
    if(nargin < 2)
        tmp = get(gca, 'CurrentPoint');
        handles.sourceLoc = tmp([1 3]);
    end
    if norm(handles.sourceLoc) > 1
        handles.sourceLoc = handles.sourceLoc / norm(handles.sourceLoc);
    end
    set(handles.source, 'Xdata', handles.sourceLoc(1) + pos(1)*[-1 1]);
    set(handles.source, 'Ydata', handles.sourceLoc(2) + pos(2)*[1 -1]);
    if ~isempty(handles.setter)
        handles.setter(handles.block, mat2str(handles.sourceLoc));
    end
    guidata(handles.figure1, handles);
end

