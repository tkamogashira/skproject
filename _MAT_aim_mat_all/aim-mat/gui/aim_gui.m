% procedure for 'aim-mat'
% function varargout = aim(varargin)
%   INPUT VALUES:
% 		varargin: either a wave-file, a parameter file (m-file) or an
% 		parameter struct
%   RETURN VALUE:
%		with a parameter file, the result of the processing, otherwise none
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function varargout = aim(varargin)

% check the version

gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @aim_OpeningFcn, ...
    'gui_OutputFcn',  @aim_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && isstr(varargin{1})
    fistletter=varargin{1}(1);
%     if ~isempty(str2num(fistletter)) 
%         disp('matlab does not like wave files that start with numbers. Please change first letter!');
%         return
%     end
    gui_State.gui_Callback = str2func(varargin{1});
end

% something for the eye:
if length(varargin)==1 % only at the first call
    fpa=which('gen_gtfb'); % ugly hack to get the graphics... sorry!
    [a,b,c]=fileparts(fpa);
    where=strfind(a,'modules');
    if ~isempty(where)
        columnpath=fpa(1:where+7);
        handles.info.columnpath=columnpath;
        if ~isstruct(varargin{1})% no box for call with struct
            prname=varargin{1};
            prname=prname(1:end-4);
            if exist(prname)==7 	% is there a directory with the same name?
                handles.abouttexttodisplay=sprintf('loading existing project ''%s'' ...',prname);
            else
                handles.abouttexttodisplay=sprintf('creating new project ''%s'' ...',prname);
            end
            f=aim_displayaboutbox(handles);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aufruf des guis:
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
%close the annoying about-box
if exist('f','var') && ishandle(f)
    name=get(f,'name');
    if ~isempty(strfind(name,'About'))
        close(f);
    end
end


function aim_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

verstrst=ver;
nrproducts=length(verstrst);
for i=1:nrproducts
    verstr=verstrst(i);
    if strcmp(verstr.Name,'MATLAB') % just making sure...
        vernr=str2num(verstr.Version);
        if vernr<6.5
            str='aim-mat requires MATLAB version 6.5 or higher!';
            disp(str);
            er=errordlg(str,'Version error');
            set(er,'WindowStyle','modal');
            return
        end
    end
end

% per default we work with graphic
handles.with_graphic=1;
% no error so far
handles.error=0;


% handles.screen_modus='paper';	% can be 'screen' or 'paper' - chooses the colors and styles
handles.screen_modus='screen';	%

if isstruct(varargin{1})
    all_options=varargin{1};
    filename=all_options.signal.signal_filename;
    handles.autorun=1;	% start running after loading
    handles.initial_options=all_options;	% start with these options
else
    filename=varargin{1};
    handles.autorun=0;	% dont start running after loading
end

% initiate the parameters from an old version or do it new:
handles=init_aim_parameters(handles,filename);
if handles.error==1
    close(handles.figure1);
    return
end

% reset the graphic to standart values:
handles=init_aim_gui(handles);
movegui(handles.figure1,'south');

% set the close function to my own
set(handles.figure1,'CloseRequestFcn',{@quitprogram,handles})

if handles.autorun==1
    if isfield(handles.initial_options,'pcp')
        set(handles.checkbox0,'Value',1);
    end
    if isfield(handles.initial_options,'bmm')
        set(handles.checkbox1,'Value',1);
    end
    if isfield(handles.initial_options,'nap')
        set(handles.checkbox2,'Value',1);
    end
    if isfield(handles.initial_options,'strobes')
        set(handles.checkbox3,'Value',1);
    end
    if isfield(handles.initial_options,'sai')
        set(handles.checkbox4,'Value',1);
    end
    if isfield(handles.initial_options,'usermodule')
        set(handles.checkbox8,'Value',1);
    end
end

% do the changes and go on!
handles=update(hObject, eventdata, handles,2);

if handles.autorun==1
    old_all_options=handles.all_options;
    handles.all_options=all_options;
    handles.info.no_automatic_parameter_update=1;
    % now tell the info, which modules we want. This is the same routine as
    % in the no-grafic version:

    handles.info.calculate_signal=0;
    handles.info.calculate_pcp=0;
    handles.info.calculate_bmm=0;
    handles.info.calculate_nap=0;
    handles.info.calculate_strobes=0;
    handles.info.calculate_sai=0;
    handles.info.calculate_usermodule=0;
    handles.info.calculate_movie=0;
    % now find out, which column we want to calculate:
    if isfield(all_options,'pcp')
        handles.info.calculate_pcp=1;
        module_names=fieldnames(all_options.pcp);	% find out, which module name
        module_name=module_names{1}; % only the first one is relevant!
        handles.info.current_pcp_module=module_name;	% this one is the current one
        handles.all_options.pcp=all_options.pcp;	% copy the parameters in place
    end
    if isfield(all_options,'bmm')
        handles.info.calculate_bmm=1;
        module_names=fieldnames(all_options.bmm);	% find out, which module name
        module_name=module_names{1}; % only the first one is relevant!
        handles.info.current_bmm_module=module_name;	% this one is the current one
        handles.all_options.bmm=all_options.bmm;	% copy the parameters in place
    end
    if isfield(all_options,'nap')
        handles.info.calculate_nap=1;
        module_names=fieldnames(all_options.nap);	% find out, which module name
        module_name=module_names{1}; % only the first one is relevant!
        handles.info.current_nap_module=module_name;	% this one is the current one
        handles.all_options.nap=all_options.nap;	% copy the parameters in place
    end
    if isfield(all_options,'strobes')
        handles.info.calculate_strobes=1;
        module_names=fieldnames(all_options.strobes);	% find out, which module name
        module_name=module_names{1}; % only the first one is relevant!
        handles.info.current_strobes_module=module_name;	% this one is the current one
        handles.all_options.strobes=all_options.strobes;	% copy the parameters in place
    end
    if isfield(all_options,'sai')
        handles.info.calculate_sai=1;
        module_names=fieldnames(all_options.sai);	% find out, which module name
        module_name=module_names{1}; % only the first one is relevant!
        handles.info.current_sai_module=module_name;	% this one is the current one
        handles.all_options.sai=all_options.sai;	% copy the parameters in place
    end
    if isfield(all_options,'usermodule')
        handles.info.calculate_usermodule=1;
        module_names=fieldnames(all_options.usermodule);	% find out, which module name
        module_name=module_names{1}; % only the first one is relevant!
        handles.info.current_usermodule_module=module_name;	% this one is the current one
        handles.all_options.usermodule=all_options.usermodule;	% copy the parameters in place
    end
    if isfield(all_options,'movie')
        handles.info.calculate_movie=1;
        module_names=fieldnames(all_options.movie);	% find out, which module name
        module_name=module_names{1}; % only the first one is relevant!
        handles.info.current_movie_module=module_name;	% this one is the current one
        handles.all_options.movie=all_options.movie;	% copy the parameters in place
    end

    % up to here copy of nowgrafic. If I ever have time, I think of something
    % more elegant

    handles=do_aim_calculate(handles);
    handles.all_options=old_all_options;

    if isfield(all_options,'pcp')
        result=handles.data.pcp;
    end
    if isfield(all_options,'bmm')
        result=handles.data.bmm;
    end
    if isfield(all_options,'nap')
        result=handles.data.nap;
    end
    if isfield(all_options,'strobes')
        result=handles.data.strobes;
    end
    if isfield(all_options,'sai')
        result=handles.data.sai;
    end
    if isfield(all_options,'pitch_image')
        result=handles.data.pitch_image;
    end
    if isfield(all_options,'usermodule')
        result=handles.data.usermodule;
    end

    handles.output=result;
    handles=update(hObject, eventdata, handles,2);
end

function varargout = aim_OutputFcn(hObject, eventdata, handles)
if isfield(handles,'output')
    result.result=handles.output;
    result.error=0;
    result.all_options=handles.all_options;
    result.info=handles.info;
    % copy all data to the output, it is usefull sometimes!
    if isfield(handles.info,'no_automatic_parameter_update')
        if isfield(handles.all_options,'pcp')
            result.result=handles.data.pcp;
        end
        if isfield(handles.all_options,'bmm')
            result.result=handles.data.bmm;
        end
        if isfield(handles.all_options,'nap')
            result.result=handles.data.nap;
        end
        if isfield(handles.all_options,'strobes')
            result.result=handles.data.strobes;
        end
        if isfield(handles.all_options,'sai')
            result.result=handles.data.sai;
        end
        if isfield(handles.all_options,'usermodule')
            result.result=handles.data.usermodule;
        end
    end

    varargout{1} = result;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         Menufunktions                       %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function exit_Callback(hObject, eventdata, handles)
quitprogram(hObject, eventdata, handles);
function about_Callback(hObject, eventdata, handles)
aim_displayaboutbox(handles);
function file_Callback(hObject, eventdata, handles)
function help_Callback(hObject, eventdata, handles)

% load a new sound
function loadsound_Callback(hObject, eventdata, handles)
[signame,dirname]=uigetfile('*.wav');
if ~isnumeric(dirname)
    cd(dirname);
    if fexist(signame)
        handles=init_aim_parameters(handles,signame);
        handles=init_aim_gui(handles);
    else
        return
    end
else
    return
end
handles=update(hObject, eventdata, handles,2);

% exchange the soundfile and keep the rest
function exchange_Callback(hObject, eventdata, handles)
[signame,dirname]=uigetfile('*.wav');
if ~isnumeric(dirname)
    cd(dirname);
    if fexist(signame)
        handles=aim_exchange_sound_file(handles,signame);
        % 	handles=init_aim_gui(handles);
    else
        return
    end
else
    return
end
handles=update(hObject, eventdata, handles,2);



function edit_Callback(hObject, eventdata, handles)
function opencool_Callback(hObject, eventdata, handles)
wavename=sprintf('%s/%s',pwd,handles.info.signalwavename);
if ispc
    winopen(wavename);
else
    disp('sorry, cant open external file in unix...');
end

function internethelp_Callback(hObject, eventdata, handles)
helpname=sprintf('%shelp.html',handles.info.columnpath);
if ispc
    winopen(helpname);
else
    disp('sorry, cant open external file in unix...');
end

function Untitled_1_Callback(hObject, eventdata, handles)
function sptool_Callback(hObject, eventdata, handles)
sig=handles.data.signal;
adaptedspecgramdemo(getvalues(sig),getsr(sig));



%%%%%%% save standalone parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function saveasparameters_Callback(hObject, eventdata, handles)
[fname,dirname]=uiputfile('*.m','Save stand alone parameter file');
if isempty(strfind(fname,'.m'))
    fname=[fname '.m'];
end
filename=fullfile(dirname,fname);
aim_saveparameters(handles,filename,0);	% the 0 indicates, that only the relevant parameters are important

%%%%%%% open personal default file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function open_personal_Callback(hObject, eventdata, handles)
edit('personal_defaults.m');

%%%%%%% open current generating function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit_genfunc_Callback(hObject, eventdata, handles)
[generating_module,generating_function,coptions]=aim_getcurrent_module(handles,handles.info.current_plot);
edit(generating_function);


%%%%%%% edit parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit_params_Callback(hObject, eventdata, handles)
dir=handles.info.original_soundfile_directory;
filename=fullfile(dir,handles.info.parameterfilename);
edit(filename);
%%%%%%% diaplay versions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function version_Callback(hObject, eventdata, handles)
aim_display_versions(handles);

function copydata_Callback(hObject, eventdata, handles)
assignin('base','data',handles.data);
assignin('base','info',handles.info);

% select the start point and the end point of the signal
function select_time_Callback(hObject, eventdata, handles)
oldoptions=handles.all_options.signal;
sig=handles.data.original_signal;
% out=adaptedspecgramdemo(getvalues(sig),getsr(sig),oldoptions.start_time,oldoptions.start_time+oldoptions.duration);
% handles.all_options.signal.start_time=out.start;
% handles.all_options.signal.duration=out.duration;

current_start=handles.all_options.signal.start_time;
current_duration=handles.all_options.signal.duration;
allowed_duration=handles.all_options.signal.original_duration;
text{1}='';
text{2}='';

[start,duration]=length_questionbox(current_start,current_duration,allowed_duration,text);
handles.all_options.signal.start_time=start;
handles.all_options.signal.duration=duration;

if ~structisequal(oldoptions,handles.all_options.signal)
    aim_saveparameters(handles,handles.info.parameterfilename,1);	% save the new parameters to the file
    % 	handles.info.calculate_signal=1;
    handles.all_options.signal=oldoptions; % tell him to use the new ones!
    handles=do_aim_updateparameters(handles);
    % 	handles=do_aim_calculate(handles);
    handles=update(hObject, eventdata, handles,4);
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         PushButtons   %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% play sound %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton23_Callback(hObject, eventdata, handles)
play(handles.data.signal);
% signal
function pushbutton22_Callback(hObject, eventdata, handles)
handles.info.current_plot=1;
handles=update(hObject, eventdata, handles,4);
%pcp
function pushbutton0_Callback(hObject, eventdata, handles)
handles.info.current_plot=2;
if get(handles.checkbox0,'Value')==1
    handles=do_aim_calculate(handles);
end
handles=update(hObject, eventdata, handles,4);
% bmm
function pushbutton2_Callback(hObject, eventdata, handles)
handles.info.current_plot=3;
if get(handles.checkbox1,'Value')==1
    handles=do_aim_calculate(handles);
end
handles=update(hObject, eventdata, handles,4);
% nap
function pushbutton3_Callback(hObject, eventdata, handles)
handles.info.current_plot=4;
if get(handles.checkbox2,'Value')==1
    handles=do_aim_calculate(handles);
end
handles=update(hObject, eventdata, handles,4);
% strobes
function pushbutton4_Callback(hObject, eventdata, handles)
handles.info.current_plot=5;
if get(handles.checkbox3,'Value')==1
    handles=do_aim_calculate(handles);
end
handles=update(hObject, eventdata, handles,4);
% sai
function pushbutton5_Callback(hObject, eventdata, handles)
handles.info.current_plot=6;
if get(handles.checkbox4,'Value')==1
    handles=do_aim_calculate(handles);
end
sai=handles.data.sai;
nr_chan=getnrchannels(sai{1});
if nr_chan==1
    set(handles.checkbox6,'Value',0);  %switch off frequency profile
    set(handles.checkbox7,'Value',0);  %switch off temporal profile
else
    set(handles.checkbox6,'Value',1);  %switch on frequency profile
    set(handles.checkbox7,'Value',1);  %switch on temporal profile
end
handles=update(hObject, eventdata, handles,4);
% usermodule
function pushbutton21_Callback(hObject, eventdata, handles)
handles.info.current_plot=7;
if get(handles.checkbox8,'Value')==1
    handles=do_aim_calculate(handles);
end
handles=update(hObject, eventdata, handles,2);
% movie
function pushbutton6_Callback(hObject, eventdata, handles)
if get(handles.checkbox5,'Value')==1
    handles=do_aim_calculate(handles);
end
% generating_module_string=get(handles.listbox5,'String');
% generating_module=generating_module_string(get(handles.listbox5,'Value'));
% generating_module=generating_module{1};
% uniqueworkingname=handles.info.uniqueworkingname;
directoryname=handles.info.directoryname;
% moviename=sprintf('%s/%s/%s.%s.mov',pwd,directoryname,uniqueworkingname,generating_module);

handles=update(hObject, eventdata, handles,2);

moviename=fullfile(pwd,directoryname,handles.info.last_movie_name_generated);
if ispc
    winopen(moviename);
else
    disp('sorry, cant open external file in unix...');
end

% autoscale
function pushbuttonautoscale_Callback(hObject, eventdata, handles)
handles=do_aim_autoscale(handles);
handles=update(hObject, eventdata, handles,1);

% update
function pushbutton25_Callback(hObject, eventdata, handles)
handles=do_aim_updateparameters(handles);
handles=update(hObject, eventdata, handles,2);



% single channel
function pushbutton24_Callback(hObject, eventdata, handles)
if ~isfield(handles.info,'children')
    fig=figure;
    handles.info.children.single_channel.windowhandle=fig;
else
    figure(handles.info.children.single_channel.windowhandle)
end

single_channel_gui(handles);
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         Listboxes                          %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function listbox0_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function listbox3_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function listbox4_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function listbox5_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function listbox6_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end

% pcp
function listbox0_Callback(hObject, eventdata, handles)
% TODO:
% oldmodule=handles.info.current_pcp_module;
set(handles.checkbox0,'Value',1); % set the tick to indicate, that it has changed
handles=update(hObject, eventdata, handles,3);
% newmodule=handles.info.current_pcp_module;
% if strcmp(oldmodule,newmodule)
% 	set(handles.checkbox0,'Value',0); % remove the tick again
% end
% bmm
function listbox1_Callback(hObject, eventdata, handles)
set(handles.checkbox1,'Value',1);
handles=update(hObject, eventdata, handles,5);
% nap
function listbox2_Callback(hObject, eventdata, handles)
set(handles.checkbox2,'Value',1);
handles=update(hObject, eventdata, handles,5);
% strobes
function listbox3_Callback(hObject, eventdata, handles)
set(handles.checkbox3,'Value',1);
handles=update(hObject, eventdata, handles,5);
% sai
function listbox4_Callback(hObject, eventdata, handles)
set(handles.checkbox4,'Value',1);
handles=update(hObject, eventdata, handles,5);
%usermodule
function listbox6_Callback(hObject, eventdata, handles)
set(handles.checkbox8,'Value',1);
handles=update(hObject, eventdata, handles,5);
% movie
function listbox5_Callback(hObject, eventdata, handles)
set(handles.checkbox5,'Value',1);
handles=update(hObject, eventdata, handles,5);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         Checkboxes                         %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pcp
function checkbox0_Callback(hObject, eventdata, handles)
handles=aim_updatecheckboxes(hObject, eventdata, handles,1);
handles=update(hObject, eventdata, handles,3);
%bmm
function checkbox1_Callback(hObject, eventdata, handles)
handles=aim_updatecheckboxes(hObject, eventdata, handles,2);
handles=update(hObject, eventdata, handles,3);
%nap
function checkbox2_Callback(hObject, eventdata, handles)
handles=aim_updatecheckboxes(hObject, eventdata, handles,3);
handles=update(hObject, eventdata, handles,3);
%strobes
function checkbox3_Callback(hObject, eventdata, handles)
handles=aim_updatecheckboxes(hObject, eventdata, handles,4);
handles=update(hObject, eventdata, handles,3);
%sai
function checkbox4_Callback(hObject, eventdata, handles)
handles=aim_updatecheckboxes(hObject, eventdata, handles,5);
handles=update(hObject, eventdata, handles,3);
% usermodule
function checkbox8_Callback(hObject, eventdata, handles)
handles=aim_updatecheckboxes(hObject, eventdata, handles,6);
handles=update(hObject, eventdata, handles,3);
%movies
function checkbox5_Callback(hObject, eventdata, handles)
handles=aim_updatecheckboxes(hObject, eventdata, handles,7);
handles=update(hObject, eventdata, handles,3);

% show the time waveform on top
function checkbox10_Callback(hObject, eventdata, handles)
handles=update(hObject, eventdata, handles,2);
function checkbox6_Callback(hObject, eventdata, handles)
handles=update(hObject, eventdata, handles,2);
%show interval profile
function checkbox7_Callback(hObject, eventdata, handles)
handles=update(hObject, eventdata, handles,2);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         Sliders                         %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slider1_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;if usewhitebg    set(hObject,'BackgroundColor',[.9 .9 .9]);else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function slider2_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;if usewhitebg    set(hObject,'BackgroundColor',[.9 .9 .9]);else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function slider3_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;if usewhitebg    set(hObject,'BackgroundColor',[.9 .9 .9]);else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end

function slider1_Callback(hObject, eventdata, handles)
handles=slider_scale(hObject, eventdata, handles);
handles=update(hObject, eventdata, handles,1);

function slider2_Callback(hObject, eventdata, handles)
handles=slider_start(hObject, eventdata, handles);
handles=update(hObject, eventdata, handles,1);

function slider3_Callback(hObject, eventdata, handles)
handles=slider_duration(hObject, eventdata, handles);
handles=update(hObject, eventdata, handles,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         Edits                              %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');else    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));end

function edit1_Callback(hObject, eventdata, handles)
handles=edit_scale(hObject, eventdata, handles);
handles=update(hObject, eventdata, handles,1);
function edit2_Callback(hObject, eventdata, handles)
handles=edit_start(hObject, eventdata, handles);
handles=update(hObject, eventdata, handles,1);
function edit3_Callback(hObject, eventdata, handles)
handles=edit_duration(hObject, eventdata, handles);
handles=update(hObject, eventdata, handles,1);


function handles=update(hObject, eventdata, handles,action)

% check, if the singlechannel window was closed: (this is here, because it
% is checked most often
if isfield(handles.info,'children')
    if ~ishandle(handles.info.children.single_channel.windowhandle)
        rmfield(handles.info.children,'single_channel');
    end
end

handles.calling_object=hObject;

if action>1
    handles=aim_updategui(handles);
end

% if we want to see the interval profile:

if get(handles.checkbox7,'Value')==1
    options.withtime=true;
else
    options.withtime=false;
end
% and if we want to see the frequency profile:
if get(handles.checkbox6,'Value')==1
    options.withfre=islogical(true);
else
    options.withfre=islogical(0);
end
% do we want to see the signal?
if get(handles.checkbox10,'Value')==1
    options.withsignal=islogical(true);
else
    options.withsignal=islogical(0);
end
% if there has never been a figure, create a new one
if ~isfield(handles.info,'current_figure')
    handles.info.current_figure=figure;
end
options.figure_handle=handles.info.current_figure;

switch action
    case {1,2}
        handles=aim_replotgraphic(handles,options);
        aim_savecurrentstate(handles);% save the state of the project and the window to a file
        guidata(hObject, handles);
    case 3
        aim_savecurrentstate(handles);% save the state of the project and the window to a file
        guidata(hObject, handles);
    case 4		% everything with autoscale (for click on button)
        handles=do_aim_autoscale(handles);
        handles=aim_replotgraphic(handles,options);
        aim_savecurrentstate(handles);% save the state of the project and the window to a file
        guidata(hObject, handles);
    case 5
        guidata(hObject, handles);
end


