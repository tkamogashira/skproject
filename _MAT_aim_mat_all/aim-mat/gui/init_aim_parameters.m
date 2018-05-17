% procedure for 'aim-mat'
%
%   INPUT VALUES:
%  		handles	: all relevant parameters
%
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function handles=init_aim_parameters(handles,filename)

% reset program:
handles.info=[];
handles.data=[];
handles.slideredit_start=[];
handles.slideredit_duration=[];
handles.slideredit_scale=[];
handles.slideredit_frames=[];
handles.currentslidereditcombi=[];
handles.all_options=[];

handles.info.default_start_module_pcp='gm2002';
handles.info.default_start_module_bmm='dcgc';
handles.info.default_start_module_nap='hl';
handles.info.default_start_module_strobes='sf2003';
handles.info.default_start_module_sai='ti2003';
handles.info.default_start_module_usermodule='mellin';
handles.info.default_start_module_movie='screen';

% set up all names, that we need in this project
handles=setupnames(handles,filename);

% check, wheter there is an existing project, if yes, load it
directoryname=handles.info.directoryname;
% if directory is empty, delete it
if exist(lower(directoryname))==7 || exist(directoryname)==7
	cd(directoryname);
	dir_struct = dir;
	if length(dir_struct)<=2
		cd ..
% ELN fix:
        ELNmessage=rmdir(directoryname);
	else
		cd ..
	end
end

if exist(lower(directoryname))==7 || exist(directoryname)==7
	% first load the standart parameters. Maybe some new modules are added.
	% Old data is overwritten in the process.
	handles=createparameterfile(handles);
    if handles.error==1
        return
    end
	handles=aim_loadproject(handles);
	handles=aim_loadcurrentstate(handles);
else
	% otherwise create a new project
        % ELN fix:
    ELNmessage=mkdir(directoryname);
	handles.info.pcp_loaded=0;
	handles.info.bmm_loaded=0;
	handles.info.nap_loaded=0;
	handles.info.strobes_loaded=0;
	handles.info.sai_loaded=0;
	handles.info.usermodule_loaded=0;
	handles.info.movie_loaded=0;
 	handles=createparameterfile(handles);   % create standart parameters
	handles=aim_loadsignalfile(handles,filename); % load the signal file and set up
	handles=aim_saveparameters(handles,handles.info.parameterfilename);    % and save them again in case, they are overwritten
end




