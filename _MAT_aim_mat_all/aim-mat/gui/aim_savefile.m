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



function aim_savefile(handles,fr,name,type,modul,options,all_options)

str.type=modul;
str.data=fr;
str.options=options;
str.all_options=all_options;

eval(sprintf('%s=str;',type));

lookpath=fullfile(handles.info.original_soundfile_directory,name);

str5=sprintf('save(''%s'',''%s'');',lookpath,type);
eval(str5);

