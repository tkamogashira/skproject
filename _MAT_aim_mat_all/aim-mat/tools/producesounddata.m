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

function [sounddata,samplerate,bits,endian]=producesounddata(soundcommand,temp_sound_file_name,str_sound_sample_rate,str_sound_endian,start_time,duration)
% usage: [sounddata,samplerate,endian]=producesounddata(soundcommand)
% returns important data about the sound.
% The sound can be a file (wav or raw) or a function or a global signal-object
% parameters: 
% soundcommand  - the file or the command
% temp_sound_file_name - a filename to which the wave is written 
% str_sound_sample_rate - the sample rate
% str_sound_endian  - the sound endian
% start_time - the starting time when not zero
% duration - how long shell the signal be

if nargin < 4    str_sound_endian=1;end
if nargin < 3    str_sound_sample_rate=20000;end
if nargin < 2    temp_sound_file_name='temp_sound.wav';end
if nargin < 1
    error('producesounddata: Sound command must be given');
end


old_path=pwd;
endian=0;
bits=16;

[soundpathstr,soundname,ext,versn] = fileparts(soundcommand);
if fexist(soundcommand) % if it is a file. It could be a function
    with_sound=1;
    [soundpathstr,soundname,ext,versn] = fileparts(soundcommand);
    if ~strcmp(soundpathstr,'')
        cd(soundpathstr);
    end
    if fexist(soundcommand)
        if strcmp(ext,'.raw') | strcmp(ext,'') % or no ending
            if isempty(str_sound_sample_rate) & isempty(str_sound_endian)
                [data,sr,endi]=rawfile2wavfile(soundcommand);
            else
                if isempty(str_sound_sample_rate) | isempty(str_sound_endian)
                    error('makemovie: error: both samplerate and endian must be given!');
                else
                    eval(sprintf('samplerate=%s;',str_sound_sample_rate));
                    endian=str_sound_endian;
                    rawfile2wavfile(soundcommand,samplerate,endian);
                end
            end
            
            [path,name,ext,versn] = fileparts(soundcommand);
            newfilename=sprintf('%s.wav',name);
            %             newname=fullfile(old_path,newfilename);
            newname=fullfile(path,newfilename);
            soundcommand=newname;
        end
        [soundpathstr,soundname,ext,versn] = fileparts(soundcommand);
        if strcmp(ext,'.wav')
            
            % first read in data
            [readsounddata,samplerate,bits] = wavread(soundcommand);
%             [readsounddata,samplerate,bits] = wavread([soundname ext]);
            
            fmax=max(readsounddata);
            if fmax>1
                resp=input('Achtung: Clipping in the input signal due to too high input_scale. Correct it? [y]/n','s');
                if ~strcmp(resp,'n')
                    readsounddata=readsounddata*0.999/fmax;
                end
            end
            
            % dsam doesnt like samplerates of 44100. It explodes
            if samplerate==44100
                disp('dsam doesnt like samplerates of 44100. It explodes. Changing SR to 16000');
                samplerate=16000;
                sig=signal(readsounddata);
                sig=setsr(samplerate);
                sig=changesr(sig,samplerate);
                readsounddata=getvalues(sig);
            end
            
            % and then write it back again to the temp-name:
            cd(old_path);
            wavwrite(readsounddata,samplerate,bits,temp_sound_file_name);
        else
            error('Format not implemented yet!');
        end
    else
        error('Sound-file not found');
    end
    
    % if the wav file has two channels, (stereo) only the left channel is used for calculation
    nr_chan=size(readsounddata,2);
    if nr_chan>1
        sounddata=readsounddata(:,1); % only the first channel
    else
        sounddata=readsounddata;
    end
    videolength=size(sounddata,1)/samplerate;
else  %if exist soundcommand
    
    % a user defined function or an object
    try % to simple make the thing. If its a script, that works
        eval(sprintf('datasig=%s;',soundcommand));
%         disp(sprintf('producing sound from function: %s',soundcommand));
    catch
        try % to assume, that its an global object
            eval(sprintf('global %s;',soundcommand));
            eval(sprintf('datasig=%s;',soundcommand));
%             disp(sprintf('producing sound from signal-object: %s',soundcommand));
        catch
            if strfind(soundcommand,'wav') | strfind(soundcommand,'raw')
                error(sprintf('could not open soundfile: %s',soundcommand));
            else
                disp('getaiffs: error: something wrong with the creation of the signal!');
                error(sprintf('if %s is a signal-object, than make it global!',soundcommand));
            end
        end
    end
    datasig=scaletomaxvalue(datasig,0.999);
    readsounddata=getdata(datasig);
    cd(old_path);
    samplerate=getsr(datasig);
    bits=16;
    writetowavefile(datasig,temp_sound_file_name);
    soundcommand=temp_sound_file_name;
end


nr_chan=size(readsounddata,2);
if nr_chan>1
    sounddata=readsounddata(:,1); % only the first channel
else
    sounddata=readsounddata;
end


% simple way to define the length of the singal: read it back in again :-)
% this is simple, because I know, that it is there!

if nargin > 5 % only, when start time is there
    sig=loadwavefile(signal,temp_sound_file_name);
    if start_time+duration < getlength(sig)
        sig=getpart(sig,start_time,start_time+duration);
    else
        sig=getpart(sig,start_time,getmaximumtime(sig));
    end
    writetowavefile(sig,temp_sound_file_name);
    [sounddata,samplerate,bits] = wavread(temp_sound_file_name);
end
