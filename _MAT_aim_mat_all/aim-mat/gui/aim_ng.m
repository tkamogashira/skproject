% procedure for 'aim-mat'
% 
%   INPUT VALUES:
% 		paramfile	: the name of a m-file with all relevant parameters for the project
% 					OR: the name of an struct with all relevant information
%
%   RETURN VALUE:
%		result	: the output of the last stage in the parameter file
% 
% aim_ng (aim no graphic) calculates aim up to the stage of that is indicated 
% by the parameters in the file
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function result=aim_ng(paramfile)

if isstruct(paramfile)
	all_options=paramfile;
else
	olddir=pwd;
	[pathstr,name,ext] = fileparts(paramfile);
	if ~isempty(pathstr)
        cd(pathstr);
    end
	try
		eval(name); % evaluate the parameter file. Afterwards we have a set of parameters (hopefully in all_options)
		cd(olddir);
	catch
		str=sprintf('The parameter file %s.m produced errors!',name);
		er=errordlg(str,'File Error');
		set(er,'WindowStyle','modal');
		pause;
		result=0;
		cd olddir;
		return
	end
end

handles=[];
if isstruct(paramfile)
	if isfield(paramfile,'graphics')
		handles.all_options.graphics=paramfile.graphics;
	end
end

% signalname:
signame=all_options.signal.signal_filename;

% set up all names, in case we need them:
handles=setupnames(handles,signame);

% no graphic please!
handles.with_graphic=0;

% in the no graphic version, do not store the results
handles.info.save_signal=0;
handles.info.save_pcp=0;
handles.info.save_bmm=0;
handles.info.save_nap=0;
handles.info.save_strobes=0;
handles.info.save_sai=0;
handles.info.save_usermodule=0;
handles.info.save_movie=0;
% default values
handles.info.calculate_signal=0;
handles.info.calculate_pcp=0;
handles.info.calculate_bmm=0;
handles.info.calculate_nap=0;
handles.info.calculate_strobes=0;
handles.info.calculate_sai=0;
handles.info.calculate_usermodule=0;
handles.info.calculate_movie=0;



% first load the signal, that must be there!
sigfile=all_options.signal.signal_filename;
% where=strfind(sigfile,'.wav');
% handles.info.uniqueworkingname=sigfile(1:where-1);

handles.all_options.signal=all_options.signal;
sig=loadwavefile(signal,sigfile);
handles.data.signal=sig;
handles.data.original_signal=sig;

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

handles=do_aim_calculate(handles);
handles.error=0;

result=handles;

if isfield(all_options,'pcp')
	result.result=handles.data.pcp;
end
if isfield(all_options,'bmm')
	result.result=handles.data.bmm;
end
if isfield(all_options,'nap')
	result.result=handles.data.nap;
end
if isfield(all_options,'strobes')
	result.result=handles.data.strobes;
end
if isfield(all_options,'sai')
	result.result=handles.data.sai;
end
if isfield(all_options,'usermodule')
	result.result=handles.data.usermodule;
end
if isfield(all_options,'movie')
end

