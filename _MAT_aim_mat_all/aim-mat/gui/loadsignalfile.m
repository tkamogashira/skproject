% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% load the signal file and all files, that are in this directory
% set the project variables accordingly.
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function handles=loadsignalfile(handles,signame);


signalname=handles.info.signalname;
signalwavename=handles.info.signalwavename;
oldsignalwavename=handles.info.oldsignalwavename;
pcpname=handles.info.pcpname;
bmmname=handles.info.bmmname;
napname=handles.info.napname;
strobesname=handles.info.strobesname;
thresholdsname=handles.info.thresholdsname;
sainame=handles.info.sainame;
usermodulename=handles.info.usermodulename;
moviename=handles.info.moviename;


% load the parameterfile:
if fexist(handles.info.parameterfilename)
	workdir=pwd;
	cd(handles.info.directoryname);
	[a,parfile,c,d]=fileparts(handles.info.parameterfilename);
	clear all_options;
	eval(parfile);
	cd(workdir);
end



if fexist(signalname)
	[sig,sigoptions]=aim_loadfile(signalname);
else   
	if fexist(signalwavename)
		sig=loadwavefile(signal,signalwavename);
		% and save the wavefile hinterher:
		%         nsf=sprintf('%s\\%s',handles.info.directoryname,signalwavename);
		%         copyfile(signalwavename,nsf);
		% 		delete(signalwavename);
		% 		signalwavename=nsf;
	elseif fexist(oldsignalwavename)
		sig=loadwavefile(signal,oldsignalwavename);
		% and save the wavefile hinterher:
		nsf=sprintf('%s\\%s',handles.info.directoryname,oldsignalwavename);
		copyfile(oldsignalwavename,nsf);
		% 		delete(oldsignalwavename);
		signalwavename=nsf;
	else
		% 		handles=0;
		return
	end
end
handles.data.sig=sig;
len=getlength(sig);
if len<0.04
	str=sprintf('Signal %s too short',signame);
	er=errordlg(str,'File Error');
	set(er,'WindowStyle','modal');
	pause;
	handles=0;
	return
end


handles.info.signal_loaded=1;    
% we add these parameters to the parameter file (for the future)
handles.all_options.signal.signal_filename=handles.info.oldsignalwavename;
handles.all_options.signal.start_time=0;
handles.all_options.signal.duration=getlength(sig);
handles.all_options.signal.samplerate=getsr(sig);
signalstruct.data=sig;
signalstruct.options=handles.all_options.signal;

% if the samplerate is too high, sample it down per default
sr=22050;
if handles.all_options.signal.samplerate>sr
% 	ask user if he wants that hi sample rate
	srneu=input('The samplerate of the specified signal \nis higher then 22050 Hz. \nPlease insert a smaller samperate \n(or return for keeping the old one): ');
	if ~isempty(srneu)
		sig=changesr(sig,srneu);
		handles.all_options.signal.samplerate=srneu;
		signalstruct.data=sig;
		handles.data.sig=sig;
	end
end


save(signalname,'signalstruct');
savewave(sig,signalwavename,0);

if fexist(pcpname)
	[pcp,type,options]=aim_loadfile(pcpname);
	handles.data.pcp=pcp;
	handles.info.pcp_loaded=1;
	handles.info.calculated_pcp_module=type;	% this one is really calculated
	select(handles.listbox0,type);
	if ~isempty(type)
		str=sprintf('handles.all_options.pcpoptions.%s=options;',type);
		eval(str);
	else    % old style
		type='ELC';
		handles.all_options.pcpoptions=options;
		sai_savefile(pcp,pcpname,type,options,handles.all_options);
	end
else
	handles.info.pcp_loaded=0;
end

if fexist(bmmname)
	[bmm,type,options]=aim_loadfile(bmmname);
	handles.data.bmm=bmm;
	handles.info.bmm_loaded=1;
	handles.info.calculated_bmm_module=type;	% this one is really calculated
			
	select(handles.listbox1,type);
else
	handles.info.bmm_loaded=0;
end
if fexist(napname)
	[nap,type,options]=aim_loadfile(napname);
	handles.data.nap=nap;
	handles.info.nap_loaded=1;
	select(handles.listbox2,type);
else
	handles.info.nap_loaded=0;
end
if fexist(strobesname)
	[strobes,type,options]=aim_loadfile(strobesname);
	if fexist(thresholdsname)
		thresholds=aim_loadfile(thresholdsname);
		handles.data.thresholds=thresholds;
	end
	handles.data.strobes=strobes;
	handles.info.strobes_loaded=1;
	handles.info.calculated_strobes_module=type;	% this one is really calculated
	select(handles.listbox3,type);
else
	handles.info.strobes_loaded=0;
end

if fexist(sainame)
	[sai,type,options]=aim_loadfile(sainame);
	handles.data.sai=sai;
	handles.info.sai_loaded=1;
	handles.info.calculated_sai_module=type;	% this one is really calculated
	select(handles.listbox4,type);
	
	nr_frames=length(sai);
	handles.slideredit_frames.minvalue=1;
	handles.slideredit_frames.maxvalue=nr_frames;
	% set the framecounter
	handles.slideredit_frames=slidereditcontrol_set_value(handles.slideredit_frames,nr_frames);	% set to the end
	handles.slideredit_frames=slidereditcontrol_set_range(handles.slideredit_frames,nr_frames);	% the duration
	
else
	handles.info.sai_loaded=0;
end

if fexist(usermodulename)
	[usermodule,type,options]=aim_loadfile(usermodulename);
	handles.data.usermodule=usermodule;
	handles.info.usermodule_loaded=1;
	handles.info.calculated_usermodule_module=type;	% this one is really calculated

	select(handles.listbox6,type);
	handles.info.usermodule_loaded=1;
else
	handles.info.usermodule_loaded=0;
end

% TODO: only the first available movie is loaded. The others not
handles.info.movie_loaded=0;
if length(moviename)>1
	for i=1:length(moviename)
		cname=moviename{i};
		if fexist(cname)
			handles.info.movie_loaded=1;
			handles.info.calculated_movie_module=cname;	% this one is really calculated
			break
		end
	end
end

% change the sliders according to the new signal:
% combi_start=handles.slideredit_start;
% combi_duration=handles.slideredit_start;

duration=0.04;
start_time=getminimumtime(sig);

handles.slideredit_duration.maxvalue=getlength(sig);
handles.slideredit_duration.minvalue=0.005;
handles.slideredit_start.minvalue=start_time;
handles.slideredit_start.maxvalue=getlength(sig);

handles.slideredit_start=slidereditcontrol_set_range(handles.slideredit_start,duration);	% the duration
% handles.slideredit_duration=slidereditcontrol_set_range(handles.slideredit_duration,duration);	% the duration
handles.slideredit_start=slidereditcontrol_set_value(handles.slideredit_start,start_time);	% set to the beginning of the signal
handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,duration);	% set to the beginning of the signal




set(handles.displayduration,'String',num2str(fround(getlength(sig)*1000,1)));



% % start_time=offset;
% set(handles.edit2,'String',num2str(start_time*1000));
% set(handles.edit3,'String',num2str(duration*1000));
% 
% 
% set(handles.slider3,'Value',0);
% set(handles.slider3,'Value',duration/max_duration);
% 
% handles.data.min_duration=min_duration;
% handles.data.max_duration=max_duration;
% handles.data.max_start_time=max_start_time;
% handles.data.min_start_time=min_start_time;
% 
% set(handles.edit1,'String',num2str(1));
% handles.data.min_scale=0.001;
% handles.data.max_scale=1000;
% set(handles.slider1,'Value',f2f(1,handles.data.min_scale,handles.data.max_scale,0,1,'loglin'));

% set(handles.pushbutton8,'Enable','on');
% set(handles.pushbutton9,'Enable','on');
% set(handles.pushbutton10,'Enable','on');
set(handles.edit1,'Enable','on');
set(handles.slider1,'Enable','on');
set(handles.edit2,'Enable','on');
set(handles.slider2,'Enable','on');
set(handles.edit3,'Enable','on');
set(handles.slider3,'Enable','on');


% aim_saveparameters(handles);


function select(hand,what)
str=get(hand,'String');
for i=1:length(str)
	if strcmp(str,what)
		set(hand,'Value',i);
		return
	end
end
return

