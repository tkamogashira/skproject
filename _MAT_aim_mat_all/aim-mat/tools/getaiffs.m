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

function aiffs=getaiffs(varargin)
%usage: aiffs=getaiff(varargin)
%
% otherwise parameter must come in pairs: 'param','value' 
% allowed parameters are:
% modelfile - the spf file that specifies the version of AMS/AIM (required)
% soundcommand - a wave or raw file with the sound in (required)
% framespersecond (default: 12)
% output_normalization - the norm_mode parameter in out_file very useful for automatic scaling
% sound_sample_rate - the sample rate of the sound file
% sound_endian - endian of the sound file (l or b)(PC's are little endian Suns are big endian)
% writeaiffile - optional: a file to which the output aif file will be written
% echo - on (default) or off - if output is written on the screen
%
% returns an array of the class "frame" for each frame read

defined_input_gain=70;
temp_sound_file_name='temp_sound.wav';
temp_aiff_file_name='temp_aiff.aif';

if nargin<2 % only one parameter -> read file
    if size(varargin)==1
        makefilename=varargin{1};
    else
        makefilename='lastrun.genmovie';
    end
    %     fprintf('movie is produced from file %s from aifffile "makemovie_temp.aif"\n!',makefilename);
%     fprintf('aiff-file is produced according to file ''%s''\n',makefilename);
else
    makefilename='lastrun.genmovie';
    generateparameterfile(makefilename,varargin);
end

arguments=readparameterfile(makefilename);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make a string from each parameter
str_model=getargument(arguments,'modelfile');
str_soundcommand=getargument(arguments,'soundfile');
str_framespersecond=getargument(arguments,'framespersecond');
str_output_normalization=getargument(arguments,'output_normalization');
str_sound_sample_rate=getargument(arguments,'sound_sample_rate');
str_sound_endian=getargument(arguments,'sound_endian');
str_writeaiffile=getargument (arguments,'writeaiffile');
str_echo=getargument(arguments,'echo');
str_setvalue=getargument(arguments,'setvalue');
str_setvalueto=getargument(arguments,'setvalueto');
str_movie_duration=getargument(arguments,'movie_duration');
str_movie_start_time=getargument(arguments,'movie_start_time');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% default values for all parameters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sound-file. can be a command or a file
if isempty(str_soundcommand)     % 
    error('soundcommand must be given');
else
    soundcommand=str_soundcommand;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spf-file.
if isempty(str_model)     % 
    error('modelfile must be given');
else
    % check for extension
    [dumy_path,dummy_name,ext,versn] = fileparts(str_model);
    if strcmp(ext,'')
        model=sprintf('%s.spf',str_model);
    else
        model=str_model;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output normalization cares for the correct scaling in the aiff-files
% to prevent negativ numbers
if ~isempty(str_output_normalization)     % how much the spf file should be normalized by setting the norm_mode parameter in out_file
    eval(sprintf('scale_factor_output=%s;',str_output_normalization));    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frames per second
if isempty(str_framespersecond)     % default frames per second
    framespersecond=12;
else
    eval(sprintf('framespersecond=%s;',str_framespersecond));
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
% read the sound command and transfere the data to the buffer
if ~isempty(str_movie_duration)     % default frames per second
    eval(sprintf('movie_start_time=%s;',str_movie_start_time));
    eval(sprintf('movie_duration=%s;',str_movie_duration));
%     [sounddata,samplerate,bits,endian]=producesounddata(soundcommand,temp_sound_file_name,str_sound_sample_rate,str_sound_endian,movie_start_time,movie_duration);
    [sounddata,samplerate,bits,endian]=producesounddata(soundcommand,temp_sound_file_name,str_sound_sample_rate,str_sound_endian);
else
    movie_start_time=0;
    [sounddata,samplerate,bits,endian]=producesounddata(soundcommand,temp_sound_file_name,str_sound_sample_rate,str_sound_endian);
    movie_duration=length(sounddata)/samplerate;
end

disp(sprintf('producing sound from command: %s',soundcommand));
videolength=size(sounddata,1)/samplerate;

% so long is one picture:
duration=1/framespersecond; 
if duration > movie_duration
    duration = movie_duration;
end

% so many frames is the video size in the end:
nr_frames=round(videolength*framespersecond);
starttime=0;

% open Modelfile for read in some parameters like cfs etc
id=fopen(model,'rt');
if id<=0
    error(sprintf('Model-file %s not found',model));
end
fclose(id);
% open the soundfile to find out about sr and length
id=fopen(soundcommand,'rt');
if id<=0
    error(sprintf('Sound-file %s not found',soundcommand));
end
fclose(id);

% put everything important in the options to be called with ams_ng
options=[]; 
somuchruns=sprintf('%2.0f',nr_frames);
options=[options ' NUM_RUNS.ams ' somuchruns];
options=[options ' SEGMENT_MODE.ams ' 'ON'];
options=[options ' FILELOCKING_MODE.ams ' 'ON'];
options=[options ' CHANNELS.DataFile_In ' '1'];

%% user defined changes to values in the spf-file (eg for setting random seed)
if ~isempty(str_setvalue)     % 
    options=[options ' ' str_setvalue ' ' str_setvalueto ' '];
end

% build the correct dsam-output my-input aif-file:
options=[options ' FILENAME.DataFile_Out ' temp_aiff_file_name];

% make the correct soundcommand

if strfind(str_soundcommand,'wav')
    options=[options ' FILENAME.DataFile_In ' str_soundcommand];% always the same name: makemovie_temp.wav
else
    options=[options ' FILENAME.DataFile_In ' temp_sound_file_name];% always the same name: makemovie_temp.wav
end

% bring it to a format, that dsam understands:
wordsize=bits/8;
words=sprintf('%d',wordsize);
options=[options ' WORDSIZE.DataFile_In ' words];
srat=sprintf('%f',samplerate);
options=[options ' SAMPLERATE.DataFile_In ' srat];
dur=sprintf('%f',duration);
options=[options ' DURATION.DataFile_In ' dur];
star=sprintf('%f',starttime);
options=[options ' STARTTIME.DataFile_In ' star];
gain=sprintf('%f',defined_input_gain);
options=[options ' GAIN.DataFile_In ' gain];


% scaling must be performed in the input file to prevent too high numbers in the output
% !!!
% % the user has to set the correct scale value in the original spf-file
% this is best done by watching a whole film in ams and searching for the biggest
% value. Set this value as parameter 'NORM_MODE.DataFile_Out' 
% it is NOT A GOOD IDEA to set this value to -1 (auto) because, this value is calculated
% from the first frame and this ist not the highest. As result, strange negative values occur!
if ~isempty(str_output_normalization)     % how much the spf file should be normalized by setting the norm_mode parameter in out_file
    options=[options ' NORM_MODE.DataFile_Out ' str_output_normalization];
end

% find out abput the times used in ms to display numbers
content_spfmodel=loadtextfile(model);
t_minusstr=DSAMFindParameter(content_spfmodel,'NWIDTH.Ana_SAI');
t_minus=sscanf(t_minusstr,'%f')*1000;
t_plusstr=DSAMFindParameter(content_spfmodel,'PWIDTH.Ana_SAI');
t_plus=sscanf(t_plusstr,'%f')*1000;

% do I need later:
str_scale_factor_output=DSAMFindParameter(content_spfmodel,'NORM_MODE.DataFile_Out');
scale_factor_output=sscanf(str_scale_factor_output,'%f');

% find out about the frequency axis and make it nice
cf=DSAMGetCFs(content_spfmodel);
nr_freq=length(cf);


% delete the remains from last run
if fexist(temp_aiff_file_name)
    try
        delete(temp_aiff_file_name);
    catch
        error(sprintf('ReadAiff: Error: Could not delete existing file %s',temp_aiff_file_name));
    end
end

% the command line, that starts the process:
% ams must be in Path or this line must point to its directory:
%cd('C:\Program Files\DSAM\AMS');
% mas_ng starts a single ams process without grafik (very fast)
% -d turns off the debug messages
% -s calls the file makemovie_temp.spf
% -r gives the number of runs (somuchruns)
% segment on tells dsam to run in segmented mode
if ispc
%     str=sprintf('! ams_ng.exe -doff -smakemovie_temp.spf -r%s  segment on',somuchruns);    
    str=sprintf('! ams_ng.exe -doff -s%s -r%s  segment on %s',model,somuchruns,options);    
else
%    str=sprintf('!/cbu/cnbh/dsam/bin/ams_ng -doff -smakemovie_temp.spf -r%s  segment on',somuchruns);    
    str=sprintf('! /cbu/cnbh/dsam/bin/ams_ng -doff -s%s -r%s  segment on %s',model,somuchruns,options);    
end

% this one works with a window.
%      str=sprintf('! AMS.exe -S -s makemovie_temp.spf -r %s &',somuchruns);

% delete the remains of some buggy run:
if fexist('.ams_LCK')
    try
        delete('.ams_LCK');
    catch
        error('Could not delete existing file .ams_LCK. Please restart matlab');
    end
end

if echo disp('Ams simulation started...');end
eval([str]);    % do ams!

t0 = clock;
while etime(clock,t0)<0.1 %wait a little while
end

% and look for the lock file
while fexist('.ams_LCK')
end % continue, when its _not_ there



FID = fopen(temp_aiff_file_name,'r');
if FID==-1
    error('error in simulation: aif-file was not generated!');
end
fclose(FID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all finished :) now read in the aiff-file
allframes=SBReadAiff(temp_aiff_file_name,echo);    % returns all info in a struct

if ~isempty(str_writeaiffile)
    % for jen: make a copy of the aiff file to something else
    copyfile(temp_aiff_file_name, str_writeaiffile);
end

% find out about the structure
sample_frame=allframes(1);
nr_channels=getnrchannels(sample_frame);
nr_points=getnrpoints(sample_frame);
nr_frames=size(allframes,2);

% put the information about the center frequencies in the frames
if ~is_current_var('cf',who)  % if read from aif-file, no such info exist
    for i=1:nr_channels
        cf(i)=i*1000;
    end
    t_plus=getmaximumtime(sample_frame)*1000;
    t_minus=getminimumtime(sample_frame)*1000;
end
% set the frequency information in each frame
for i=1:nr_frames 
    allframes(i)=setcf(allframes(i),cf); 
end
% and make a nice name for it:
for i=1:nr_frames 
    allframes(i)=setname(allframes(i),sprintf('Frame #%d of %d from sound %s',i,nr_frames,str_soundcommand)); 
    start_times=(i-1)*duration+movie_start_time;
    allframes(i)=setcurrentframestarttime(allframes(i),start_times);
end

% values for scaling the actual sum of all channels
scale_summe=0;% this value is used to scale the picture of the sum later
for i=1:nr_frames
    vals=getvalues(allframes(i));
	maxsc=getamplitudemaxvalue(sample_frame);
	if maxsc~=0
	    vals=vals/getamplitudemaxvalue(sample_frame);
	end
    su=sum(vals); 
    ma=max(su);
    if ma > scale_summe scale_summe=ma; end
end


low=getamplitudeminvalue(sample_frame);


if low < 0
    disp('Achtung: Negative values in the AIFF-File! ');
    disp('This probably means, that the value in ');
    disp('NORM_MODE in DataFile_Out was not high enough!');
    disp(sprintf('current value: %5.1f',scale_factor_output));
    fprintf('\n[a] double it to %5.1f, or \n(b) continue anyway  \nor type in the new value\n',scale_factor_output*2);
    
    reply = input(': ','s');
    
    if isempty(reply) % default
        reply ='a';
    end
    
    valgiven=0;
    if reply~='a' & reply~='b'
        eval(sprintf('val=%s;',reply));
    else
        if reply=='a'
            val=2 * scale_factor_output;  % double it!
        end
        if reply=='b'
            val=scale_factor_output;  % no change
        end
    end
    if isnan(val) | val<=0
        error('sorry, no valid input');
    end
    
    if val~=scale_factor_output % only, if there is a change!
        scale_factor_output=val;  
        % try it again!
        aiffs=getaiffs(...
            'modelfile',str_model,...
            'soundcommand',str_soundcommand,...
            'framespersecond',str_framespersecond,...
            'output_normalization',scale_factor_output,... %thats the new one
            'sound_sample_rate',str_sound_sample_rate,...
            'writeaiffile',str_writeaiffile,...
            'echo',str_echo,...
            'sound_endian',str_sound_endian,...
            'setvalue',str_setvalue,...
            'setvalueto',str_setvalueto...
        );
        return;
        
    end
end

aiffs=allframes;

