% procedure for 'aim-mat'
% 
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



function aim_savecurrentstate(handles)
% save some crucial information to a file

nam=handles.info.projectfilename;

% in which directory is the wavefile? users could have changed it!
dirname=handles.info.original_soundfile_directory;

rnam=fullfile(dirname,nam);
id=fopen(rnam,'wt');

fprintf(id,'\n%% Project information');
fprintf(id,'\n%% for the project: \n\n%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(id,'\n%%');
filename=sprintf('   %s\n',handles.info.uniqueworkingname);
fprintf(id,filename);
fprintf(id,'%%   %s',date);
fprintf(id,'\n%%   produced by ');
result = license('inuse');
cuser=result(1).user;
fprintf(id,'%s',cuser);
fprintf(id,'\n%% Dont write anything in this file');
fprintf(id,'\n%%%%%%%%%%%%%%%%%%%%%%%%%%\n');

% infos about the setup of the project itself
% fprintf(id,'current_pcp_module=''%s'';\n',handles.info.calculated_pcp_module);
% fprintf(id,'current_bmm_module=''%s'';\n',handles.info.calculated_nap_module);
% fprintf(id,'current_nap_module=''%s'';\n',handles.info.calculated_bmm_module);
% fprintf(id,'current_strobes_module=''%s'';\n',handles.info.calculated_strobes_module);
% fprintf(id,'current_sai_module=''%s'';\n',handles.info.calculated_sai_module);
% fprintf(id,'current_usermodule=''%s'';\n',handles.info.calculated_usermodule_module);
% fprintf(id,'current_movie_module=''%s'';\n',handles.info.calculated_movie_module);


% and infos about the grapical display
fprintf(id,'current_plot=%d;\n',handles.info.current_plot);

start_time=slidereditcontrol_get_value(handles.currentslidereditcombi);
if handles.info.current_plot<6
	fprintf(id,'start_time=%f;\n',start_time);
else
	fprintf(id,'start_time=%d;\n',round(start_time));
end

duration=slidereditcontrol_get_value(handles.slideredit_duration);
fprintf(id,'duration=%f;\n',duration);
scale=slidereditcontrol_get_value(handles.slideredit_scale);
fprintf(id,'scale=%f;\n',scale);


hastime=get(handles.checkbox6,'Value');
hasfreq=get(handles.checkbox7,'Value');
hassignal=get(handles.checkbox10,'Value');
fprintf(id,'hastime=%d;\n',hastime);
fprintf(id,'hasfreq=%d;\n',hasfreq);
fprintf(id,'hassignal=%d;\n',hassignal);

pos=get(handles.figure1,'Position');
if isfield(handles.info,'current_figure')
	fprintf(id,'winx=%d;\n',pos(1));
	fprintf(id,'winy=%d;\n',pos(2));
	if ishandle(handles.info.current_figure)
		gpos=get(handles.info.current_figure,'Position');
		fprintf(id,'grafixwinnr=%d;\n',handles.info.current_figure);
		fprintf(id,'grafixwinx=%d;\n',gpos(1));
		fprintf(id,'grafixwiny=%d;\n',gpos(2));
		fprintf(id,'grafixwinb=%d;\n',gpos(3));
		fprintf(id,'grafixwinh=%d;\n',gpos(4));
	end
end
fclose(id);