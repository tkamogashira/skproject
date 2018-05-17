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

function saimakeaimmovie(varargin)

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
str_producemovie=getargument(arguments,'producemovie');

% data originally used in readaiff, but needed here also:
str_framespersecond=getargument(arguments,'framespersecond');
str_sai_picturespersecond=getargument(arguments,'sai_picturespersecond');
str_nap_picturespersecond=getargument(arguments,'nap_picturespersecond');
str_model=getargument(arguments,'modelfile');
str_soundcommand=getargument(arguments,'soundfile');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if a movie is produced at all, or just the sais
if isempty(str_producemovie)     % 
    producemovie='sai_and_nap';
else
    producemovie=str_producemovie;
end

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pictures per second
if isempty(str_sai_picturespersecond)     % default every ms
    sai_picturespersecond=1000;
else
    eval(sprintf('sai_picturespersecond=%s;',str_sai_picturespersecond));
end
if isempty(str_nap_picturespersecond)     % default every ms
    nap_picturespersecond=1000;
else
    eval(sprintf('nap_picturespersecond=%s;',str_nap_picturespersecond));
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sound-file. can be a command or a file
if isempty(str_soundcommand)     % 
    error('soundcommand must be given');
else
    soundcommand=str_soundcommand;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% construct the aiff-file with a call to the dsam-routine:

% if aifffile is given from a previous run, than simply load it:
if ~isempty(str_aifffile)
    allframes=SBReadAiff(str_aifffile);    % returns all info in a struct
else
    allframes=getaiffs(makefilename);
end
complete_nap=allframes(1);
nr_channels=getnrchannels(complete_nap);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% grafix=1;
select_channels=1:nr_channels;
select_single_channels=3;


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
sampletime=1/samplerate;
% the duration of the whole video
videolength=size(sounddata,1)/samplerate;
%  so long is one picture:

if ~strcmp(producemovie,'sai_only')
    sai_pictureduration=1/sai_picturespersecond;
else
    sai_pictureduration=1/framespersecond;
end
% so many frames is the video size in the end:
nr_sai_pictures=floor(videolength/sai_pictureduration);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start processing the data
% first: 2DAT on the nap:
clear napoptions;
napoptions.time_constant_factor=6;  %makes the time constant for the time adaption longer
% napoptions.frequency_constant_factor=0.8; % the influence of the neighboring channels
napoptions.frequency_constant_factor=0.0; % the influence of the neighboring channels

disp('calculating 2D adaptive threshold...');
sharpnap=twoDat(complete_nap,napoptions); % two dimensional adaptive thresholding

% strobeoptions
strobeoptions.strobe_decay_time=0.02; % in this time the strobe threshold decreases to 0
strobeoptions.parabel_heigth=1.2;    % times the nap height at that point
% strobeoptions.parabel_width=0.01;    % ms
strobeoptions.parabel_width_in_cycles=1.5;    % cycles
strobeoptions.influence_nap_heigth=0;  % influcence of the height of the nap at the point, where the strobe was elicited
strobeoptions.nr_cyclyes_to_wait=1.5; % wait a little longer then once cycle for the real strobe
strobeoptions.select_channels=select_channels;

disp('calculating strobes...');
[allstrobeprocesses,allthresholds]=findstrobes(sharpnap,strobeoptions);


% figure(1);clf
% plotwithstrobes(sharpnap,allstrobeprocesses);
% 
% return
if strcmp(producemovie,'sai_and_nap')
    step=1/nap_picturespersecond;
    graphic_times=movie_start_time:step:movie_start_time+movie_duration;
    maxheight=5;
    maxnap=max(sharpnap);
    next_nap_picture=step;
    current_graphic=1;
    f1=figure(1);clf;
    set(f1,'position',[ 640     1   640   400])
else
    next_nap_picture=inf; % never this graphic
end



% set a variable for the current starting time of each frame for plotting
for i=1:nr_sai_pictures
    start_times(i)=(i-1)*sai_pictureduration+movie_start_time;
    sai_graphic_times(i)=start_times(i)+sai_pictureduration-sampletime;
end

next_sai_graphic=sai_graphic_times(1);
current_sai_graphic=1;

fprintf('producing stobed image:\n');
% We start the time at zero:
current_time=movie_start_time;
nr_dots=getnrpoints(sharpnap);
clear saioptions;
saioptions.start_time=start_times(i);
saioptions.maxdelay=0.035;
saioptions.strobe_weight_alpha=1;  % alpha parameter in the weightening of the single strobes
saioptions.phase_adjustment=1.5;    % after so many cycles the change of weight takes effect
saioptions.mindelay_in_cycles=1.5;  % so many cycles are not filled in the sai-buffer
saioptions.buffer_memory_decay=0.04;    % time for the buffer to go from 100% to 0
saioptions.weightthreshold=0.001;   % only thresholds bigger than 1%
if ~strcmp(producemovie,'no')
    saioptions.grafix=1;   % no graphical outout during processing
end
saioptions.select_channels=select_channels;
saioptions.const_memory_decay=power(0.5,1/(saioptions.buffer_memory_decay*samplerate)); % the amount per sampletime
saioptions.signal_start_time=movie_start_time;

% construct the starting SAI with zeros
nrdots_insai=round(saioptions.maxdelay*samplerate);
svals=zeros(getnrchannels(sharpnap),nrdots_insai);
fstruct.outputTimeOffset=0;
fstruct.totalframetime=saioptions.maxdelay;
current_sai=frame(svals,fstruct,getcf(sharpnap));
current_sai_struct.data=current_sai;
for i=select_channels
    if length(allstrobeprocesses{i}.strobes) > 0
        info.next_strobe=allstrobeprocesses{i}.strobes(1);    % the next strobe in line
    else
        info.next_strobe=inf; % no strobe
    end
    info.current_strobe_nr=0;    % the current number of the strobe which is processed
    info.strobeprocesses=[]; % no active strobes in queue
    info.strobe_adjust_phase=inf; % the next update of weights
    info.was_adjusted=0;
    current_sai_struct.info{i}=info;
end


if ~strcmp(producemovie,'no')
    MakeQTMovie('start',moviefile);
    MakeQTMovie('size', [640 400]);
    MakeQTMovie('quality', 0.9);    % reduces the size
    % only, to know, how many channels we have:
    for i=1:nr_sai_pictures
        fprintf('*');
    end
    fprintf('\n');
end

for i=1:nr_dots
%     fprintf('*');
    current_time=current_time+sampletime;
    current_sai_struct=updatesai2(sharpnap,current_sai_struct,allstrobeprocesses,saioptions,current_time);
    
    if ~strcmp(producemovie,'no')
        if current_time>=next_nap_picture
            if current_graphic<length(graphic_times)
                next_nap_picture=graphic_times(current_graphic+1);
                current_graphic=current_graphic+1;
            else
                next_nap_picture=inf;
            end
            disp_start_time=current_time-0.035;
            if disp_start_time < movie_start_time
                disp_start_time = movie_start_time;
            end
            disp_duration=0.05  ;
            maxtime=getmaximumtime(sharpnap);
            if disp_start_time+disp_duration > maxtime
                disp_start_time = maxtime-disp_duration;
            end
            
            plotoptions.sharpnap=sharpnap;
            plotoptions.allthresholds=allthresholds;
            plotoptions.current_sai_struct=current_sai_struct;
            plotoptions.allstrobeprocesses=allstrobeprocesses;
            plotoptions.maxnap=maxnap;
            plotoptions.maxheight=maxheight;
            plotoptions.current_time=current_time;
            plotoptions.saioptions=saioptions;
            plotoptions.select_channels=select_single_channels;
            plotoptions.disp_start_time=disp_start_time;
            plotoptions.disp_duration=disp_duration;
            
            plotoptions=doplot(plotoptions);
        end
        if current_time > next_sai_graphic
            fprintf('*');
            current_sai_struct.data=setcurrentframestarttime(current_sai_struct.data,current_time);
            all_finished_frames(current_sai_graphic)=current_sai_struct.data;
            if current_sai_graphic<length(sai_graphic_times)
                current_sai_graphic=current_sai_graphic+1;
                next_sai_graphic=sai_graphic_times(current_sai_graphic);
                saiplotoptions.bla=0;
                
                if strcmp(producemovie,'sai_and_nap')
                    saiplotoptions=plotsai(current_sai_struct,current_time,saiplotoptions);
                elseif strcmp(producemovie,'dualprofile')
                    plotsaiprofiles(current_sai_struct,current_time);
                else
                    plotsaionly(current_sai_struct,current_time);
                end
            else
                next_sai_graphic=inf;
            end
            MakeQTMovie('addframe');    % and add it to the movie
%             fprintf('\n');
        end
    end    
end

if ~strcmp(producemovie,'no')
    % add one, to fill the last picture (the sound is longer than n*nr_frames)
    MakeQTMovie('addframe');
    MakeQTMovie('framerate', framespersecond);
    if strcmp(producemovie,'sai_only')
        MakeQTMovie('addsound',sounddata,samplerate); 
    end
    
    MakeQTMovie('finish');
    MakeQTMovie('cleanup');
end

return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function options=doplot(options)
sharpnap=options.sharpnap;
current_sai_struct=options.current_sai_struct;
allthresholds=options.allthresholds;
allstrobeprocesses=options.allstrobeprocesses;
maxnap=options.maxnap;
maxheight=options.maxheight;
current_time=options.current_time;
saioptions=options.saioptions;
select_channels=options.select_channels;
disp_start_time=options.disp_start_time;
disp_duration=options.disp_duration;
if ~isfield(options,'oldhandle1')
    options.oldhandle1=0;
end
if ~isfield(options,'oldhandle2')
    options.oldhandle2=0;
end

% Graphic Output

if length(select_channels)==1
    saibuffer=getsinglechannel(current_sai_struct.data,select_channels);
    saibuffer=setnrxticks(saibuffer,8);
    sr=getsr(saibuffer);
    nr_active_strobes=length(current_sai_struct.info{select_channels}.strobeprocesses);
    orgsignal=getsinglechannel(sharpnap,select_channels);
    single_channel=getpart(orgsignal,disp_start_time,disp_start_time+disp_duration);
    single_channel=setname(single_channel,getname(saibuffer));
    saibuffer=setname(saibuffer,'SAI');
    saibuffer=setstarttime(saibuffer,0);
    threshold=getsinglechannel(allthresholds,select_channels);
    single_channel=setnrxticks(single_channel,5);
    threshold=getpart(threshold,disp_start_time,current_time);
    strobe_process=options.current_sai_struct.info{select_channels}.strobeprocesses;
    
    mysubplot(1,1,1,[0.65 0.1 0.35 0.3]);
    if options.oldhandle1~=0
        delete(options.oldhandle1);
    end
    options.oldhandle1=gca;
    plot(saibuffer);   
    set(gca,'DrawMode','fast'); 
    set(gca,'NextPlot','add');
    ylabel('');
    if max(saibuffer)>maxheight
        maxheight=maxheight*1.1;
    end
    axis([1 getnrpoints(saibuffer),0,maxheight]);
    %     text(300,maxheight/1.5,sprintf('sum: %3.2f',sum(saibuffer)));
    text(300,maxheight/2,sprintf('#time: %dms',floor(current_time*1000)));
    text(300,maxheight/2.8,sprintf('#Strobes: %d',nr_active_strobes));
    
    mysubplot(1,1,1,[0.65 0.5 0.35 0.3]);
    if options.oldhandle2~=0
        delete(options.oldhandle2);
    end
    options.oldhandle2=gca;
    set(gca,'Xtick',[]);
    set(gca,'Ytick',[]);
    plot(threshold,'g');
    hold on
    plot(single_channel,'-');
    ylabel('');
    if max(single_channel)>maxnap
        maxnap=maxnap*1.1;
    end
    if max(threshold)>maxnap
        maxnap=maxnap*1.1;
    end
    axis([1 getnrpoints(single_channel),0,maxnap]);
    for k=1:length(strobe_process)
        gc=plot(time2bin(single_channel,strobe_process(k).time),strobe_process(k).nap_value,'.r');
        suze=log(200*strobe_process(k).weight)*5;
        suze=max(suze,5);
        set(gc,'MarkerSize',suze);
    end
    drawnow;
else % end only one channel
    % from here: more then one channel
    %     figure(1);clf;
    %     partthres=getpart(allthresholds,disp_start_time,current_time);
    %     str.plotcolor='g';
    %     plot(partthres,str); hold on
    %     partnap=getpart(sharpnap,disp_start_time,disp_start_time+disp_duration);
    %     plot(partnap); hold on
    %     
    %     %     for k=1:length(strobe_process)
    %     %         gc=plot(time2bin(single_channel,strobe_process(k).time),strobe_process(k).nap_value,'.r');
    %     %         suze=log(200*strobe_process(k).weight)*5;
    %     %         suze=max(suze,5);
    %     %         set(gc,'MarkerSize',suze);
    %     %     end
    %     
    %     
    %     
    %     sai=current_sai_struct.data;
    % %     figure(2);clf;
    %     plot(sai);
    %     
    %     drawnow;
end
return



function options=plotsai(current_sai_struct,current_time,options)
mysubplot(1,1,1,[-0.05 0 0.7 0.9]);
gopt.current_frame = current_sai_struct.data;
gopt.maximum_time_interval = 35;
gopt.minimum_time_interval= 0;
gopt.is_log=0;
gopt.plot_scale=1/5;
gopt.show_time=1;
gopt.time_reversed=1;
gopt.frequency_profile_scale=400;
gopt.time_profile_scale=0.03;
gopt.options=options;
options=AIFrePtiP(gopt);
drawnow;
return

function plotsaionly(current_sai_struct,current_time)
gopt.current_frame = current_sai_struct.data;
gopt.maximum_time_interval = 35;
gopt.minimum_time_interval= 0;
gopt.is_log=0;
gopt.plot_scale=1/5;
gopt.show_time=1;
gopt.time_reversed=1;
gopt.frequency_profile_scale=400;
gopt.time_profile_scale=0.03;
clf
AIFrePtiP(gopt);
drawnow;
return

function plotsaiprofiles(current_sai_struct,current_time)
gopt.current_frame = current_sai_struct.data;
gopt.frequency_profile_scale=0.002;
gopt.time_profile_scale=0.01;clf
combFrePtiP(gopt);
drawnow;
return
