% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function moviescript()
% makes movies for all sound files in this directory

modelfile='aim.spf';
framespersecond='12';
graphicstyle='log';
graphictype='sumonly';
sound_sample_rate='20000';
sound_endian='l';
minimum_time_interval='2.0';
% input_scale='default';    % that makes problems!!
input_scale='1.0';
output_normalization='1.0';

dircont=dir;
nr_files=size(dircont);

fileid=fopen('movie_log.txt','w');

for i=1:nr_files 
    fullname=dircont(i).name;
    [path,name,ext,versn] = fileparts(fullname);
    
    
    if strcmp(ext,'') & exist(fullname)~=7 % not directorys
        fprintf('\n\nMaking Movie from soundfile %s\n',fullname);
        
        outname=sprintf('%s.mov',fullname);
        dostring=sprintf('makemovie(''modelfile'',''%s'',''soundfile'',''%s'',''outfile'',''%s'',''framespersecond'',''%s'',''graphicstyle'',''%s'',''graphictype'',''%s'',''sound_sample_rate'',''%s'',''sound_endian'',''%s'',''minimum_time_interval'',''%s'',''input_scale'',''%s'',''output_normalization'',''%s'')',...
            modelfile,fullname,outname,framespersecond,graphicstyle,graphictype,sound_sample_rate,...
            sound_endian,minimum_time_interval,input_scale,output_normalization);
        
        fprintf('%s\n',dostring);
        fprintf(fileid,'%s\n',dostring);
        eval(dostring);
        
    end
end

fclose(fileid);
