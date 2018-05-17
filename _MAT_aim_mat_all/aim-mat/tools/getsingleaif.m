% tool
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


function fr=getsingleaif(varargin)
% usage: fr=getsingleaif(varargin)
% produces only one frame from the (static) sound "soundfile"
% This frame is taken as with the makeaimmovie with the framesperseconds-parameter
% set to longer than the stimulus. Therefore the frame at the end of the signal duration is taken

temp_sound_file_name='temp.wav';

if nargin<2 % only one parameter -> read file
    if size(varargin)==1
        makefilename=varargin{1};
    else
        makefilename='lastrun.genmovie';
    end
    %     fprintf('movie is produced from file %s from aifffile "makemovie_temp.aif"\n!',makefilename);
    fprintf('aiff-file is produced according to file ''%s''\n',makefilename);
else
    makefilename='lastrun.genmovie';
    generateparameterfile(makefilename,varargin);
end

arguments=readparameterfile(makefilename);

str_model=getargument(arguments,'modelfile');
str_soundcommand=getargument(arguments,'soundfile');
str_movie_duration=getargument(arguments,'movie_duration');
str_movie_start_time=getargument(arguments,'movie_start_time');
str_output_normalization=getargument(arguments,'output_normalization');
str_sound_sample_rate=getargument(arguments,'sound_sample_rate');
str_sound_endian=getargument(arguments,'sound_endian');
str_echo=getargument(arguments,'echo');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the sound command and transfere the data to the buffer
if ~isempty(str_movie_duration)     % default frames per second
    eval(sprintf('movie_duration=%s;',str_movie_duration));
    eval(sprintf('movie_start_time=%s;',str_movie_start_time));
    [sounddata,samplerate,bits,endian]=producesounddata(str_soundcommand,temp_sound_file_name,str_sound_sample_rate,str_sound_endian,movie_start_time,movie_duration);
else
    movie_start_time=0;
    [sounddata,samplerate,bits,endian]=producesounddata(str_soundcommand,temp_sound_file_name,str_sound_sample_rate,str_sound_endian);
    movie_duration=length(sounddata)/samplerate;
end

videolength=size(sounddata,1)/samplerate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frames per second
framespersecond=1/videolength;  % 
framespersecond=framespersecond*1.001;

aiffs=getaiffs('modelfile',str_model,...
    'soundfile',str_soundcommand,...
    'framespersecond',sprintf('%f',framespersecond),...
    'output_normalization',str_output_normalization,...
    'movie_duration',movie_duration,...
    'movie_start_time',movie_start_time,...
    'echo',str_echo);
% aiffs=getaiffs('modelfile',str_model,...
%     'soundfile',temp_sound_file_name,...
%     'framespersecond',sprintf('%f',framespersecond),...
%     'output_normalization',str_output_normalization,...
%     'movie_duration',movie_duration,...
%     'movie_start_time',movie_start_time,...
%     'echo',str_echo);

fr=aiffs(1);    % this is the one and only




