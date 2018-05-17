% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  		handles	: all relevant parameters
%
%   RETURN VALUE:
% 
% reset the graphic and everything in the GUI
%
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function handles=init_aim_gui(handles)

% TCW AIM2006
handles.hand_scaling=1;

modus=handles.screen_modus;

switch modus
	case 'screen'
		% set some colors: (green for display)
		%handles.colors.background=[0 .502 0]; %Old AIM
        handles.colors.background=[236/255 233/255 240/255];
		handles.colors.green1=[0 0.75 0];
		handles.colors.green2=[0 1 0];
		handles.colors.blue2=[0 0 1];
		handles.colors.blue1=[0.5 0 0];
		handles.colors.white=[1 1 1];
		handles.colors.black=[0 0 0];
		handles.colors.blue3=[0 0.5 0.5];
		handles.colors.textonbackground=handles.colors.black;
		handles.colors.textonbuttons=handles.colors.black;
		handles.colors.buttoncolor=[0.831 0.816 0.784];
	case 'paper'
% 		set some colors: (gray for publication)
		handles.colors.background=[0.83 0.83 0.83];
		handles.colors.green1=[0.75 0.75 0.75];
		handles.colors.green2=[0.6 0.6 0.6];
		handles.colors.blue2=[0.5 0.5 0.5];
		handles.colors.blue1=[0.4 0.4 0.4];
		handles.colors.white=[1 1 1];
		handles.colors.black=[0 0 0];
		handles.colors.blue3=[0.8 0.8 0.8];
		handles.colors.textonbackground=handles.colors.black;
		handles.colors.textonbuttons=handles.colors.white;
		handles.colors.buttoncolor=handles.colors.green1;
end

set(handles.figure1,'Color',handles.colors.background);
set(handles.text23,'BackgroundColor',handles.colors.background);
set(handles.text23,'ForegroundColor',handles.colors.textonbackground);
set(handles.text19,'BackgroundColor',handles.colors.background);
set(handles.text19,'ForegroundColor',handles.colors.textonbackground);
set(handles.text17,'BackgroundColor',handles.colors.background);
set(handles.text17,'ForegroundColor',handles.colors.textonbackground);
set(handles.displayduration,'BackgroundColor',handles.colors.background);
set(handles.displayduration,'ForegroundColor',handles.colors.textonbackground);
set(handles.text20,'BackgroundColor',handles.colors.background);
set(handles.text20,'ForegroundColor',handles.colors.textonbackground);
set(handles.text28,'BackgroundColor',handles.colors.background);
set(handles.text28,'ForegroundColor',handles.colors.textonbackground);
set(handles.text29,'BackgroundColor',handles.colors.background);
set(handles.text29,'ForegroundColor',handles.colors.textonbackground);
set(handles.text30,'BackgroundColor',handles.colors.background);
set(handles.text30,'ForegroundColor',handles.colors.textonbackground);
set(handles.text27,'BackgroundColor',handles.colors.background);
set(handles.text27,'ForegroundColor',handles.colors.textonbackground);
set(handles.text25,'BackgroundColor',handles.colors.background);
set(handles.text25,'ForegroundColor',handles.colors.textonbackground);
set(handles.text24,'BackgroundColor',handles.colors.background);
set(handles.text24,'ForegroundColor',handles.colors.textonbackground);
set(handles.text9,'BackgroundColor',handles.colors.background);
set(handles.text9,'ForegroundColor',handles.colors.textonbackground);
set(handles.text10,'BackgroundColor',handles.colors.background);
set(handles.text10,'ForegroundColor',handles.colors.textonbackground);
set(handles.text8,'BackgroundColor',handles.colors.background);
set(handles.text8,'ForegroundColor',handles.colors.textonbackground);
set(handles.text7,'BackgroundColor',handles.colors.background);
set(handles.text7,'ForegroundColor',handles.colors.textonbackground);
set(handles.text21,'BackgroundColor',handles.colors.background);
set(handles.text21,'ForegroundColor',handles.colors.textonbackground);
set(handles.text22,'BackgroundColor',handles.colors.background);
set(handles.text22,'ForegroundColor',handles.colors.textonbackground);
set(handles.text13,'BackgroundColor',handles.colors.background);
set(handles.text13,'ForegroundColor',handles.colors.textonbackground);

set(handles.frame16,'BackgroundColor',handles.colors.background);
set(handles.frame15,'BackgroundColor',handles.colors.background);
set(handles.frame18,'BackgroundColor',handles.colors.background);
set(handles.frame17,'BackgroundColor',handles.colors.background);
set(handles.frame17,'ForegroundColor',handles.colors.black);
set(handles.frame14,'BackgroundColor',handles.colors.background);
set(handles.frame14,'ForegroundColor',handles.colors.black);
set(handles.frame19,'BackgroundColor',handles.colors.background);
set(handles.frame19,'ForegroundColor',handles.colors.background);

set(handles.frame7,'BackgroundColor',handles.colors.background);
set(handles.frame10,'BackgroundColor',handles.colors.blue3);

set(handles.checkbox10,'BackgroundColor',handles.colors.background);
set(handles.checkbox10,'ForegroundColor',handles.colors.textonbackground);
set(handles.checkbox6,'BackgroundColor',handles.colors.background);
set(handles.checkbox6,'ForegroundColor',handles.colors.textonbackground);
set(handles.checkbox7,'BackgroundColor',handles.colors.background);
set(handles.checkbox7,'ForegroundColor',handles.colors.textonbackground);

set(handles.checkbox0,'BackgroundColor',handles.colors.background);
set(handles.checkbox1,'BackgroundColor',handles.colors.background);
set(handles.checkbox2,'BackgroundColor',handles.colors.background);
set(handles.checkbox3,'BackgroundColor',handles.colors.background);
set(handles.checkbox4,'BackgroundColor',handles.colors.background);
set(handles.checkbox8,'BackgroundColor',handles.colors.background);
set(handles.checkbox5,'BackgroundColor',handles.colors.blue3);

set(handles.pushbutton24,'BackgroundColor',handles.colors.buttoncolor);
set(handles.pushbutton25,'BackgroundColor',handles.colors.buttoncolor);
set(handles.pushbuttonautoscale,'BackgroundColor',handles.colors.buttoncolor);
set(handles.slider1,'BackgroundColor',handles.colors.buttoncolor);
set(handles.slider2,'BackgroundColor',handles.colors.buttoncolor);
set(handles.slider3,'BackgroundColor',handles.colors.buttoncolor);


% % % first load the default values from the default parameter file:
% handles=loadallparameterfiles(handles);
all_options=handles.all_options;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% PCP
pcpnames = fieldnames(all_options.pcp);
finalpcpnames=[];
finddefault=1;
findold=-1;

% TCW AIM2006 Reorder the list so that the default value comes first
for i=1:length(pcpnames)
    if strcmp(pcpnames{i},handles.info.default_start_module_pcp)
		finalpcpnames=[pcpnames(i) finalpcpnames];  
    else
        finalpcpnames=[finalpcpnames pcpnames(i)];
    end
end
%%%

for i=1:length(finalpcpnames)
	if strcmp(finalpcpnames{i},handles.info.default_start_module_pcp)
		finddefault=i;
	end
	if isfield(handles.info,'init')
		if isfield(handles.info.init,'calculated_pcp_module')
			if strcmp(finalpcpnames{i},handles.info.init.calculated_pcp_module)
				findold=i;
			end
		end
	end		
end
set(handles.listbox0,'String',finalpcpnames);
if findold>0
	handles.info.current_pcp_module=finalpcpnames{findold};
	set(handles.listbox0,'Value',findold);
else
	handles.info.current_pcp_module=finalpcpnames{finddefault};
	set(handles.listbox0,'Value',finddefault);
end
handles.info.defaults.default_pcp_module=finddefault;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% BMM
bmmnames = fieldnames(all_options.bmm);
finalbmmnames=[];
finddefault=1;
findold=-1;
% TCW AIM2006 Reorder the list so that the default value comes first
for i=1:length(bmmnames)
    if strcmp(bmmnames{i},handles.info.default_start_module_bmm)
		finalbmmnames=[bmmnames(i) finalbmmnames];  
    else
        finalbmmnames=[finalbmmnames bmmnames(i)];
    end
end
%%%

for i=1:length(finalbmmnames)
	if strcmp(finalbmmnames{i},handles.info.default_start_module_bmm)
		finddefault=i;
	end
	if isfield(handles.info,'init')
		if isfield(handles.info.init,'calculated_bmm_module')
			if strcmp(finalbmmnames{i},handles.info.init.calculated_bmm_module)
				findold=i;
			end
		end
	end		
end
set(handles.listbox1,'String',finalbmmnames);
if findold>0
	handles.info.current_bmm_module=finalbmmnames{findold};
	set(handles.listbox1,'Value',findold);
else
	handles.info.current_bmm_module=finalbmmnames{finddefault};
	set(handles.listbox1,'Value',finddefault);
end
handles.info.defaults.default_bmm_module=finddefault;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% NAP
napnames = fieldnames(all_options.nap);
finalnapnames=[];
finddefault=1;
findold=-1;
% TCW AIM2006 Reorder the list so that the default value comes first
for i=1:length(napnames)
    if strcmp(napnames{i},handles.info.default_start_module_nap)
		finalnapnames=[napnames(i) finalnapnames];  
    else
        finalnapnames=[finalnapnames napnames(i)];
    end
end
%%%

for i=1:length(finalnapnames)
	if strcmp(finalnapnames{i},handles.info.default_start_module_nap)
		finddefault=i;
	end
	if isfield(handles.info,'init')
		if isfield(handles.info.init,'calculated_nap_module')
			if strcmp(finalnapnames{i},handles.info.init.calculated_nap_module)
				findold=i;
			end
		end
	end		
end
set(handles.listbox2,'String',finalnapnames);
if findold>0
	handles.info.current_nap_module=finalnapnames{findold};
	set(handles.listbox2,'Value',findold);
else
	handles.info.current_nap_module=finalnapnames{finddefault};
	set(handles.listbox2,'Value',finddefault);
end
handles.info.defaults.default_nap_module=finddefault;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% STROBES
strobesnames = fieldnames(all_options.strobes);
finalstrobesnames=[];
finddefault=1;
findold=-1;

% TCW AIM2006 Reorder the list so that the default value comes first
for i=1:length(strobesnames)
    if strcmp(strobesnames{i},handles.info.default_start_module_strobes)
		finalstrobesnames=[strobesnames(i) finalstrobesnames];  
    else
        finalstrobesnames=[finalstrobesnames strobesnames(i)];
    end
end

for i=1:length(finalstrobesnames)
	%finalstrobesnames=[finalstrobesnames strobesnames(i)];
	% default value is sf2003:
	if strcmp(finalstrobesnames{i},handles.info.default_start_module_strobes)
		finddefault=i;
	end
	% if loaded from a project, set the settings to the loaded ones
	if isfield(handles.info,'init')
		if isfield(handles.info.init,'calculated_strobes_module')
			if strcmp(finalstrobesnames{i},handles.info.init.calculated_strobes_module)
				findold=i;
			end
		end
	end		
end
set(handles.listbox3,'String',finalstrobesnames);
if findold>0
	handles.info.current_strobes_module=finalstrobesnames{findold};
	set(handles.listbox3,'Value',findold);
else
	handles.info.current_strobes_module=finalstrobesnames{finddefault};
	set(handles.listbox3,'Value',finddefault);
end
handles.info.defaults.default_strobes_module=finddefault;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% SAI
sainames = fieldnames(all_options.sai);
finalsainames=[];
finddefault=1;
findold=-1;

% TCW AIM2006 Reorder the list so that the default value comes first
for i=1:length(sainames)
    if strcmp(sainames{i},handles.info.default_start_module_sai)
		finalsainames=[sainames(i) finalsainames];  
    else
        finalsainames=[finalsainames sainames(i)];
    end
end

for i=1:length(finalsainames)
	if strcmp(finalsainames{i},handles.info.default_start_module_sai)
		finddefault=i;
	end
	if isfield(handles.info,'init')
		if isfield(handles.info.init,'calculated_sai_module')
			if strcmp(finalsainames{i},handles.info.init.calculated_sai_module)
				findold=i;
			end
		end
	end		
end
set(handles.listbox4,'String',finalsainames);
if findold>0
	handles.info.current_sai_module=finalsainames{findold};
	set(handles.listbox4,'Value',findold);
else
	handles.info.current_sai_module=finalsainames{finddefault};
	set(handles.listbox4,'Value',finddefault);
end
handles.info.defaults.default_sai_module=finddefault;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% USERMODULES
usermodulenames = fieldnames(all_options.usermodule);
finalusermodulenames=[];
finddefault=1;
findold=-1;

% TCW AIM2006 Reorder the list so that the default value comes first
for i=1:length(usermodulenames)
    if strcmp(usermodulenames{i},handles.info.default_start_module_usermodule)
		finalusermodulenames=[usermodulenames(i) finalusermodulenames];  
    else
        finalusermodulenames=[finalusermodulenames usermodulenames(i)];
    end
end

for i=1:length(finalusermodulenames)
	%finalusermodulenames=[finalusermodulenames usermodulenames(i)];
	% default value is dualprofile:
	if strcmp(finalusermodulenames{i},handles.info.default_start_module_usermodule)
		finddefault=i;
	end
	if isfield(handles.info,'init')
		if isfield(handles.info.init,'calculated_usermodule_module')
			if strcmp(finalusermodulenames{i},handles.info.init.calculated_usermodule_module)
				findold=i;
			end
		end
	end		

end
set(handles.listbox6,'String',finalusermodulenames);
if findold>0
	handles.info.current_usermodule_module=finalusermodulenames{findold};
	set(handles.listbox6,'Value',findold);
else
	handles.info.current_usermodule_module=finalusermodulenames{finddefault};
	set(handles.listbox6,'Value',finddefault);
end
handles.info.defaults.default_usermodule_module=finddefault;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% MOVIES
movienames = fieldnames(all_options.movie);
finalmovienames=[];
finddefault=1;
findold=-1;
for i=1:length(movienames)
	finalmovienames=[finalmovienames movienames(i)];
	% default value is dpai:
	if strcmp(finalmovienames{i},handles.info.default_start_module_movie)
		finddefault=i;
	end
	if isfield(handles.info,'init')
		if isfield(handles.info.init,'calculated_movie_module')
			if strcmp(finalmovienames{i},handles.info.init.calculated_movie_module)
				findold=i;
			end
		end
	end		

end
set(handles.listbox5,'String',finalmovienames);
if findold>0
	handles.info.current_movie_module=finalmovienames{findold};
	set(handles.listbox5,'Value',findold);
else
	handles.info.current_movie_module=finalmovienames{finddefault};
	set(handles.listbox5,'Value',finddefault);
end
handles.info.defaults.default_movie_module=finddefault;

		




% set all calculation orders to false
handles.info.calculate_signal=0;
handles.info.calculate_pcp=0;
handles.info.calculate_bmm=0;
handles.info.calculate_nap=0;
handles.info.calculate_strobes=0;
handles.info.calculate_sai=0;
handles.info.calculate_usermodule=0;
handles.info.calculate_movie=0;

% in the graphic version, store the results
handles.info.save_signal=1;
handles.info.save_pcp=1;
handles.info.save_bmm=1;
handles.info.save_nap=1;
handles.info.save_strobes=1;
handles.info.save_sai=1;
handles.info.save_usermodule=1;
handles.info.save_movie=1;




if isfield(handles.info,'init')
	set(handles.checkbox6,'Value',handles.info.init.hastime);
	set(handles.checkbox7,'Value',handles.info.init.hasfreq);
	set(handles.checkbox10,'Value',handles.info.init.hassignal);
	handles.info.old_current_plot=0;
	
else
	% set the frequency profile off
	set(handles.checkbox6,'Value',0);
	% set the temporal profile off
	set(handles.checkbox7,'Value',0);
	% set the signal on
	set(handles.checkbox10,'Value',1);
	% set the current visible plot (the signal alone)
	handles.info.current_plot=-1;
	handles.info.old_current_plot=0;
end



if isfield(handles.info,'init')
	duration=handles.info.init.duration;
	start_time=handles.info.init.start_time;
	scale=handles.info.init.scale;
else
	duration=0.04;
	start_time=0;
	scale=1;
end


sig=handles.data.signal;


% set up the combicontrols
handles.slideredit_start=slidereditcontrol_setup(...
	handles.slider2,... % handle of the slider
	handles.edit2,...% handle of the edit control
	getminimumtime(sig), ...	% min value
	getmaximumtime(sig), ...  % max value
	max(start_time,getminimumtime(sig)), ...  % current value
	0, ...  % islog
	1000, ...% multiplier on the edit control
	1);		% nr digits in the edit control after comma
handles.slideredit_duration=slidereditcontrol_setup(...
	handles.slider3,... % handle of the slider
	handles.edit3,...% handle of the edit control
	0.001, ...	% min value
	getlength(sig), ...  % max value
	duration, ...  % current value
	0, ...  % islog
	1000, ...% multiplier on the edit control
	1);		% nr digits in the edit control after comma
handles.slideredit_scale=slidereditcontrol_setup(...
	handles.slider1,... % handle of the slider
	handles.edit1,...% handle of the edit control
	0.001, ...	% min value
	1000, ...  % max value
	scale, ...  % current value
	1, ...  % islog
	1, ...% multiplier on the edit control
	3);		% nr digits in the edit control after comma
handles.slideredit_frames=slidereditcontrol_setup(...
	handles.slider2,... % handle of the slider
	handles.edit2,...% handle of the edit control
	1, ...	% min value
	100, ...  % max value
	start_time, ...  % current value
	0, ...  % islog
	1, ...% multiplier on the edit control
	0);		% nr digits in the edit control after comma

current_plot=handles.info.current_plot;
if current_plot<6
	handles.currentslidereditcombi=handles.slideredit_start;
else
	handles.slideredit_frames.maxvalue=length(handles.data.sai);
	handles.currentslidereditcombi=handles.slideredit_frames;
% 	handles.currentslidereditcombi=
end
% handles.slideredit_scale=slidereditcontrol_set_value(handles.slideredit_scale,scale);
% handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,duration);
handles.slideredit_start=slidereditcontrol_set_range(handles.slideredit_start,duration);

handles=aim_set_current_slider(handles);

% display the signal lenght and samplerate
len=getlength(sig);
if len>1
	set(handles.displayduration,'String',num2str(fround(getlength(sig),2)));
	set(handles.text20,'String','sec');
else
	set(handles.displayduration,'String',num2str(fround(getlength(sig)*1000,0)));
	set(handles.text20,'String','ms');
end
% samlerate
set(handles.text25,'String',num2str(fround(getsr(sig)/1000,1)));

% offset
if start_time>0
	set(handles.text29,'String',num2str(fround(start_time*1000,1)));
	set(handles.text29,'Visible','on');
	set(handles.text30,'Visible','on');
else
	set(handles.text29,'Visible','off');
	set(handles.text30,'Visible','off');
end


set(handles.edit1,'Enable','on');
set(handles.slider1,'Enable','on');
set(handles.edit2,'Enable','on');
set(handles.slider2,'Enable','on');
set(handles.edit3,'Enable','on');
set(handles.slider3,'Enable','on');


% set the displayed module name to the one that was loaded
if handles.info.pcp_loaded
	setstring(handles.listbox0,handles.info.current_pcp_module);end
if handles.info.bmm_loaded
	setstring(handles.listbox1,handles.info.current_bmm_module);end
if handles.info.nap_loaded
	setstring(handles.listbox2,handles.info.current_nap_module);end
if handles.info.strobes_loaded
	setstring(handles.listbox3,handles.info.current_strobes_module);end
if handles.info.sai_loaded
	setstring(handles.listbox4,handles.info.current_sai_module);end
if handles.info.usermodule_loaded
	setstring(handles.listbox6,handles.info.current_usermodule_module);end
if handles.info.movie_loaded
	setstring(handles.listbox5,handles.info.current_movie_module);end

if isfield(handles.info,'init')
	set(handles.checkbox6,'Value',handles.info.init.hastime);
	set(handles.checkbox7,'Value',handles.info.init.hasfreq);
	set(handles.checkbox10,'Value',handles.info.init.hassignal);
	handles.info.old_current_plot=0;
	
else
	% set the frequency profile off
	set(handles.checkbox6,'Value',0);
	% set the temporal profile off
	set(handles.checkbox7,'Value',0);
	% set the signal on
	set(handles.checkbox10,'Value',1);
	% set the current visible plot (the signal alone)
	handles.info.current_plot=-1;
	handles.info.old_current_plot=0;
end





handles.audioplayer_enabled = true;
try
	y=getvalues(sig);
	Fs=getsr(sig);
    player = audioplayer(y / abs(max(y)), Fs);  %make a player for the normalized signal
    set(player, 'UserData', handles.figure1, 'TimerPeriod', 0.05, 'TimerFcn', @update_audio_position, ...
        'StartFcn', @start_function);
    % the toolbar callback fcns look for these named bits of appdata 
    setappdata(hfig, 'theAudioPlayer', player); 
    setappdata(hfig, 'theAudioRecorder', []);
    selection.inPoint = 1;
    selection.outPoint = length(y);
    setappdata(hfig, 'audioSelection', selection); % selection starts as "full"
catch
    audioplayer_enabled = false;
end





return

function handles=setstring(hand,name)
strings=get(hand,'String');
nrstring=size(strings);
for i=1:nrstring
	if strcmp(strings{i},name)
		set(hand,'Value',i);
		return
	end
end
return