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



function handles=createparameterfile(handles,paramname)
% create parameters from that file
% when no second parameter is given, then load it using the standart way:
% go through all directories and call the single module-parameterfiles


if nargin==1    % if no parameter file is given, then take the standart one
	% first load the default values from the default parameter file:
	handles=loadallparameterfiles(handles);
    if handles.error==1 
        return
    end
	
	if isfield(handles,'initial_options')	% aim was called with initial parameters
		% overwrite the parameters accordingly:
		handles=aim_loadpersonal_defaults(handles);	% take these anyhow
		
		% the signal in any case:
		handles.all_options.signal=handles.initial_options.signal;
		
		if isfield(handles.initial_options,'pcp')
			handles.info.calculate_pcp=1;
			module_names=fieldnames(handles.initial_options.pcp);	% find out, which module name
			module_name=module_names{1}; % only the first one is relevant!
			handles.info.current_pcp_module=module_name;	% this one is the current one
			str=sprintf('handles.all_options.pcp%s=handles.initial_options.pcp.%s;',module_name,module_name);
			eval(str);
		end
		if isfield(handles.initial_options,'bmm')
			handles.info.calculate_bmm=1;
			module_names=fieldnames(handles.initial_options.bmm);	% find out, which module name
			module_name=module_names{1}; % only the first one is relevant!
			handles.info.current_bmm_module=module_name;	% this one is the current one
			str=sprintf('handles.all_options.bmm.%s=handles.initial_options.bmm.%s;',module_name,module_name);
			eval(str);
		end
		if isfield(handles.initial_options,'nap')
			handles.info.calculate_nap=1;
			module_names=fieldnames(handles.initial_options.nap);	% find out, which module name
			module_name=module_names{1}; % only the first one is relevant!
			handles.info.current_nap_module=module_name;	% this one is the current one
			str=sprintf('handles.all_options.nap.%s=handles.initial_options.nap.%s;',module_name,module_name);
			eval(str);
		end
		if isfield(handles.initial_options,'strobes')
			handles.info.calculate_strobes=1;
			module_names=fieldnames(handles.initial_options.strobes);	% find out, which module name
			module_name=module_names{1}; % only the first one is relevant!
			handles.info.current_strobes_module=module_name;	% this one is the current one
			str=sprintf('handles.all_options.strobes.%s=handles.initial_options.strobes.%s;',module_name,module_name);
			eval(str);
		end
		if isfield(handles.initial_options,'sai')
			handles.info.calculate_sai=1;
			module_names=fieldnames(handles.initial_options.sai);	% find out, which module name
			module_name=module_names{1}; % only the first one is relevant!
			handles.info.current_sai_module=module_name;	% this one is the current one
			str=sprintf('handles.all_options.sai.%s=handles.initial_options.sai.%s;',module_name,module_name);
			eval(str);
		end
		if isfield(handles.initial_options,'usermodule')
			handles.info.calculate_usermodule=1;
			module_names=fieldnames(handles.initial_options.usermodule);	% find out, which module name
			module_name=module_names{1}; % only the first one is relevant!
			handles.info.current_usermodule_module=module_name;	% this one is the current one
			str=sprintf('handles.all_options.usermodule.%s=handles.initial_options.usermodule.%s;',module_name,module_name);
			eval(str);
		end
		if isfield(handles.initial_options,'movie')
			handles.info.calculate_movie=1;
			module_names=fieldnames(handles.initial_options.movie);	% find out, which module name
			module_name=module_names{1}; % only the first one is relevant!
			handles.info.current_movie_module=module_name;	% this one is the current one
			str=sprintf('handles.all_options.movie.%s=handles.initial_options.movie.%s;',module_name,module_name);
			eval(str);
		end
		
	else
		% fill in some parameters for the signal:
		handles.all_options.signal.signal_filename='';
		handles.all_options.signal.start_time=0;
		handles.all_options.signal.duration=1;
		handles.all_options.signal.samplerate=16000;
		handles=aim_loadpersonal_defaults(handles);
		handles=aim_loadpersonal_defaults(handles);
		return
	end
else % the parameter file is given as a paramter. So load it!
	
	olddir=pwd;
	[pathstr,name,ext] = fileparts(paramname)
	cd(pathstr);
	eval(name);    % here it is evaluated 
	cd olddir;
	
	
	handles.all_options=all_options;
	handles=aim_saveparameters(handles,handles.info.parameterfilename);
end



