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



function handles=loadallparameterfiles(handles)
% go through all directories and call the single module-parameterfiles

% first find the directory, where all modules are saved. This directory
% should usually be next to the \aim\matlab - directory: \aim\
% find a module, that is always there:
fpa=which('gen_gtfb');
[a,b,c]=fileparts(fpa);
where=strfind(a,'modules');
if isempty(where)
	str=sprintf('loadallparameterfiles: Cant locate the module path (file gen_gtfb not found)');
    disp(str);
    % TODO: a better solution for this.
	er=errordlg(str,'File Error');
	set(er,'WindowStyle','modal');
	handles.error=1;
	return
end
columnpath=fpa(1:where+7);
handles.info.columnpath=columnpath; % save it for later

% save these for later, all other are overwritten
addsig=0;
if isfield(handles,'all_options')
	if isfield(handles.all_options,'signal')
		addsig=1;
		signaloptions=handles.all_options.signal;
	end
end
% now go recurse through all directories in columnpath
allcols=dir(columnpath);
nr_files=size(allcols);
completepath=path;
olddir=pwd;
for i=3:nr_files
	current_column_name=allcols(i).name;
	if ~strcmpi(current_column_name(1),'.')  % we dont want hidden files
		current_column_path=[columnpath current_column_name];
		allmodules=dir(current_column_path);
		nr_modules=size(allmodules);
		if ~strcmp(current_column_name,'signal')
			% 		cd(current_module_path)
			for j=3:nr_modules
				current_module_name=lower(allmodules(j).name);
            	if ~strcmpi(current_module_name(1),'.') 
					current_module_path=fullfile(current_column_path,current_module_name);
                    
                    % if the path is not in the matlab search path, add it
                    % to it and print a notice!
                    if isempty(strfind(completepath,current_module_path)) % the module is not in the path
                        addpath(current_module_path);
                        disp(sprintf('Directory %s was added to the path!',current_module_path));
                    end
                    
					cd(current_module_path)
					try
						eval('parameters'); % call the standart parameters. Then we have a struct
						str=sprintf('all_options.%s.%s=%s;',current_column_name,current_module_name,current_module_name);
						eval(str);
						cstr=sprintf('allo=all_options.%s.%s;',current_column_name,current_module_name);
						eval(cstr);
						if isfield(allo,'displayfunction')==1 
							dstr=sprintf('all_options.%s.%s.displayfunction=''%s'';',current_column_name,current_module_name,allo.displayfunction);
							eval(dstr);
						else if strcmp(current_column_name,'usermodule') && ~strcmp(current_column_name,'graphics')
								dstr=sprintf('all_options.%s.%s.displayfunction='''';',current_column_name,current_module_name);
								eval(dstr);
							end
						end
							
						eval(sprintf('clear %s',current_module_name));
					catch
                    % either pop up a window
% 						str=sprintf('The parameter file for the module: %s produced errors!',current_module_path);
% 						er=errordlg(str,'File Error');
% 						set(er,'WindowStyle','modal');
                    % or just plot a warning message on the screen
    					str=sprintf('The parameter file for the module: %s produced errors!',current_module_path);
                        disp(str);

% stop program
% 						handles.error=1;
% 						cd(olddir);
% 						return
%
% or continue:
					end
				end
			end
		end
	end
end
cd(olddir);
handles.all_options=all_options;
if addsig==1
	handles.all_options.signal=signaloptions;
end


% save the new path
allpath=path;
path(allpath);
