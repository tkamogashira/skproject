% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function varargout = W(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @single_channel_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @single_channel_gui_OutputFcn, ...
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


% --- Executes just before single_channel_gui is made visible.
function single_channel_gui_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for single_channel_gui
handles.output = hObject;

set(handles.figure1,'Name','select channel');

import_options=varargin{1};
handles.output=-1;
if isstruct(import_options)
	handles.import_options=import_options;
else
	if strcmp(import_options,'close');
		close(handles.figure1);
		return
	end
	if strcmp(import_options,'getchannelnumber')
		if ~isfield(handles,'slideredit')
			handles.output=1;
		else
			handles.output=slidereditcontrol_get_value(handles.slideredit);
		end
		guidata(hObject, handles);
		return
	end
end

% if ~isfield(import_options.info.children.single_channel,'windowhandle')
% 	fig=figure(import_options.info.children.single_channel.windowhandle);
% 	import_options.info.children.single_channel.windowhandle=fig;
% end
% 
if ~isfield(handles,'figure_handle') || ~ishandle(handles.figure_handle)
 	handles.figure_handle=import_options.info.children.single_channel.windowhandle;
	% set the window next to the graphic window
	set(handles.figure1,'units','pixels');
	set(handles.figure_handle,'units','pixels');
	orgpos=get(handles.figure1,'position');
	winpos=get(handles.figure_handle,'position');
	newpos(1)=winpos(1)+winpos(3);
	newpos(2)=winpos(2);
	movegui(handles.figure1,newpos);
%  	newpos(3:4)=orgpos(3:4);
% 	set(handles.figure1,'position',orgpos);
end

% this is an indicator for the main function, that it is called from a
% child
handles.import_options.info.iscallfromchild=1;

data=import_options.data;
nrchan=getnrchannels(data.bmm);
if 	isfield(import_options.info.children.single_channel,'channelnumber')
	curr_chan=import_options.info.children.single_channel.channelnumber;
else
	curr_chan=round(nrchan/2);
end

% handles.current_channel_nr=middle_chan;
handles.cfs=getcf(data.bmm);

% set up the slider edit control
handles.slideredit=slidereditcontrol_setup(...
	handles.slider1,... % handle of the slider
	handles.edit1,...% handle of the edit control
	1, ...	% min value
	nrchan, ...  % max value
	curr_chan, ...  % current value
	0, ...  % islog
	1, ...% multiplier on the edit control
	0);		% nr digits in the edit control after comma

handles.slideredit=slidereditcontrol_set_range(handles.slideredit,10); % makes a stepsize of 1

set(handles.edit3,'String',1);

% plot the result
handles=update(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes single_channel_gui wait for user response (see UIRESUME)
%  uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = single_channel_gui_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
if isstruct(handles)
	varargout{1} = handles.output;
end


function edit1_Callback(hObject, eventdata, handles)
curval=get(hObject,'String');
curval=str2num(curval);
handles.slideredit=...
	slidereditcontrol_set_raweditvalue(handles.slideredit,curval);
handles=update(handles);
guidata(hObject, handles);
function edit2_Callback(hObject, eventdata, handles)
curval=get(hObject,'String');
curval=str2num(curval);
nrchan=fre2chan(handles.import_options.data.bmm,curval);
nrchan=round(nrchan);
handles.slideredit=...
	slidereditcontrol_set_value(handles.slideredit,nrchan);
handles=update(handles);
guidata(hObject, handles);
function edit3_Callback(hObject, eventdata, handles)
handles=update(handles);
guidata(hObject, handles);

function slider1_Callback(hObject, eventdata, handles)
curval=get(hObject,'Value');
% curval=round(curval);
handles.slideredit=...
 	slidereditcontrol_set_rawslidervalue(handles.slideredit,curval);
handles=update(handles);
guidata(hObject, handles);

% dynamic feature for the calculation of the sai
function pushbutton1_Callback(hObject, eventdata, handles)

stepsize=str2num(get(handles.edit3,'String'));


options=handles.import_options.all_options.sai;
%     disp('generating and saving sai...');
generating_module=handles.import_options.info.current_sai_module;	
handles.import_options.info.calculated_sai_module=generating_module;	% this one is really calculated
generating_functionline=['options.' generating_module '.generatingfunction'];
eval(sprintf('generating_function=%s;',generating_functionline'));
nap=handles.import_options.data.nap;
strobes=handles.import_options.data.strobes;
optline=sprintf('coptions=%s.%s;','handles.import_options.all_options.sai',generating_module);
eval(optline);
coptions.single_channel_do=1;
coptions.single_channel_channel_nr=slidereditcontrol_get_value(handles.slideredit);
coptions.single_channel_time_step=stepsize/1000;
coptions.thresholds=handles.import_options.data.thresholds;
callline=sprintf('res=%s(nap,strobes,coptions);',generating_function);
eval(callline);

	


function slider1_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;if usewhitebg    	set(hObject,'BackgroundColor',[.9 .9 .9]);else    	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end



function handles=update(handles)
	nr_chan=slidereditcontrol_get_value(handles.slideredit);
	nr_chan=round(nr_chan);
	handles.slideredit=slidereditcontrol_set_value(handles.slideredit,nr_chan);
	cf=handles.cfs(nr_chan);
	set(handles.edit2,'String',num2str(cf));
	
	options.figure_handle=handles.figure_handle;
	options.withtime=0;
	options.withfre=0;
	options.withsignal=0;
	
	options.display_single_channel=nr_chan;
	switch handles.import_options.info.current_plot
		case {3,4,5} % bmm
			set(handles.edit3,'visible','off');
			set(handles.text3,'visible','off');
			set(handles.text5,'visible','off');
			set(handles.pushbutton1,'visible','off');
		case 6 %sai
			set(handles.edit3,'visible','on');
			set(handles.text3,'visible','on');
			set(handles.text5,'visible','on');
			set(handles.pushbutton1,'visible','on');
	end		
	aim_replotgraphic(handles.import_options,options);
	
	set(handles.figure1,'Name','select channel'); % repair
	
	return
	
