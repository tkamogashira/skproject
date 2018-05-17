% procedure for 'aim-mat'
% 
% function handles=aim_saveparameters(handles,filename,all_parameters)
% 
%   INPUT VALUES:
%  		handles: all relevant information
% 		filename: which file 
% 		all_parameters: switch, whether all parameters shell be saved or only the relevant ones
%   RETURN VALUE:
%		handles: the updated handles
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function handles=aim_saveparameters(handles,filename,all_parameters)

if nargin < 3
	all_parameters=1;	% save all parameters, not only the project relevant
end


id=fopen(filename,'wt');
lines=struct2stringarray(handles.all_options.bmm,'all_options.bmm');
fprintf(id,'\n%% Parameters');
fprintf(id,'\n%% for the project: \n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(id,'\n%%');
filename=sprintf('   %s\n',handles.info.uniqueworkingname);
fprintf(id,filename);
fprintf(id,'%%   %s',date);
fprintf(id,'\n%%   produced by ');
result = license('inuse');
cuser=result(1).user;
fprintf(id,'%s',cuser);
fprintf(id,'\n');
fprintf(id,'\n\n%% Dont write anything in this file except for parameter values, \n%% since all other changes will be lost');
fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
% fprintf(id,'\nclear all_options; %% clear the options initially to remove any old entries');
% fprintf(id,'\n');

if all_parameters==1	% save all parameters
	lines=struct2stringarray(handles.all_options.signal,'all_options.signal');
	fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
	fprintf(id,'\n%% Signaloptions\n');
	for i=1:length(lines)
		fprintf(id,lines{i});
		fprintf(id,';\n');
	end
	
	lines=struct2stringarray(handles.all_options.pcp,'all_options.pcp');
	fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
	fprintf(id,'\n%% outer/middle ear filter function\n');
	for i=1:length(lines)   
		text=lines{i};
		% 		if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
		fprintf(id,text);
		fprintf(id,';\n');
		% 		end
	end
	
	lines=struct2stringarray(handles.all_options.bmm,'all_options.bmm');
	fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
	fprintf(id,'\n%% bmm\n');
	for i=1:length(lines)   
		text=lines{i};
		% 		if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
		fprintf(id,text);
		fprintf(id,';\n');
		% 		end
	end
	lines=struct2stringarray(handles.all_options.nap,'all_options.nap');
	fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
	fprintf(id,'\n%% nap\n');
	for i=1:length(lines)
		text=lines{i};
		% 		if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
		fprintf(id,text);
		fprintf(id,';\n');
		% 		end
	end
	lines=struct2stringarray(handles.all_options.strobes,'all_options.strobes');
	fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
	fprintf(id,'\n%% strobes\n');
	for i=1:length(lines)    
		text=lines{i};
		% 		if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
		fprintf(id,text);
		fprintf(id,';\n');
		% 		end
	end
	lines=struct2stringarray(handles.all_options.sai,'all_options.sai');
	fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
	fprintf(id,'\n%% sai\n');
	for i=1:length(lines)    
		text=lines{i};
		% 		if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
		fprintf(id,text);
		fprintf(id,';\n');
		% 		end
	end
	lines=struct2stringarray(handles.all_options.usermodule,'all_options.usermodule');
	fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
	fprintf(id,'\n%% user defined module\n');
	for i=1:length(lines)    
		text=lines{i};
		% 		if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
		fprintf(id,text);
		fprintf(id,';\n');
		% 		end
	end
	lines=struct2stringarray(handles.all_options.movie,'all_options.movie');
	fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
	fprintf(id,'\n%% movies\n');
	for i=1:length(lines)
		text=lines{i};
		% 		if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
		fprintf(id,text);
		fprintf(id,';\n');
		% 		end
	end
	
	
else  % save only the parameters, that are relevant for the current project
	
	% 	if handles.info.signal_loaded==1
	lines=struct2stringarray(handles.all_options.signal,'all_options.signal');
	fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
	fprintf(id,'\n%% Signaloptions\n');
	for i=1:length(lines)
		text=lines{i};
		% 			if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
		fprintf(id,text);
		fprintf(id,';\n');
		% 			end
	end
	% 	end
	
	if handles.info.pcp_loaded==1
		lines=struct2stringarray(handles.all_options.pcp,'all_options.pcp');
		fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
		fprintf(id,'\n%% outer/middle ear filter function\n');
		module_name=['.pcp.' handles.info.current_pcp_module '.'];
		for i=1:length(lines)
			if ~isempty(strfind(lines{i},module_name))
				text=lines{i};
				% 				if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
				fprintf(id,text);
				fprintf(id,';\n');
				% 				end
			end
		end
	end
	
	if handles.info.bmm_loaded==1
		lines=struct2stringarray(handles.all_options.bmm,'all_options.bmm');
		fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
		fprintf(id,'\n%% bmm\n');
		module_name=['.bmm.' handles.info.current_bmm_module '.'];
		for i=1:length(lines)
			if ~isempty(strfind(lines{i},module_name))
				text=lines{i};
				% 				if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
				fprintf(id,text);
				fprintf(id,';\n');
				% 				end
			end
		end
	end
	
	if handles.info.nap_loaded==1
		lines=struct2stringarray(handles.all_options.nap,'all_options.nap');
		fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
		fprintf(id,'\n%% nap\n');
		module_name=['.nap.' handles.info.current_nap_module '.'];
		for i=1:length(lines)
			if ~isempty(strfind(lines{i},module_name))
				text=lines{i};
				% 				if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
				fprintf(id,text);
				fprintf(id,';\n');
				% 				end
			end
		end
	end
	
	if handles.info.strobes_loaded==1
		lines=struct2stringarray(handles.all_options.strobes,'all_options.strobes');
		fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
		fprintf(id,'\n%% strobes\n');
		module_name=['.strobes.' handles.info.current_strobes_module '.'];
		for i=1:length(lines)
			if ~isempty(strfind(lines{i},module_name))
				text=lines{i};
				% 				if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
				fprintf(id,text);
				fprintf(id,';\n');
				% 				end
			end
		end
	end
	
	if handles.info.sai_loaded==1
		lines=struct2stringarray(handles.all_options.sai,'all_options.sai');
		fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
		fprintf(id,'\n%% sai\n');
		module_name=['.sai.' handles.info.current_sai_module '.'];
		for i=1:length(lines)
			if ~isempty(strfind(lines{i},module_name))
				text=lines{i};
				% 				if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
				fprintf(id,text);
				fprintf(id,';\n');
				% 				end
			end
		end
	end
	
	
	if handles.info.usermodule_loaded==1
		lines=struct2stringarray(handles.all_options.usermodule,'all_options.usermodule');
		fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
		fprintf(id,'\n%% user defined module\n');
		module_name=['.usermodule.' handles.info.current_usermodule_module '.'];
		for i=1:length(lines)
			if ~isempty(strfind(lines{i},module_name))
				text=lines{i};
				% 				if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
				fprintf(id,text);
				fprintf(id,';\n');
				% 				end
			end
		end
	end
	
	if handles.info.movie_loaded==1
		lines=struct2stringarray(handles.all_options.movie,'all_options.movie');
		fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
		fprintf(id,'\n%% movies\n');
		module_name=['.movie.' handles.info.current_movie_module '.'];
		for i=1:length(lines)
			if ~isempty(strfind(lines{i},module_name))
				text=lines{i};
				% 				if isempty(strfind(text,'generatingfunction')) && isempty(strfind(text,'displayname')) && isempty(strfind(text,'displayfunction'))
				fprintf(id,text);
				fprintf(id,';\n');
				% 				end
			end
		end
	end	
	
	
end

% and the graphic options. Important for the movies
lines=struct2stringarray(handles.all_options.graphics,'all_options.graphics');
fprintf(id,'\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(id,'\n%% graphics\n');
for i=1:length(lines)
	text=lines{i};
	fprintf(id,text);
	fprintf(id,';\n');
end

err=fclose(id);
if err~=0
	ferror(id)
end
%  pause(1)

