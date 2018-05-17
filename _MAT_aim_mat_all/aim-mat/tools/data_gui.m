% support file for 'aim-mat'
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function varargout = data_gui(varargin)
% allow some nice action with a gui.
% Example: try:
%     function plot_psth(data,options)
%     options.startms=0;
%     options.duration=data.expparams.spike_window_end_ms;
%     options.binwidth=1;
%     options.info.buttontext={'plot psth','save as ascii'};
%     options.info.data=data;
%     options.info.title='psth parameter';
%     options.info.callback={'plot_psth(data,options,''plot'')','plot_psth(data,options,''save_as_ascii'')'};
%     out.handle=data_gui(options);
%     

% Begin initialization code - DO NOT EDIT

% find out, if we want a new window or the old one:
if length(varargin)==1
    gui_Singleton = 0;  % normally we want a new window
    all_childs=get(0,'children');
    this_name=varargin{1}.info.title;
    for i=1:length(all_childs)
        name=get(all_childs(i),'name');
        if strcmp(name,this_name)
            gui_Singleton = 1; % but if there is a copy already, take that window instead
            % and bring it to the front
            figure(all_childs(i));
        end
    end
else
    gui_Singleton = 1; % but if there is a copy already, take that window instead
end    

gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @data_gui_OpeningFcn, ...
    'gui_OutputFcn',  @data_gui_OutputFcn, ...
    'gui_LayoutFcn',  @data_gui_LayoutFcn, ...
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


% --- Executes just before data_gui is made visible.
function data_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data_gui (see VARARGIN)

% Choose default command line output for data_gui
handles.output = hObject;


% copy the options in place
options=varargin{1};
handles.options=options;

% Update handles structure
guidata(hObject, handles);

global result;
% UIWAIT makes data_gui wait for user response (see UIRESUME)

if ~isfield(options.info,'default_value')
    result=''; % not determined yet
else
    result=options.info.default_value;
end

if isfield(options.info,'mode') && strcmp(options.info.mode,'modal')
    uiwait(handles.figure1);
end




% --- Outputs from this function are returned to the command line.
function varargout = data_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global result;
varargout{1} = result;


% --- Executes on button press in pushbutton1.
function pushbuttons_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
options=handles.options;


if iscell(handles.options.info.buttontext)
    nr_buttons=length(handles.options.info.buttontext);
else
    nr_buttons=1;
end
for ii=1:nr_buttons
    pushtag=sprintf('pushbutton%d',ii);
    handstr=sprintf('hand=handles.%s;',pushtag);
    eval(handstr);
    if hObject==hand;
        buttonnumber=ii;
        break;
    end
end
% dispatch all data values to the options structure

options=handles.options;
% radiobuttons=options.toggleradiobuttons;
% nr_but=length(radiobuttons);
nr_hands=length(fields(handles));
all_fields=fields(handles);
% set all to 0
linecount=1;
params=fields(options);
nr_params=length(params);

params=fields(options);
nr_params=length(params);
linecount=1;

for i=1:nr_params % look through all parameter  and find the assoziated handle for it
    if ~strcmp(params(i),'info')
        for j=1:nr_hands % go through all handles. One must be it
            curhand=getfield(handles,all_fields{j});
            if ishandle(curhand)
                fieldname=all_fields{j};
                allfi=get(curhand);
                if isfield(allfi,'Style') && strcmp(get(curhand,'Style'),'edit')
                    fieldvalue=get(curhand,'String');
                    val=str2num(fieldvalue{1});
                    stuctname=get(curhand,'userdata');
                    if isnumeric(val) && ~isempty(val)
                        options=setfield(options,stuctname,val);
                    else
                        options=setfield(options,stuctname,fieldvalue{1});
                    end    
                    linecount=linecount+1;
                elseif isfield(allfi,'Style') && strcmp(get(curhand,'Style'),'radiobutton')
                    val=get(curhand,'value');
                    nr=get(curhand,'Userdata');
                    options.toggleradiobuttons{nr}.value=val;
                elseif isfield(allfi,'Style') && strcmp(get(curhand,'Style'),'checkbox')
                    val=get(curhand,'value');
                    nr=get(curhand,'Userdata');
                    options.checkboxes{nr}.value=val;
                end
            end
        end
    end
end


data=options.info.data;
if nr_buttons==1
    callline=sprintf('%s;',options.info.callback);
else
    callline=sprintf('%s;',options.info.callback{buttonnumber});
end
eval(callline);

% does the function give back a value?
gleichwo=strfind(callline,'=');
if ~isempty(gleichwo)
    retvar=callline(1:gleichwo-1);
    global result;
    resstr=sprintf('result=%s;',retvar);
    eval(resstr);
end


function togglebuttons_Callback(hObject, eventdata, handles)
if get(hObject,'value')==0
    return
end
options=handles.options;
radiobuttons=options.toggleradiobuttons;
nr_but=length(radiobuttons);
nr_hands=length(fields(handles));
all_fields=fields(handles);
% set all to 0
for i=1:nr_hands
    curhand=getfield(handles,all_fields{i});
    if ishandle(curhand)
        name1=get(curhand,'tag');
        for j=1:nr_but
            name2=sprintf('togglebutton%d',j);
            if strcmp(name1,name2) && hObject~=curhand
                set(curhand,'value',0);
            end
        end
    end
end

% --- Creates and returns a handle to the GUI figure. 
function h1 = data_gui_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end
% collect my own options to generate parmeters on the fly
global options

% now build from bottom to top a line of text and an edit box for each
% parameter
params=fields(options);
nr_params=length(params);
linecount=1;
% first find out, what the longest name is
maxxlen=0;  % the longest text in width
maxylen=0; % essentially the number of lines
rowheight=2;    % how high every row is
elementhigth=1.5; % how high every element is
edit_width=20;      % how wide an edit box is
spacebetweentextandedit=5;  % space between text and edit box
leftoffset=2;   % offset of text to the left boundary (and right as well)

for i=1:nr_params
    if ~strcmp(params(i),'info')
        string_text=params{i};
        textlen=length(string_text)+3;
        maxxlen=max(maxxlen,textlen);
        maxylen=maxylen+rowheight;  % the distance between lines
    end    
    if strcmp(params(i),'toggleradiobuttons')
        radiobuttons=options.toggleradiobuttons;
        nr_but=length(radiobuttons);
        maxylen=maxylen+nr_but*rowheight;  % the distance between lines
    end
    
end

% the total size of the window is now:
window_width=maxxlen+spacebetweentextandedit+edit_width+2*leftoffset;
window_height=maxylen+3*leftoffset;
% get the size of the screen in chars
set(0,'units','char');
siz=get(0,'screensize');
screeen_height=siz(4);
screeen_width=siz(3);
set(0,'units','pixels'); % back to normal

% the figure
windoff=2; % offset from the top right corner
h1 = figure(...
    'Units','characters',...
    'PaperUnits',get(0,'defaultfigurePaperUnits'),...
    'Color',[0.831372549019608 0.815686274509804 0.784313725490196],...
    'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
    'IntegerHandle','off',...
    'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
    'MenuBar','none',...
    'Name',options.info.title,...
    'NumberTitle','off',...
    'PaperPosition',get(0,'defaultfigurePaperPosition'),...
    'PaperSize',[20.98404194812 29.67743169791],...
    'PaperType',get(0,'defaultfigurePaperType'),...
    'Position',[screeen_width-window_width-windoff screeen_height-window_height-windoff window_width window_height],...
    'Renderer',get(0,'defaultfigureRenderer'),...
    'RendererMode','manual',...
    'Resize','on',...
    'HandleVisibility','callback',...
    'Tag','figure1',...
    'UserData',zeros(1,0));

% application data
setappdata(h1, 'GUIDEOptions', struct(...
    'active_h', 1.020033e+002, ...
    'taginfo', struct(...
    'figure', 2, ...
    'pushbutton', 2), ...
    'override', 0, ...
    'release', 13, ...
    'resize', 'simple', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'lastSavedFile', 'c:\bla bla bla'));

% buttons
if iscell(options.info.buttontext)
    nr_buttons=length(options.info.buttontext);
else
    nr_buttons=1;
end
gesbtextlen=0;
boffset=2;
% for ii=1:nr_buttons
%     if nr_buttons==1
%         btext=options.info.buttontext;
%         textlen=length(btext)+4;
%         textx=(window_width-textlen)/2;
%         fbtext{1}=btext;
%         buttonposx(1)=textx-textlen/2;
%         buttonwidth(1)=textlen+boffset;
%     else
%         btext=options.info.buttontext{ii};
%         fbtext{ii}=btext;
%         textlen=length(btext)+4;
%         
%         buttonposx(ii)=gesbtextlen+boffset;
%         gesbtextlen=gesbtextlen+textlen+boffset;
% 
%         buttonwidth(ii)=textlen;
%         
%     end
% end
% 
% for ii=1:nr_buttons
%     callbackstr='data_gui(''pushbuttons_Callback'',gcbo,[],guidata(gcbo))';
%     pushtag=sprintf('pushbutton%d',ii);
%     h2 = uicontrol(...
%         'Parent',h1,...
%         'Units','characters',...
%         'Callback',callbackstr,...
%         'ListboxTop',0,...
%         'Position',[buttonposx(ii) 1 buttonwidth(ii) 1.5],...
%         'String',fbtext{ii},...
%         'Tag',pushtag);
%     options.buttonhandles(ii)=h2;
% end

for ii=1:nr_buttons
    if nr_buttons==1
        btext=options.info.buttontext;
        textlen=length(btext)+4;
        textx=(window_width-textlen)/2;
        fbtext{1}=btext;
        buttonposx(1)=textx-textlen/2;
        buttonwidth(1)=textlen+boffset;
    else
        btext=options.info.buttontext{ii};
        fbtext{ii}=btext;
        textlen=length(btext)+4;
        
        buttonposx(ii)=gesbtextlen+boffset;
        gesbtextlen=gesbtextlen+textlen+boffset;

        buttonwidth(ii)=textlen;
        
    end
end

for ii=1:nr_buttons
    callbackstr='data_gui(''pushbuttons_Callback'',gcbo,[],guidata(gcbo))';
    pushtag=sprintf('pushbutton%d',ii);
    h2 = uicontrol(...
        'Parent',h1,...
        'Units','characters',...
        'Callback',callbackstr,...
        'ListboxTop',0,...
        'Position',[buttonposx(ii) 1 buttonwidth(ii) 1.5],...
        'String',fbtext{ii},...
        'Tag',pushtag);
    options.buttonhandles(ii)=h2;
end

% make the window wider if necessary

% the total size of the window is now:
new_window_width=window_width;
if buttonposx(end)+buttonwidth(end)+boffset >new_window_width
    new_window_width=buttonposx(end)+buttonwidth(end)+boffset;
end

set(h1,'Position',[screeen_width-new_window_width-windoff screeen_height-window_height-windoff new_window_width window_height]);


% now put a text and an edit field on every line
% tagcount=1;
togglecount=1;
checkcount=1;
for i=nr_params:-1:1
    if ~strcmp(params(i),'info') && ~strcmp(params(i),'toggleradiobuttons') && ~strcmp(params(i),'checkboxes')
        string_text=params{i};
        plot_text=[string_text ' '];
% plot_text=string_text;
        tag=sprintf('text%d',linecount);
        text_len=length(string_text);
        pos_x=maxxlen-text_len+leftoffset;
        pos_y=(linecount+1)*rowheight;
        h2 = uicontrol(...
            'Parent',h1,...
            'Units','characters',...
            'ListboxTop',0,...
            'Position',[pos_x pos_y text_len+5 elementhigth],...
            'String',plot_text,...
            'Style','text',...
            'Tag',tag);
        
        edittag=sprintf('edit%d',linecount);
        pos_x=window_width-edit_width-leftoffset;
        pos_y=(linecount+1)*rowheight;
        value=getfield(options,string_text);
        if isnumeric(value)
            valuestr=num2str(value);
            if length(value)>1  % a field instead a single number
                valuestr='[';
                for j=1:length(value)
                    valuestr=[valuestr ' ' num2str(value(j))];
                end
                valuestr=[valuestr ']'];
            end
        else % a string
            valuestr=value;
        end            
        h3 = uicontrol(...
            'Parent',h1,...
            'Units','characters',...
            'BackgroundColor',[1 1 1],...
            'ListboxTop',0,...
            'Position',[pos_x pos_y edit_width elementhigth],...
            'String',{ valuestr },...
            'userdata',plot_text,...
            'Style','edit',...
            'Tag',edittag);
        %             'Callback','data_gui(''edit1_Callback'',gcbo,[],guidata(gcbo))',...
        
        linecount=linecount+1;
    elseif strcmp(params(i),'toggleradiobuttons')
        radiobuttons=options.toggleradiobuttons;
        nr_but=length(radiobuttons);
        for jj=1:nr_but
            string_text=radiobuttons{jj}.name;
            plot_text=[string_text ' '];
            % plot_text=string_text;
            tag=sprintf('text%d',linecount);
            text_len=length(string_text);
            pos_x=maxxlen-text_len+leftoffset;
            pos_y=(linecount+1)*rowheight;
            h2 = uicontrol(...
                'Parent',h1,...
                'Units','characters',...
                'ListboxTop',0,...
                'Position',[pos_x pos_y text_len+5 elementhigth],...
                'String',plot_text,...
                'Style','text',...
                'Tag',tag);
            
            toggletag=sprintf('togglebutton%d',togglecount);
            togglecount=togglecount+1;
            pos_x=window_width-edit_width-leftoffset;
            pos_y=(linecount+1)*rowheight;
            value=radiobuttons{jj}.value;
            h3 = uicontrol(...
                'Parent',h1,...
                'Units','characters',...
                'BackgroundColor',[1 1 1],...
                'ListboxTop',0,...
                'Position',[pos_x+2 pos_y 4 elementhigth],...
                'Value',value,...
                'Style','radiobutton',...
                'backgroundcolor',[0.925 0.914 0.847],...
                'userdata',jj,...
                'Callback','data_gui(''togglebuttons_Callback'',gcbo,[],guidata(gcbo))',...
                'Tag',toggletag);
            
            linecount=linecount+1;
        end
    elseif strcmp(params(i),'checkboxes')
        checkboxes=options.checkboxes;
        nr_but=length(checkboxes);
        for jj=1:nr_but
            string_text=checkboxes{jj}.name;
            plot_text=[string_text ' '];
            % plot_text=string_text;
            tag=sprintf('text%d',linecount);
            text_len=length(string_text);
            pos_x=maxxlen-text_len+leftoffset;
            pos_y=(linecount+1)*rowheight;
            h2 = uicontrol(...
                'Parent',h1,...
                'Units','characters',...
                'ListboxTop',0,...
                'Position',[pos_x pos_y text_len+5 elementhigth],...
                'String',plot_text,...
                'Style','text',...
                'Tag',tag);
            
            checktag=sprintf('checkbox%d',checkcount);
            checkcount=checkcount+1;
            pos_x=window_width-edit_width-leftoffset;
            pos_y=(linecount+1)*rowheight;
            value=checkboxes{jj}.value;
            h3 = uicontrol(...
                'Parent',h1,...
                'Units','characters',...
                'BackgroundColor',[1 1 1],...
                'ListboxTop',0,...
                'Position',[pos_x+2 pos_y 4 elementhigth],...
                'Value',value,...
                'Style','checkbox',...
                'backgroundcolor',[0.925 0.914 0.847],...
                'userdata',jj,...
                'Tag',checktag);
            
            linecount=linecount+1;
        end
    end
end


hsingleton = h1;


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)


%   GUI_MAINFCN provides these command line APIs for dealing with GUIs
%
%      data_gui, by itself, creates a new data_gui or raises the existing
%      singleton*.
%
%      H = data_gui returns the handle to a new data_gui or the handle to
%      the existing singleton*.
%
%      data_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in data_gui.M with the given input arguments.
%
%      data_gui('Property','Value',...) creates a new data_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 585 $ $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error('Could not find field %s in the gui_State struct in GUI M-file %s', gui_StateFields{i}, gui_Mfile);        
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [getfield(gui_State, gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % data_gui
    % create the GUI
    gui_Create = 1;
elseif numargin > 3 & ischar(varargin{1}) & ishandle(varargin{2})
    % data_gui('CALLBACK',hObject,eventData,handles,...)
    gui_Create = 0;
else
    % data_gui(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = 1;
end

if gui_Create == 0
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else
        feval(varargin{:});
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.
    % make options global, so that I can access them in the generation
    % function 
    global options
    options=varargin{1};
    
    % Do feval on layout code in m-file if it exists
    if ~isempty(gui_State.gui_LayoutFcn)
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);
        % SB: this one finds the wrong one, possible because it just looks
        % for the first one with the m-file. We can do better:
        
        all_childs=get(0,'children');
        this_name=options.info.title;
        for i=1:length(all_childs)
            name=get(all_childs(i),'name');
            if strcmp(name,this_name)
                gui_hFigure=all_childs(i);
            end
        end

        
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        end
    end
    
    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);
    
    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    
    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig 
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end
        
        % Generate HANDLES structure and store with GUIDATA
        guidata(gui_hFigure, guihandles(gui_hFigure));
    end
    
    % If user specified 'Visible','off' in p/v pairs, don't make the figure
    % visible.
    gui_MakeVisible = 1;
    for ind=1:2:length(varargin)
        if length(varargin) == ind
            break;
        end
        len1 = min(length('visible'),length(varargin{ind}));
        len2 = min(length('off'),length(varargin{ind+1}));
        if ischar(varargin{ind}) & ischar(varargin{ind+1}) & ...
                strncmpi(varargin{ind},'visible',len1) & len2 > 1
            if strncmpi(varargin{ind+1},'off',len2)
                gui_MakeVisible = 0;
            elseif strncmpi(varargin{ind+1},'on',len2)
                gui_MakeVisible = 1;
            end
        end
    end
    
    % Check for figure param value pairs
    for index=1:2:length(varargin)
        if length(varargin) == index
            break;
        end
        try, set(gui_hFigure, varargin{index}, varargin{index+1}), catch, break, end
    end
    
    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end
    
    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});
    
    if ishandle(gui_hFigure)
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
        
        % Make figure visible
        if gui_MakeVisible
            set(gui_hFigure, 'Visible', 'on')
            if gui_Options.singleton 
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end
        
        % Done with GUI initialization
        rmappdata(gui_hFigure,'InGUIInitialization');
    end
    
    % If handle visibility is set to 'callback', turn it on until finished with
    % OutputFcn
    if ishandle(gui_hFigure)
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end
    
    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end
    
    if ishandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end


function gui_hFigure = local_openfig(name, singleton)
if nargin('openfig') == 3 
    gui_hFigure = openfig(name, singleton, 'auto');
else
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
end

