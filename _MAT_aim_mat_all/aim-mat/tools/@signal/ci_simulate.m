% method of class @signal
% function sig=ci_simulate(signal)
%
%   INPUT VALUES:
%       sig:      @signal
%
%   RETURN VALUE:
%       sigresult:  @signal `
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=ci_simulate(sigorg)
% stolen from AMO.m

audio_sample_rate=getsr(sigorg);
% audio_sample_rate=16000;

p.channel_stim_rate=900;
p.audio_sample_rate=audio_sample_rate;
p.analysis_rate=p.channel_stim_rate;
p.num_selected = 10;
p.num_bands = 22;
p.electrodes=22:-1:1;

p=Append_process(p,'FFT_filterbank_proc');
p=Append_process(p,'Power_sum_envelope_proc');
p=Append_process(p,'Reject_smallest_proc');

values=getvalues(sigorg);
FTM=Process(p,values);


% Parameters for Resynthesis
% --------------------------
pre.resynthesis_rate = audio_sample_rate;
pre.num_bands = p.num_bands;
pre.analysis_rate = p.channel_stim_rate;
pre.electrodes=p.electrodes;

insertion = 22;                     % insertion depth in mm
cochlength=33;  % length of cochlea
elecspacing = 0.75;                                                             % spacing between electrodes in mm
b = 0.3;                             % space constant in mm

% prepare non-overlapping crossover frequencies according to Greenwood
% --------------------------------------------------------------------
for i=1:23
    %elec_position_base(i)=insertion-elecspacing*(i-1);                            % position of elec in cochlea from base [mm]
    crossover_position_base(i)=insertion - (elecspacing*(i-1) - elecspacing*0.5);  % position between electrodes from base [mm]
end
crossover_position_apex=cochlength-crossover_position_base';                        % position between electrodes from apex [mm]
crossover_freqs_greenwood=Greenwood_x2cf(crossover_position_apex);                  % corresponding Greenwood frequencies
% check if there are frequencies above 1/2 sampling rate,
% and remove those bands from FTM, electrodes and crossover freq table
toohigh=sum(crossover_freqs_greenwood>0.5*pre.resynthesis_rate);
crossover_freqs_greenwood=crossover_freqs_greenwood(1:end-toohigh);                 % only those < half the sampling rate
pre.electrodes=pre.electrodes(1:sum(p.electrodes>toohigh));
FTM=FTM(1:sum(p.electrodes>toohigh),:);
num_bands_after=length(pre.electrodes);
if pre.num_bands~=num_bands_after
    msgbox([num2str(pre.num_bands-num_bands_after) ' of the active basal electrodes correspond(s) to frequencies > half the sampling frequency and will be disabled.'],'Disabling electrodes','warn','modal');
end
pre.num_bands=num_bands_after;

% resynthesize
% ------------
%sinusoid
%     pre.resynthesis_carrier = 'sinus';
%     pre.crossover_freqs=crossover_freqs_greenwood;  % sinusoids following Greenwood

% noise                                   % NOISE
    pre.resynthesis_carrier = 'noise';  
    pre.crossover_freqs=crossover_freqs_greenwood;

pre = Resynthesis(pre);
simul = Resynthesis(pre,FTM);
       
%Windowing and zeropadding to remove clicks
w = risewindow(length(simul),0.01*pre.resynthesis_rate)';     %a 10 ms linear rise and fall
simul = [zeros(1,10) w.*simul zeros(1,10)];

    
    % return a signal:
sig=signal(simul,audio_sample_rate);
sig=setname(sig,'Convolution');


return;