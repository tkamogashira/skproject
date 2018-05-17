% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%   the new soundfilename 
%   RETURN VALUE:
%	the updated handles
% 
% changes the soundfile and updates
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function handles=aim_exchange_sound_file(handles,signame)
% exchanges the sound file and keeps the parameters
% this works by deleting the directory
% saving the parameter file under new name
% recalculation of all stages up to the chosen one

% save some old values
oldhandles=handles;
slider_start=handles.slideredit_start;
slider_duration=handles.slideredit_duration;
slider_scale=handles.slideredit_scale;
slider_combi=handles.currentslidereditcombi;
slider_frames=handles.slideredit_frames;


handles=setupnames(handles,signame);
dirname=handles.info.directoryname;


loadswitch=0;
if exist(dirname)~=7 % is not a directory so far
	% load the project
	handles=init_aim_parameters(handles,signame);
	loadswitch=1;
end	

% if exist(dirname)==7 % is a directory with a project in (hopefully)
wave_switch=get(handles.checkbox10,'Value');
spectral_switch=get(handles.checkbox6,'Value');
temporal_switch=get(handles.checkbox7,'Value');

% copy the project-file to the new directory:
oldpfile=fullfile(pwd,oldhandles.info.projectfilename);
newpfile=fullfile(pwd,handles.info.projectfilename);
try
	copyfile(oldpfile,newpfile);
catch
	what=0;
end

if 	loadswitch==0
	% load the project
	handles=init_aim_parameters(handles,signame);
end

tempinfo=handles.info;
% the signal options have been overwritten, so set them back:
handles.all_options.signal.start_time=oldhandles.all_options.signal.start_time;
handles.all_options.signal.duration=oldhandles.all_options.signal.duration;
handles.all_options.signal.samplerate=oldhandles.all_options.signal.samplerate;
handles=init_aim_gui(handles);

tempoptions=handles.all_options;
% 	tempinfo=handles.info;

% copy the parameter file to the new directory
oldpfile=fullfile(pwd,oldhandles.info.parameterfilename);
newpfile=fullfile(pwd,handles.info.parameterfilename);
try
	copyfile(oldpfile,newpfile);
catch
	disp('error in aim_exchange_sound_file: parameter file could not be copied');
end

% handles.info.current_pcp_module=
handles=do_aim_updateparameters(handles);

% set the current modules to the new ones, and set ticks if neccessary:
handles=setselection(handles,'pcp',oldhandles.info.current_pcp_module);
handles=setselection(handles,'bmm',oldhandles.info.current_bmm_module);
handles=setselection(handles,'nap',oldhandles.info.current_nap_module);
handles=setselection(handles,'strobes',oldhandles.info.current_strobes_module);
handles=setselection(handles,'sai',oldhandles.info.current_sai_module);
handles=setselection(handles,'usermodule',oldhandles.info.current_usermodule_module);
handles=setselection(handles,'movie',oldhandles.info.current_movie_module);

% handles=init_aim_gui(handles);

changepcp=get(handles.checkbox0,'Value') || handles.info.calculate_pcp;
changebmm=get(handles.checkbox1,'Value')|| handles.info.calculate_bmm;
changenap=get(handles.checkbox2,'Value')|| handles.info.calculate_nap;
changestrobes=get(handles.checkbox3,'Value')|| handles.info.calculate_strobes;
changesai=get(handles.checkbox4,'Value')|| handles.info.calculate_sai;
changeusermodule=get(handles.checkbox8,'Value')|| handles.info.calculate_usermodule;
changemovie=get(handles.checkbox5,'Value')|| handles.info.calculate_movie;
if oldhandles.info.pcp_loaded==1 && (handles.info.pcp_loaded==0 || changepcp==1)
	handles.info.calculate_pcp=1;
	changepcp=1;
	set(handles.checkbox0,'Value',1);
end
if oldhandles.info.bmm_loaded==1 && (handles.info.bmm_loaded==0 || changebmm==1 || (handles.info.bmm_loaded==1 && changepcp==1))
	handles.info.calculate_bmm=1;
	changebmm=1;
	set(handles.checkbox1,'Value',1);
end
if oldhandles.info.nap_loaded==1 && (handles.info.nap_loaded==0 || changenap==1 || (handles.info.nap_loaded==1 && changebmm==1))
	handles.info.calculate_nap=1;
	changenap=1;
	set(handles.checkbox2,'Value',1);
end	
if oldhandles.info.strobes_loaded==1 && (handles.info.strobes_loaded==0 || changestrobes==1|| (handles.info.strobes_loaded==1 && changenap==1))
	handles.info.calculate_strobes=1;
	changestrobes=1;
	set(handles.checkbox3,'Value',1);
end	
if oldhandles.info.sai_loaded==1 && (handles.info.sai_loaded==0 || changesai==1|| (handles.info.sai_loaded==1 && changestrobes==1))
	handles.info.calculate_sai=1;
	changesai=1;
	set(handles.checkbox4,'Value',1);
end	
if oldhandles.info.usermodule_loaded==1 && (handles.info.usermodule_loaded==0 || changeusermodule==1 || (handles.info.usermodule_loaded==1 && changesai==1))
	handles.info.calculate_usermodule=1;
	changeusermodule=1;
	set(handles.checkbox8,'Value',1);
end	
if oldhandles.info.movie_loaded==1 && (handles.info.movie_loaded==0 || changemovie==1 || (handles.info.movie_loaded==1 && changesai==1))
	handles.info.calculate_movie=1;
	changemovie=1;
	set(handles.checkbox5,'Value',1);
end	

% if the new project has more columns active then the old one, then
% delete the surplus
if oldhandles.info.pcp_loaded ==0
	handles=aim_deletefile(handles,'pcp');
end
if oldhandles.info.bmm_loaded ==0 
	handles=aim_deletefile(handles,'bmm');
end
if oldhandles.info.nap_loaded  ==0
	handles=aim_deletefile(handles,'nap');
end
if oldhandles.info.strobes_loaded==0
	handles=aim_deletefile(handles,'strobes');
end
if oldhandles.info.sai_loaded==0
	handles=aim_deletefile(handles,'sai');
end
if oldhandles.info.usermodule_loaded==0
	handles=aim_deletefile(handles,'usermodule');
end


handles=do_aim_calculate(handles);

% reset the signal options to the new ones:
handles.all_options.signal=tempoptions.signal;
handles=aim_saveparameters(handles,handles.info.parameterfilename,1);


% force the sliders to the same values as before:
handles.slideredit_start=slider_start;
handles.slideredit_duration=slider_duration;
handles.slideredit_scale=slider_scale;
handles.currentslidereditcombi=slider_combi;
handles.slideredit_frames=slider_frames;

set(handles.checkbox10,'Value',wave_switch);
set(handles.checkbox6,'Value',spectral_switch);
set(handles.checkbox7,'Value',temporal_switch);

return


function handles=setselection(handles,selstr,curmod)
switch selstr
	case('pcp')
		hand=handles.listbox0;
		hand2=handles.checkbox0;
		oldnam=handles.info.current_pcp_module;
		handles.info.current_pcp_module=curmod;
	case('bmm')
		hand=handles.listbox1;
		hand2=handles.checkbox1;
		oldnam=handles.info.current_bmm_module;
		handles.info.current_bmm_module=curmod;
	case('nap')
		hand=handles.listbox2;
		hand2=handles.checkbox2;
		oldnam=handles.info.current_nap_module;
		handles.info.current_nap_module=curmod;
	case('strobes')
		hand=handles.listbox3;
		hand2=handles.checkbox3;
		oldnam=handles.info.current_strobes_module;
		handles.info.current_strobes_module=curmod;
	case('sai')
		hand=handles.listbox4;
		hand2=handles.checkbox4;
		oldnam=handles.info.current_sai_module;
		handles.info.current_sai_module=curmod;
	case('usermodule')
		hand=handles.listbox6;
		hand2=handles.checkbox8;
		oldnam=handles.info.current_usermodule_module;
		handles.info.current_usermodule_module=curmod;
	case('movie')
		hand=handles.listbox5;
		hand2=handles.checkbox5;
		oldnam=handles.info.current_movie_module;
		handles.info.current_movie_module=curmod;
end
% it the new module is different from the old one, then set the tick
if ~strcmp(oldnam,curmod)
	set(hand2,'Value',1);
end

names=get(hand,'String');
for i=1:length(names)
	if strcmp(names{i},curmod)
		set(hand,'Value',i);
		return
	end
end
return
