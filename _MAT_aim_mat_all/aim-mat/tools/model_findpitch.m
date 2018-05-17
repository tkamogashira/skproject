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

function [ret,sig,sp]=model_findpitch(varargin)
%usage: [ret,sig,sp]=findpitch(varargin)
%
% modelfile - the spf file with the model in (required)
% soundfile - a wave or raw file with the sound in 
% or a call to a signal-generating function (like genharmonics())
%
% output_normalization - the norm_mode parameter in out_file very useful for automatic scaling
% input_scale - scaling factor, that is directly applied to the input values - to prevent too loud sounds (default 1 can be set to auto)
% framespersecond (default: 33) - each pitch is calculated so often per second 
% aifffile - optional instead of model
% single_times - take the pitch only at these times
% singleframe - only one pitch is calculated at this time
% getframeinstead - give me the according frame at this point in time
%
% sig is a signal-class (see help signal)
% ret is a struct of highest values in Hz and in relativ height (highest==1) for each frame
% ret.freq(1:n) and
% ret.amp(1:n)
% 


str_model=getargument(varargin,'modelfile');
str_soundfile=getargument(varargin,'soundfile');
str_input_scale=getargument(varargin,'input_scale');
str_output_normalization=getargument(varargin,'output_normalization');
str_framespersecond=getargument(varargin,'framespersecond');
str_aifffile=getargument(varargin,'aifffile');
str_single_times=getargument(varargin,'single_times');
str_single_frame=getargument(varargin,'single_frame');
str_getframeinstead=getargument(varargin,'getframeinstead');

model=str_model{1};
if findstr(str_model{1},'spf')==[]
    str_model{1}=sprintf('%s.spf',str_model{1});
end
soundfile=str_soundfile{1};

if strcmp(str_input_scale,'')     % how much the spf file should be normalized by setting the norm_mode parameter in out_file
    str_input_scale{1}='1.0';
    input_scale=1;
else
    if strcmp(str_input_scale,'default') 
    else
        eval(sprintf('input_scale=%s;',str_input_scale{1}));    
    end
end

if strcmp(str_single_frame,'')
    single_frame_modus=0;
else
    single_frame_modus=1;
    eval(sprintf('single_frame=%s;',str_single_frame{1}));    
end

if strcmp(str_getframeinstead,'')
    no_pitch_frame_instead_modus=0;
else
    no_pitch_frame_instead_modus=1;
    eval(sprintf('frame_instead_at=%s;',str_getframeinstead{1}));    
end

if strcmp(str_model,'.spf')
    if strcmp(str_aifffile,'')     % an aifffile that is read instead
        disp('modelfile or aiff must be given');
        return
    else
        calculation_type='no_dsam';
    end
else
    calculation_type='normal';
    model=str_model{1};
end

if strcmp(str_aifffile,'')
    %    aifffile=fullfile(pwd,'findpitch_temp.aif'); % the full-aiffile, that is used, when nothing is specified
    aifffile='findpitch_temp.aif'; % in the current directory, otherwise the path is too long for ams
else
    aifffile=str_aifffile{1};
    if ~fexist(aifffile)
        disp('AIFF File not found');
        return;
    end
    for i=1:100
        cf(i)=1000*i;    
    end
    videolength=1;  % just to prevent the warning - its not used!
end

% pitch is calculated every 30 ms:
if strcmp(str_framespersecond,'')     % how much the spf file should be normalized by setting the norm_mode parameter in out_file
    framespersecond=33;
else
    eval(sprintf('framespersecond=%s;',str_framespersecond{1}));    
end    

% first: Get the soundfile
old_path=pwd;
[soundpathstr,soundname,ext,versn] = fileparts(soundfile);

if ~strcmp(soundpathstr,'')
    cd(soundpathstr);
end
if fexist(soundfile)
    if strcmp(ext,'.raw') | strcmp(ext,'') % or no ending
        if strcmp(str_sound_sample_rate,'') & strcmp(str_sound_endian,'')
            [data,sr,endi]=rawfile2wavfile(soundfile);
            % save for later:
            str_sound_sample_rate{1}=sprintf('%f',sr);
            str_sound_endian{1}=endi;
        else
            if strcmp(str_sound_sample_rate,'') | strcmp(str_sound_endian,'')
                disp('findpitch: error: both samplerate and endian must be given!');
                return;
            else
                eval(sprintf('samplerate=%s;',str_sound_sample_rate{1}));
                endian=str_sound_endian{1};
                rawfile2wavfile(soundfile,samplerate,endian);
            end
        end
        
        [path,name,ext,versn] = fileparts(soundfile);
        newfilename=sprintf('%s.wav',name);
        newname=fullfile(path,newfilename);
        soundfile=newname;
    end
    [soundpathstr,soundname,ext,versn] = fileparts(soundfile);
    if strcmp(ext,'.wav')
        
        % first read in data
        [readsounddata,samplerate,bits] = wavread(soundfile);
        
        % than scale it correctly
        fmax=max(readsounddata);
        if fmax>1
            resp=input('Achtung: Clipping in the input signal due to too high input_scale. Correct it? [y]/n','s');
            if ~strcmp(resp,'n')
                readsounddata=readsounddata*0.999/fmax;
            end
        end
        
        % and then write it back again to the temp-name:
        cd(old_path);
        wavwrite(readsounddata,samplerate,'findpitch_temp.wav');
        str_soundfile{1}='findpitch_temp.wav';
    else
        disp('Format not implemented yet!');
        return;
    end
else
    % a user defined function
    if strcmp(calculation_type,'normal')   % nur, wenn das Signal nötig ist
        eval(sprintf('datasig=%s;',str_soundfile{1}));
        datasig=ScaleToMaxValue(datasig,0.999);
        readsounddata=getdata(datasig);
        cd(old_path);
        samplerate=getsr(datasig);
        bits=16;
        writetowavefile(datasig,'findpitch_temp.wav');
        str_soundfile{1}='findpitch_temp.wav';
        soundfile='findpitch_temp.wav';
    end
end


% if the wav file has two channels, (stereo) only the left channel is used for calculation
if strcmp(calculation_type,'normal')   % nur, wenn das Signal nötig ist
    nr_chan=size(readsounddata,2);
    if nr_chan>1
        sounddata=readsounddata(:,1); % only the first channel
    else
        sounddata=readsounddata;
    end
    videolength=size(sounddata,1)/samplerate;
end

% so long is one picture:
duration=1/framespersecond; 
% so many frames is the video size in the end:
nr_frames=videolength*framespersecond; 
starttime=0;

if strcmp(calculation_type,'normal')
    
    disp('Start generating sounds and modify spf-file...');
    % if which=1 then a new aif file is constructed with simulation (the final mode)
    % to test things, its useful to have a test mode in which a already made findpitch_temp.aif is loaded
    id=fopen(model,'rt');
    if id<=0
        disp(sprintf('Model-file %s not found',model));
        return;
    end
    fclose(id);
    id=fopen(soundfile,'rt');
    if id<=0
        disp(sprintf('Sound-file %s not found',soundfile));
        return;
    end
    fclose(id);
    
    % fit the spf file to our needs. The line command-line options are not powerful enough (and not working correctly in <2.6.3)
    l=loadtextfile(model);
    somuchruns=sprintf('%2.0f',nr_frames);
    l=DSAMSubstituteParameter(l,'NUM_RUNS.ams.0',somuchruns);
    % actually, this one is not working in version 2.6.3, so we have to define it by command line. I let it in here, because Id prefere it this way
    l=DSAMSubstituteParameter(l,'SEGMENT_MODE.ams.0','ON'); % just to be sure...
    l=DSAMSubstituteParameter(l,'FILELOCKING_MODE.ams.0','ON'); % just to be sure...
    
    % check, if there is an output, otherwise create one
    dummy='nothing';
    dummy=DSAMFindParameter(l,'DataFile_Out');
    if strcmp(dummy,'<')  %yes, the parameter is there, but is it commented?
        bool=DSAMtParameterIsCommented(l,'DataFile_Out',1);
        if bool %             disp('DataFile_Out file commented in spf ');
            l=DSAMCommentParameter(l,'DataFile_Out',0,1);% remove the comment
        else   % everything ok! :-) OutFile is there and not commented
        end
    else
        disp('no DataFile_Out file specified in spf - building one... ');
        l=DSAMAddOutputFile(l,aifffile,'l',samplerate);
        %         return;
    end
    
    % if the user wants all channels, than comment out the channel reducing line
    %     if  strcmp(str_graphictype,'waterfall') | strcmp(str_graphictype,'waterfallsum')| strcmp(str_graphictype,'surf') 
    %         l=DSAMCommentParameter(l,'Util_ReduceChannels',1);
    %     end
    
    % turn off the displays:
    finished=0;
    nr_display=1;
    while ~finished
        new=DSAMCommentParameter(l,'Display_Signal',1,nr_display);  % comment this line
        
        if isnumeric(new) & new==-1
            break;  % finished :-)
        else
            l=new;
            nr_display=nr_display+1;
        end
    end
    
    % build the correct dsam-output my-input aif-file:
    stra=sprintf('"%s"',aifffile);
    
    l=DSAMSubstituteParameter(l,'FILENAME.DataFile_Out',stra);
    
    
    %         l=DSAMSubstituteParameter(l,'FILENAME.DataFile_In',sfile);
    l=DSAMSubstituteParameter(l,'FILENAME.DataFile_In','findpitch_temp.wav');
    
    % bring it to a format, that dsam understands:
    wordsize=bits/8;
    words=sprintf('%d',wordsize);
    l=DSAMSubstituteParameter(l,'WORDSIZE.DataFile_In',words);
    srat=sprintf('%f',samplerate);
    l=DSAMSubstituteParameter(l,'SAMPLERATE.DataFile_In',srat); 
    dur=sprintf('%f',duration);
    l=DSAMSubstituteParameter(l,'DURATION.DataFile_In',dur);
    star=sprintf('%f',starttime);
    l=DSAMSubstituteParameter(l,'STARTTIME.DataFile_In',star);
    
    if strcmp(str_input_scale,'default')  % scale to a fixed number in the input
        gain=sprintf('%f',defined_input_gain);
        l=DSAMSubstituteParameter(l,'GAIN.DataFile_In',gain);
    end
    
    
    % scaling must be performed in the input file to prevent too high numbers in the output
    
    % !!!
    % % the user has to set the correct scale value in the original spf-file
    % this is best done by watching a whole film in ams and searching for the biggest
    % value. Set this value as parameter 'NORM_MODE.DataFile_Out' 
    % it is NO GOOD IDEA to set this value to -1 (auto) because, this value is calculated
    % from the first frame and this ist not the highest. As result, strange negative values occure!
    
    % therefore we set the gain in the input file to a very small value:
    %         gain=sprintf('%f',70);
    %         l=DSAMSubstituteParameter(l,'GAIN.DataFile_In',gain);
    %         the version with scaling in the output file (below) didnt work:
    
    if ~strcmp(str_output_normalization,'')     % how much the spf file should be normalized by setting the norm_mode parameter in out_file
        l=DSAMSubstituteParameter(l,'NORM_MODE.DataFile_Out',str_output_normalization{1});
    end
    
    
    % save the modified file to disk
    savetofile(l,'findpitch_temp.spf');
    
    % find out abput the times used in ms to display numbers
    t_minusstr=DSAMFindParameter(l,'NWIDTH.Ana_SAI');
    t_minus=sscanf(t_minusstr,'%f')*1000;
    t_plusstr=DSAMFindParameter(l,'PWIDTH.Ana_SAI');
    t_plus=sscanf(t_plusstr,'%f')*1000;
    
    % do I need later:
    str_scale_factor_output=DSAMFindParameter(l,'NORM_MODE.DataFile_Out');
    scale_factor_output=sscanf(str_scale_factor_output,'%f');
    
    
    % find out about the frequency axis and make it nice
    nrfreqstr=DSAMFindParameter(l,'CHANNELS.BM_GammaT');
    nr_freq=sscanf(nrfreqstr,'%d'); % so many frequencies on y-axis
    
    for i=1:nr_freq
        cfstr=DSAMFindParameter(l,'CENTRE_FREQ.BM_GammaT',i); % so many frequencies on y-axis
        cfb=sscanf(cfstr,'%f:%f'); % so many frequencies on y-axis
        cf(i)=cfb(2);
    end
    
    % ams must be in Path or this line must point to its directory:
    %cd('C:\Program Files\DSAM\AMS');
    
    % delete the remains from last run
    if fexist('findpitch_temp.aif')
        eval('! del findpitch_temp.aif');
    end
    
    
    % the command line, that starts the process:
    % mas_ng starts a single ams process without grafik (very fast)
    % -d turns off the debug messages
    % -s calls the file findpitch_temp.spf
    % -r gives the number of runs (somuchruns)
    % segment on tells dsam to run in segmented mode
    str=sprintf('! AMS_ng.exe -doff -sfindpitch_temp.spf -r%s  segment on',somuchruns);    
    
    % this one works with a window.
    %      str=sprintf('! AMS.exe -S -s findpitch_temp.spf -r %s &',somuchruns);
    
    % delete the remains of some buggy run:
    if fexist('.ams_LCK')
        try
            delete('.ams_LCK');
        catch
            disp('Could not delete existing file .ams_LCK. Please restart matlab');
        end
    end
    
    disp('Ams simulation started...')
    eval([str]);    % do ams!
    
    t0 = clock;
    while etime(clock,t0)<0.5 %wait a little while
    end
    
    % and look for the lock file
    while fexist('.ams_LCK')
    end % continue, when its _not_ there
    
    
    % if strcmp(calculation_type,'no_dsam')
    FID = fopen(aifffile,'r');
    if FID==-1
        disp('error in simulation: aif-file was not generated!');
        return;
    end
    fclose(FID);
    % end
    % now we know for shure, that it was successfull!
    
end


allframes=SBReadAiff(aifffile);    % returns all info in a struct

% find out about the structure
sample_frame=allframes(1);
nr_channels=getnrchannels(sample_frame);
nr_points=getnrpoints(sample_frame);
nr_frames=size(allframes,2);

for i=1:nr_frames allframes(i)=setcf(allframes(i),cf); end

% values for scaling the actual sum of all channels
scale_summe=0;% this value is used to scale the picture of the sum later
for i=1:nr_frames
    su=getsum(allframes(i)); 
    ma=max(su);
    if ma > scale_summe scale_summe=ma; end
end

low=getamplitudeminvalue(sample_frame);

if low < 0
    disp('Achtung: Negative values in the AIFF-File! ');
    disp('This probably means, that the value in ');
    disp('NORM_MODE in DataFile_Out was not high enough!');
    disp(sprintf('current value: %f',scale_factor_output));
    fprintf('\n[a] double it, (b) stop, (c) continue anyway  \nor type in the new value\n');
    reply = input(': ','s');
    if isempty(reply) % default
        reply ='a';
    end
    if reply == 'b'
        return;
    end
    valgiven=0;
    if reply~='a' & reply~='c'
        eval(sprintf('val=%s;',reply));
    else
        if reply=='a'
            val=2 * scale_factor_output;  % double it!
        end
        if reply=='c'
            val=scale_factor_output;  % no change
        end
    end
    if isnan(val) | val<=0
        disp('sorry, no valid input');
        return;
    end
    if val~=scale_factor_output % only, if there is a change!
        scale_factor_output=val;
        strscale=sprintf('%f',scale_factor_output);     % run again with higher output normalization
        ret=model_findpitch('modelfile',str_model{1},'soundfile',str_soundfile{1}, ...
            'output_normalization',strscale,'input_scale',str_input_scale{1}, ...
            'framespersecond',str_framespersecond{1});
        return;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% finished with calculating, now the pitch extraction can begin:
reduced_channel_mode=0; % erstmal...

t_minus=getminimumtime(sample_frame);
t_plus=getmaximumtime(sample_frame);

minimum_time_interval=0.5;  % highest frequency
maximum_time_interval=-t_minus; % in ms!  % to the end of the stimulus

% setsumscale(sample_frame(framestruct.scale_summe = scale_summe;

%  wenn gar keine verschiedenen pitches berechnet werden sollen
if no_pitch_frame_instead_modus
    time=frame_instead_at;
    nr_fr=floor(time*framespersecond);
    if nr_fr>nr_frames
        disp('single frame time not in range of audio signal');
        return;
    end
    ret=allframes(nr_fr);
    
    return;
end

disp('calculate pitches');

if single_frame_modus 
    time=single_frame;
    nr_fr=floor(time*framespersecond);
    if nr_fr>nr_frames
        disp('single frame time not in range of audio signal');
        return;
    end
    current_frame=allframes(nr_fr);
    ret=findsummaxima(current_frame);
    
else    % calculate pitch for all frames
    for i=1:nr_frames
        fprintf('*');
        if(mod(i+1,30)==0)
            fprintf('\n');
        end
        current_frame=allframes(nr_fr);
        ret(i)=findsummaxima(current_frame);
    end
end
