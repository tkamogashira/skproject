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



function handles=do_aim_updateparameters(handles)
% return the pointer shape
if handles.with_graphic==1
	set(handles.figure1,'Pointer','watch');
    wbh=waitbar(0,'Updating Parameters... Please Wait'); 
end


% set the checkboxes according to the changes in the parameterfile. If
% changes have occured from the parameterfile relativ to the options in
% handles, the associated checkbox is checked. A further call to
% aim_calculate then does the rest

oldoptions=handles.all_options;
parfile=handles.info.parameterfilename;

olddir=pwd;
[pathstr,name,ext] = fileparts(parfile);
cd(pathstr);
eval(name);    % here it is evaluated 
cd(olddir);
if handles.with_graphic==1
    waitbar(0.2,wbh); 
end
% 
% wo=strfind(parfile,'.m');
% if ~isempty(wo)
%     parfile=parfile(1:wo-1);
% end
% 
% [a,b,c]=fileparts(parfile);
% cd(a);
% parfile=parfile(strfind(parfile,'/')+1:end);
% eval(parfile);
% cd ..
newoptions=all_options;

% compare the old and the new parameters to see, what must be changed
if ~structisequal(oldoptions.pcp,newoptions.pcp)
    set(handles.checkbox0,'Value',1);
	handles.info.calculate_pcp=1;
else
    set(handles.checkbox0,'Value',0);
	handles.info.calculate_pcp=0;
end
if handles.with_graphic==1
    waitbar(0.3,wbh); 
end
if ~structisequal(oldoptions.bmm,newoptions.bmm)
    set(handles.checkbox1,'Value',1);
	handles.info.calculate_bmm=1;
else
    set(handles.checkbox1,'Value',0);
	handles.info.calculate_bmm=0;
end
if handles.with_graphic==1
    waitbar(0.4,wbh); 
end
if ~structisequal(oldoptions.nap,newoptions.nap)
    set(handles.checkbox2,'Value',1);
	handles.info.calculate_nap=1;
else
    set(handles.checkbox2,'Value',0);
	handles.info.calculate_nap=0;
end
if handles.with_graphic==1
    waitbar(0.5,wbh); 
end
if ~structisequal(oldoptions.strobes,newoptions.strobes)
    set(handles.checkbox3,'Value',1);
	handles.info.calculate_strobes=1;
else
    set(handles.checkbox3,'Value',0);
	handles.info.calculate_strobes=0;
end
if handles.with_graphic==1
    waitbar(0.6,wbh); 
end
if ~structisequal(oldoptions.sai,newoptions.sai)
    set(handles.checkbox4,'Value',1);
	handles.info.calculate_sai=1;
else
    set(handles.checkbox4,'Value',0);
	handles.info.calculate_sai=0;
end
if handles.with_graphic==1
    waitbar(0.7,wbh); 
end
if ~structisequal(oldoptions.usermodule,newoptions.usermodule)
    set(handles.checkbox8,'Value',1);
	handles.info.calculate_usermodule=1;
else
    set(handles.checkbox8,'Value',0);
	handles.info.calculate_usermodule=0;
end
% if ~structisequal(oldoptions.movie,newoptions.movie)
%     set(handles.checkbox5,'Value',1);
% 	handles.info.calculate_movie=1;
% else
%     set(handles.checkbox5,'Value',0);
% 	handles.info.calculate_movie=0;
% end

if handles.with_graphic==1
    waitbar(0.8,wbh); 
end
% check, if the signal time has changed, if, redo everything!
changesig=0;
if oldoptions.signal.start_time~=newoptions.signal.start_time
	changesig=1;
end
if oldoptions.signal.duration~=newoptions.signal.duration
	changesig=1;
end
if oldoptions.signal.samplerate~=newoptions.signal.samplerate
	changesig=1;
end

% if ~structisequal(oldoptions.signal,newoptions.signal)
if changesig==1
	new_duration=newoptions.signal.duration;
	new_start_time=newoptions.signal.start_time;
	new_sr=newoptions.signal.samplerate;
	
% 	if new_start_time+new_duration>handles.all_options.signal.original_duration
% 		error('fehler in do_aim_updateparameters ');
% 	end
	
	
	if handles.info.pcp_loaded==1
	    set(handles.checkbox0,'Value',1);
		handles.info.calculate_pcp=1;
	end
	if handles.info.bmm_loaded==1
	    set(handles.checkbox1,'Value',1);
		handles.info.calculate_bmm=1;
	end
	if handles.info.nap_loaded==1
	    set(handles.checkbox2,'Value',1);
		handles.info.calculate_nap=1;
	end
	if handles.info.strobes_loaded==1
	    set(handles.checkbox3,'Value',1);
		handles.info.calculate_strobes=1;
	end
	if handles.info.sai_loaded==1
	    set(handles.checkbox4,'Value',1);
		handles.info.calculate_sai=1;
	end
	if handles.info.usermodule_loaded==1
	    set(handles.checkbox8,'Value',1);
		handles.info.calculate_usermodule=1;
	end
	if handles.info.movie_loaded==1
	    set(handles.checkbox5,'Value',1);
		handles.info.calculate_movie=1;
	end
	handles.info.calculate_signal=1;
	
	
	% change the slider etc...
	if new_duration>1
		set(handles.displayduration,'String',num2str(fround(new_duration,2)));
		set(handles.text20,'String','sec');
	else
		set(handles.displayduration,'String',num2str(fround(new_duration*1000,0)));
		set(handles.text20,'String','ms');
	end
	% samplerate
	set(handles.text25,'String',num2str(fround(new_sr/1000,1)));
	% offset
	if new_start_time>0
		set(handles.text29,'String',num2str(fround(new_start_time*1000,1)));
		set(handles.text29,'Visible','on');
		set(handles.text30,'Visible','on');
	else
		set(handles.text29,'Visible','off');
		set(handles.text30,'Visible','off');
	end	
	handles.slideredit_start.minvalue=new_start_time;
	handles.slideredit_start.maxvalue=new_start_time+new_duration-0.04;
	handles.slideredit_start=slidereditcontrol_set_value(handles.slideredit_start,new_start_time);
	handles.slideredit_start=slidereditcontrol_set_range(handles.slideredit_start,new_duration/10);
	
	handles.slideredit_duration=slidereditcontrol_set_value(handles.slideredit_duration,0.04);
	handles.slideredit_duration.maxvalue=new_duration;
	handles.slideredit_duration=slidereditcontrol_set_range(handles.slideredit_duration,new_duration/10);
	
	handles.currentslidereditcombi=handles.slideredit_start;
	
else
	handles.info.calculate_signal=0;
end

if handles.with_graphic==1
    waitbar(0.9,wbh); 
end
% set the current info in handles to the current values
generating_module_string=get(handles.listbox0,'String');
generating_module=generating_module_string(get(handles.listbox0,'Value'));
if ~isfield(handles.info,'current_pcp_module') || ~strcmp(handles.info.current_pcp_module,generating_module{1})
	handles.info.calculate_pcp=1;
    set(handles.checkbox0,'Value',1);
end	
handles.info.current_pcp_module=generating_module{1};

generating_module_string=get(handles.listbox1,'String');
generating_module=generating_module_string(get(handles.listbox1,'Value'));
if ~isfield(handles.info,'current_bmm_module') || ~strcmp(handles.info.current_bmm_module,generating_module{1})
	handles.info.calculate_bmm=1;
    set(handles.checkbox1,'Value',1);
end	
handles.info.current_bmm_module=generating_module{1};

generating_module_string=get(handles.listbox2,'String');
generating_module=generating_module_string(get(handles.listbox2,'Value'));
if ~isfield(handles.info,'current_nap_module') || ~strcmp(handles.info.current_nap_module,generating_module{1})
	handles.info.calculate_nap=1;
    set(handles.checkbox2,'Value',1);
end	
handles.info.current_nap_module=generating_module{1};

generating_module_string=get(handles.listbox3,'String');
generating_module=generating_module_string(get(handles.listbox3,'Value'));
if ~isfield(handles.info,'current_strobes_module') || ~strcmp(handles.info.current_strobes_module,generating_module{1})
	handles.info.calculate_strobes=1;
    set(handles.checkbox3,'Value',1);
end	
handles.info.current_strobes_module=generating_module{1};

generating_module_string=get(handles.listbox4,'String');
generating_module=generating_module_string(get(handles.listbox4,'Value'));
if ~isfield(handles.info,'current_sai_module') || ~strcmp(handles.info.current_sai_module,generating_module{1})
	handles.info.calculate_sai=1;
    set(handles.checkbox4,'Value',1);
end	
handles.info.current_sai_module=generating_module{1};

generating_module_string=get(handles.listbox6,'String');
generating_module=generating_module_string(get(handles.listbox6,'Value'));
if ~isfield(handles.info,'current_usermodule_module') || ~strcmp(handles.info.current_usermodule_module,generating_module{1})
	handles.info.calculate_usermodule=1;
    set(handles.checkbox8,'Value',1);
end	
handles.info.current_usermodule_module=generating_module{1};

generating_module_string=get(handles.listbox5,'String');
generating_module=generating_module_string(get(handles.listbox5,'Value'));
if ~isfield(handles.info,'current_movie_module') || ~strcmp(handles.info.current_movie_module,generating_module{1})
	handles.info.calculate_movie=1;
    set(handles.checkbox5,'Value',1);
end	
handles.info.current_movie_module=generating_module{1};


% put some additional information in the info-domain
handles.info.save_pcp=1;
handles.info.save_bmm=1;
handles.info.save_nap=1;
handles.info.save_sai=1;
handles.info.save_strobes=1;
handles.info.save_usermodule=1;
handles.info.save_movie=1;


% and update the new parameters
handles.all_options=newoptions;

if handles.with_graphic==1
    waitbar(1,wbh);
    close(wbh);
    set(handles.figure1,'Pointer','arrow');
end