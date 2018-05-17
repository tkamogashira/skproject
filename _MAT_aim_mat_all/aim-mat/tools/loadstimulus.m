% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function [stim,wavefilename,stimdir]=loadstimulus(handles,annum,unnum,exnum,sweepnum)



if nargin==5  % its single electrode
    [extypetotal,experiment_type,ana_tpye]=get_experiment_type(handles,annum,unnum,exnum);
    if strcmp(experiment_type,'aseca')
        stimdir=get_aseca_wave_dir(handles,annum,unnum,exnum);
        idstr=['0000' num2str(sweepnum)];
        idstr=idstr(end-4:end);
        wavefilename=sprintf('stimid%s.CAP.wav',idstr);
        fullname=fullfile(stimdir,wavefilename);
    else
        exdir=get_experiment_dir(handles,annum,unnum,exnum);
        stimdir=fullfile(exdir,'Saved Stimuli');
        anstr=num2str(annum);
        unstr=['00' num2str(unnum)];
        unstr=unstr(end-2:end);
        exstr=['00' num2str(exnum)];
        exstr=exstr(end-2:end);
        swstr=['000' num2str(sweepnum)];
        swstr=swstr(end-3:end);
        wavefilename=sprintf('an%sun%sex%sstim%s.wav',anstr,unstr,exstr,swstr);
        fullname=fullfile(stimdir,wavefilename);
    end
    stim=loadwavefile(signal,fullname);    
elseif  nargin==4  % its multielectrode
    sweepnum=exnum;
    exnum=unnum;
    exdir=get_meex_dir(handles,annum,exnum);
    stimdir=fullfile(exdir,'Saved Stimuli');
    anstr=num2str(annum);
    exstr=['000' num2str(exnum)];
    exstr=exstr(end-3:end);
    swstr=['000' num2str(sweepnum)];
    swstr=swstr(end-3:end);
    stimname=sprintf('an%sex%sstim%s.wav',anstr,exstr,swstr);
    fullname=fullfile(stimdir,stimname);
    stim=loadwavefile(signal,fullname);
end

