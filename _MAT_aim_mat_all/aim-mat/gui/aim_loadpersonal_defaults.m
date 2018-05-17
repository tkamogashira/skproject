% procedure for 'aim-mat'
%function handles=aim_loadpersonal_defaults(handles) 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function handles=aim_loadpersonal_defaults(handles)
% loads the file 'personal_defaults' from the current directory
% each personal default setting for a parameter must come in the complete
% parameter format 
% e.g.
% 

if exist('personal_defaults.m','file')
	
	all_options=handles.all_options;

	try
		personal_defaults; % evaluates the file and overwrites the
	catch 
		disp('aim_loadpersonal_defaults: errors in reading in the personal_defaults.m');
		return
	end
	% if OK, then overwrite the parameters:
	handles.all_options=all_options;
	
	
	if exist('default_module_pcp','var')==1
		handles=setselection(handles,'pcp',default_module_pcp);
		handles.info.default_start_module_pcp=default_module_pcp;
	end
	if exist('default_module_bmm','var')==1
		handles=setselection(handles,'bmm',default_module_bmm);
		handles.info.default_start_module_bmm=default_module_bmm;
	end
	if exist('default_module_nap','var')==1
		handles=setselection(handles,'nap',default_module_nap);
		handles.info.default_start_module_nap=default_module_nap;
	end
	if exist('default_module_strobes','var')==1
		handles=setselection(handles,'strobes',default_module_strobes);
		handles.info.default_start_module_strobes=default_module_strobes;
	end
	if exist('default_module_sai','var')==1
		handles=setselection(handles,'sai',default_module_sai);
		handles.info.default_start_module_sai=default_module_sai;
	end
	if exist('default_module_usermodule','var')==1
		handles=setselection(handles,'usermodule',default_module_usermodule);
		handles.info.default_start_module_usermodule=default_module_usermodule;
	end
	if exist('default_module_movie','var')==1
		handles=setselection(handles,'pcp',default_module_pcp);
		handles.info.default_start_module_pcp=default_module_pcp;
	end
	if exist('default_module_pcp','var')==1
		handles=setselection(handles,'movie',default_module_movie);
		handles.info.default_start_module_movie=default_module_movie;
	end
end

function handles=setselection(handles,selstr,curmod)
switch selstr
	case('pcp')
		hand=handles.listbox0;
		handles.info.current_pcp_module=curmod;
	case('bmm')
		hand=handles.listbox1;
		handles.info.current_bmm_module=curmod;
	case('nap')
		hand=handles.listbox2;
		handles.info.current_nap_module=curmod;
	case('strobes')
		hand=handles.listbox3;
		handles.info.current_strobes_module=curmod;
	case('sai')
		hand=handles.listbox4;
		handles.info.current_sai_module=curmod;
	case('usermodule')
		hand=handles.listbox6;
		handles.info.current_usermodule_module=curmod;
	case('movie')
		hand=handles.listbox5;
		handles.info.current_movie_module=curmod;
end

names=get(hand,'String');
for i=1:length(names)
	if strcmp(names{i},curmod)
		set(hand,'Value',i);
		return
	end
end
return





