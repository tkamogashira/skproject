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


function makeaimmovie(varargin)
%usage: function makemovie(arguments)
%
% produces a quicktime-video from an AMS/AIM spf file and a sound file
% inputs: 
% if no or only one parameter is given, than a make file is read instead
% that should contain all parameters and their values
% this file is generated automatically as "lastrun.genmovie"
% 
% otherwise parameter must come in pairs: 'param','value' 
%
% parameters for generating the SAI: 
% modelfile - the spf file that specifies the version of AMS/AIM (required)
% output_normalization - the norm_mode parameter in out_file very useful for automatic scaling
% soundfile - a wave or raw file with the sound in (required)
% sound_sample_rate - the sample rate of the sound file
% sound_endian - endian of the sound file (l or b)(PC's are little endian Suns are big endian)
% framespersecond (default: 12)
% moviefile  - the name of the output file (default: "name of model plus name of sound")
% echo - if off, than no output is created on screen
% aifffile - optional instead of model. When aifffile is given, the aif file is read in directly from it
%
% Parameter for generating the graphic
% AuditoryImageFormat: "AI", "AIpitch", "AIsum", "AIsum2",  "sumai", or "AIsurface" (default: AIsum) or any user-defined-function
%           the user-defined-function is called with the current frame and must produce a picture
%           currently supported: show_pitch_spiral
%                                AIFrePtiPStress  (Auditory Image with Frequency profile and time interval profile with the colors in the image where the information was derived from
%
% TimeIntervalUnits  "log" or "linear" (default: log)
% colormap (default: black)
% input_scale - scaling factor, that is directly applied to the input values - to prevent too loud sounds (default 1 can be set to auto)
% minimum_time_interval  - the minimal time that should be displayed in logarithmic form (in ms)
% maximum_time_interval  - the maximal time that should be displayed in logarithmic form
% linewidth - Width of all plotted lines (default 1)
% showtime - plot the time and the number of each frame (default on)
% text - show a text in each frame in the upper right corner. The text must be given in a struct with .time and .label
% plot_scale - scales the whole frame up or down
% profile_scale - increases the amplitude of the profiles

% the length of the final movie is the length of the soundfile plus the length of one picture in the beginning

% valid calls:
% the shortest valid call:
% makemovie('modelfile''aim.spf','soundfile','cegc_br.raw')
% produces the video "aim.mov" from the soundfile "cegc_br.wav" and the model file aim.spf
% example
%makemovie(      'modelfile','AIMghs.spf',...
%                             'soundfile','f128h8j0-2.wav',...
%                             'framespersecond','12',...
%                             'moviefile', 'impressing_movie',... %(".mov" is added)
%                             'TimeIntervalUnits','log',...           %  (or linear)
%                             'input_scale','default',...        %     ( or any number >0)
%                             'output_normalization','1000',...  %  (this number overwrites the NORM_MODE.DataFile_Out)
%                             'AuditoryImageFormat','sum',...  %    ( or AI,AIsurface,AIsum)
%                             'sound_sample_rate','20000',...    % ( if the soundfile is not a wavfile - this must be togehter with the next one)
%                             'minimum_time_interval','2',...    % ( in ms the smalles time, that is displayed)
%                             'sound_endian','l')   %  ( if the soundfile is not a wavfile - this must be togehter with the previous one)


% you can choose between several types without changing the spf-file! If you want all channels with the waterfal than 
% the according reduce_channels are commented out automatically

% the full movie will consist of so many pictures as the length of the soundfile divided by the frames per seconds. 
% To avoid clicks (due to quicktime) at the onset of the sound one frame and 
% an pause of one frame is inserted at the beginning of the movie.
% To avoid a black picture at the end, one more frame is inserted at the end of the movie, so that the final movie
% is slighly longer than the sound and the last picture is shown twice

% the principle of the generation is to load the spf file and crucial variables are overwwitten:
% the file_in is overwritten by the calling "soundfile" and the sound-out is overwritten by some temp-aiff file
% the modified spf-file is stored under makemovie_temp.spf and this file is called via ams

temp_sound_file_name='temp_sound.wav'; % must be the same as in getaiffs!!!

if nargin<2 % only one parameter -> read file
    if size(varargin)==1
        makefilename=varargin{1};
    else
        makefilename='lastrun.genmovie';
    end
    %     fprintf('movie is produced from file %s from aifffile "makemovie_temp.aif"\n!',makefilename);
%     fprintf('movie is produced from file ''%s''\n',makefilename);
else
    makefilename='lastrun.genmovie';
    generateparameterfile(makefilename,varargin);
end
arguments=readparameterfile(makefilename);


str_moviefile=getargument(arguments,'moviefile');
str_aifffile=getargument(arguments,'aifffile');
str_movie_duration=getargument(arguments,'movie_duration');
str_movie_start_time=getargument(arguments,'movie_start_time');
str_AuditoryImageFormat=getargument(arguments,'AuditoryImageFormat');
str_TimeIntervalUnits=getargument(arguments,'TimeIntervalUnits');
str_colormap=getargument(arguments,'colormap');
str_minimum_time_interval=getargument(arguments,'minimum_time_interval');
str_maximum_time_interval=getargument(arguments,'maximum_time_interval');
str_sound_sample_rate=getargument(arguments,'sound_sample_rate');
str_sound_endian=getargument(arguments,'sound_endian');
str_linewidth=getargument(arguments,'linewidth');
str_echo=getargument(arguments,'echo');
str_showtime=getargument(arguments,'showtime');
str_showtextname=getargument(arguments,'showtextname');
str_showtexttime=getargument(arguments,'showtexttime');
str_plotscale=getargument(arguments,'plotscale');
str_profile_scale=getargument(arguments,'profile_scale');

% data originally used in readaiff, but needed here also:
str_framespersecond=getargument(arguments,'framespersecond');
str_model=getargument(arguments,'modelfile');
str_soundcommand=getargument(arguments,'soundfile');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set some default values, if the values are not explecitly given:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scale the amplitude of the whole picture up
if isempty(str_plotscale)     % default frames per second
    plot_scale=1;
else
    eval(sprintf('plot_scale=%s;',str_plotscale));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scale the amplitude of the profiles (only when profiles are plotted of course)
if isempty(str_profile_scale)     % default frames per second
    profile_scale=1;
else
    eval(sprintf('profile_scale=%s;',str_profile_scale));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% show time and number of frame
if isempty(str_showtime)     % default frames per second
    showtime=1;
else
    if strcmp(str_showtime,'off')
        showtime=0;
    else
        showtime=1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frames per second
if isempty(str_framespersecond)     % default frames per second
    framespersecond=12;
else
    eval(sprintf('framespersecond=%s;',str_framespersecond));
end


if isempty(str_linewidth)    % how much the spf file should be normalized by setting the norm_mode parameter in out_file
    line_width=1;
else
    eval(sprintf('line_width=%s;',str_linewidth));
end

if isempty(str_TimeIntervalUnits)     % output is linear or logarithmic
    TimeIntervalUnits='log';
else
    TimeIntervalUnits=str_TimeIntervalUnits;
end

if isempty(str_moviefile)     % default name of the movie
    [dumy_path,tempmodelname,ext,versn] = fileparts(str_model);
    [dumy_path,tempsoundname,ext,versn] = fileparts(str_soundcommand);
    moviefile=sprintf('soundfile_%s_model_%s.mov',tempsoundname,tempmodelname);
else
    [dumy_path,tempmodelname,ext,versn] = fileparts(str_moviefile);
    if strcmp(ext,'')
        moviefile=sprintf('%s.mov',str_moviefile);
    else
        moviefile=str_moviefile;
    end
end

if isempty(str_AuditoryImageFormat)     % which AuditoryImageFormat should be used
    AuditoryImageFormat='AIsum';
else 
    AuditoryImageFormat=str_AuditoryImageFormat;
end

if isempty(str_colormap)     % an aifffile that is read instead
    if strcmp(AuditoryImageFormat,'AI') | strcmp(AuditoryImageFormat,'AIsum') | strcmp(AuditoryImageFormat,'sum')| strcmp(AuditoryImageFormat,'singlegraphic')
        clrmap=zeros(64,3); % all black
    end
    if strcmp(AuditoryImageFormat,'AIsurface')
        clrmap=1-gray;      % invertes grayscale: 0 is white and 1 is black
    end
else % colormap was given
    eval(sprintf('clrmap=%s;',str_colormap));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sound-file. can be a command or a file
if isempty(str_soundcommand)     % 
    error('soundcommand must be given');
else
    soundcommand=str_soundcommand;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% echo on screen
if isempty(str_echo)     % default frames per second
    echo=1;
else
    if strcmp(str_echo,'off')
        echo=0;
    else
        echo=1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% construct the aiff-file with a call to the dsam-routine:

% if aifffile is given from a previous run, than simply load it:
if ~isempty(str_aifffile)
    allframes=SBReadAiff(str_aifffile,echo);    % returns all info in a struct
else
    allframes=getaiffs(makefilename);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the sound command and transfere the data to the buffer
if ~isempty(str_movie_duration)     % default frames per second
    eval(sprintf('movie_duration=%s;',str_movie_duration));
    eval(sprintf('movie_start_time=%s;',str_movie_start_time));
    [sounddata,samplerate,bits,endian]=producesounddata(soundcommand,temp_sound_file_name,str_sound_sample_rate,str_sound_endian,movie_start_time,movie_duration);
else
    movie_start_time=0;
    [sounddata,samplerate,bits,endian]=producesounddata(soundcommand,temp_sound_file_name,str_sound_sample_rate,str_sound_endian);
    movie_duration=length(sounddata)/samplerate;
end


% the duration of the whole video
videolength=size(sounddata,1)/samplerate;
%  so long is one picture:
duration=1/framespersecond;

% so many frames is the video size in the end:
nr_frames=videolength*framespersecond; 

% find out about the general structure of all frames by taking the first as a sample (they are all identical)
sample_frame=allframes(1);
nr_channels=getnrchannels(sample_frame);
nr_points=getnrpoints(sample_frame);
nr_frames=size(allframes,2);
t_plus=getmaximumtime(sample_frame);    % usually 5 ms
t_minus=getminimumtime(sample_frame);   % usually -35 ms

% set a variable for the current starting time of each frame for plotting
for i=1:nr_frames
     allframes(i)=setcurrentframestarttime(allframes(i),(i-1)*duration);
end

% start producing the movie!
MakeQTMovie('start',moviefile);
MakeQTMovie('size', [640 400]);
MakeQTMovie('quality', 0.8);    % reduces the size

if echo fprintf('start produce pictures:\n'); end

% We start the time at zero:
current_time=0;

for i=0:nr_frames
    if echo    
        % plot a start for each frame, so that we see, how long it takes
        fprintf('*');
        if(mod(i+1,30)==0)
            fprintf('\n');
        end
    end
    
    if i==0 % trick: the first picture is the same as the second to prevent quick time from producing a click sound, that it otherwise does
        c_frame=allframes(1);
        current_time=0;
    else
        c_frame=allframes(i);
    end

    % set some default values that depend on the frames
    if  strcmp(TimeIntervalUnits,'log')>0
        framestruct.is_log=1;
    else
        framestruct.is_log=0;
    end
    
    if showtime
        framestruct.show_time=1;
    else
        framestruct.show_time=0;
    end
    
    if ~isempty(str_showtextname)
        texts=str2cell(str_showtextname);
        times=str2cell(str_showtexttime);
        nr_times=size(times,1);
        if nr_times<=1  % every picture
             c_frame=settext(c_frame,texts(1));
        else
            for i=1:nr_times
                tt=str2num(times{i});
                if tt>current_time
                    c_frame=settext(c_frame,texts(i));
                    break;
                end
            end
        end
    end
    
    if isempty(str_minimum_time_interval)     % how much the spf file should be normalized by setting the norm_mode parameter in out_file
        if  framestruct.is_log
            minimum_time_interval=2;    % ms = default value for the minimum time
        else
            minimum_time_interval=-t_plus*1000;    % ms = default value for the minimum time
        end
    else
        eval(sprintf('minimum_time_interval=%s;',str_minimum_time_interval));
        if  framestruct.is_log
            if minimum_time_interval < 0
                disp('minimum time interval must be >0 for log plots');
                minimum_time_interval=2;
            end
        end
    end

    if isempty(str_maximum_time_interval)  % default value for maximum time  
        maximum_time_interval=-t_minus*1000; % in ms!  % to the end of the stimulus
    else
        eval(sprintf('maximum_time_interval=%s;',str_maximum_time_interval));
    end
    
    % construct the framestructure for calling the plotting-routine
    framestruct.current_frame = c_frame;
    framestruct.maximum_time_interval=maximum_time_interval;
    framestruct.minimum_time_interval=minimum_time_interval;
    framestruct.plot_scale=plot_scale;
    framestruct.profile_scale=profile_scale;
    
    
    % call the plotting routine
    eval(sprintf('%s(framestruct);',AuditoryImageFormat));
    
    % bring the figure to front
    figure(gcf); 
    
    % and add it to the movie
    MakeQTMovie('addframe');
    
    current_time=current_time+duration;
    
end % End of current_frame - loop

% add one, to fill the last picture (the sound is longer than n*nr_frames)
MakeQTMovie('addframe');
MakeQTMovie('framerate', framespersecond);

% soundgap=zeros(floor(samplerate/framespersecond),1);
% stemp=[soundgap' sounddata'];
% sounddata=stemp';
MakeQTMovie('addsound',sounddata,samplerate);

MakeQTMovie('finish');
MakeQTMovie('cleanup');

% fprintf('\n\nFinished successfully! :-)\n');
if echo
    disp(sprintf('\n\nWrote QuickTime movie %s\\%s',pwd,moviefile));
end

return


% clean up
ans=input('start with QuickTime? y/[n]','s')
if ans=='y'
    !C:\Program Files\QuickTime\QuickTimePlayer 
end


% not cleaning up: (for test purpose)
return
% clean up temporary files
try
    delete('makemovie_temp.spf');
end
try
    delete('makemovie_temp.aif');
end
if rememberdeletesoundfile
    try
        delete(soundfile);
    end
end
