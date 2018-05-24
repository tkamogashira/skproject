function [Nsam, Timing, RiseWin, FallWin]=DelayRecipe(EXP, Fsam, DAchan, ITDdelay, ITDtype, Dur)
% DelayRecipe - realize various types of delays 
%   [Nsam Timing, RiseWin, FallWin]=DelayRecipe(EXP, Fsam, DAchan, ITDdelay, ITDtype, Dur)
%   helps computing the exactly timed waveform by providing sample counts,
%   directions for cutting from waveform buffers, and gating windows.
%   Input parameters are
%          EXP: experiment definition
%         Fsam: sample rate [Hz]
%       DAchan: DA channel L|R
%     ITDdelay: positive delay [ms] in this DA channel for realizing ITD 
%      ITDtype: type of ITD waveform|ongoing|gating
%          Dur: struct containing the durations [ms] RiseTime, OnsetDelay,
%               BurstDur, FallTime, ISI as fields.
%   Output parameters are
%        Nsam: struct containing the sample counts Npre, Nrise, Nsteady,
%              Nfall, Npost as fields.
%      Timing: struct containing the fields
%            CutOffset: offset [ms] to start cutting from the [virtual] 
%                       waveform. Note that this offset has sub-sample 
%                       accuracy, which must be respected in order to 
%                       realize the exact ITDs. This means that the timing 
%                       of the cut is typically applied in the frequency 
%                       domain in terms of phases.
%              calibDt: numerical-to-acoustical latency [ms] for this DA
%                       channel and sample rate. This latency is typically
%                       not used when computing the waveforms, but it is
%                       important when analyzing temporal aspects of the 
%                       data such as first-spike latency. See calibrate.
%            binCompDt: the delay [ms] by which the waveform of this
%                       channel will be delayed in order to correct any
%                       interaural asymmetries in numerical-to-acoustical
%                       latency. Note that the instructions for waveform
%                       construction contained in Nsam and Timing.CutOffset
%                       already incorporate this correction.  See
%                       calibrate.
%               
%     RiseWin: rise window [column array] computed at sub-sample precision.
%              This window is to be applied on the "Rise" portion.
%     FallWin: fall window [column array] computed at sub-sample precision.
%              This window is to be applied on the "Fall" portion.
%
%   OnsetDelay is realized by prepending zero-valued samples, i.e., a
%   simple increment of Nsam.Npre.
%
%   DelayRecipe is a helper function typically called by waveform -generating
%   functions or their helper functions such as ToneStim.
%
%   See also Calibrate, ToneStim.

if ~isfield(Dur, 'OnsetDelay'),
    warning('OnsetDelay needs to be implemented');
    Dur.OnsetDelay = 0;
end

[calibDt, binCompDt] = calibDelay(EXP, Fsam, DAchan);
%=======TIMING, DURATIONS & SAMPLE COUNTS=======
% Stimulus is cut from virtual buffer, then placed in waveform interval.
% First find out where to place the different portions in the waveform.
if isequal('ongoing', ITDtype), ITDpredur = 0; % ITD not realized by preceding zeros in interval; Delay only affects phase
else, ITDpredur = ITDdelay; % ITD is implemented by delaying the start of the waveform to one ear
end
PreDur = binCompDt+ITDpredur; % PreDur = pause preceding the cut waveform 
SteadyDur = Dur.BurstDur-Dur.RiseTime-Dur.FallTime;
PostDur = Dur.ISI -(PreDur + Dur.BurstDur);
% Get sample counts for the different portions making up the total waveform
[Npre Nrise Nsteady Nfall Npost] = NsamplesofChain([PreDur Dur.RiseTime SteadyDur Dur.FallTime PostDur], Fsam/1e3);
Nsam = CollectInStruct(Npre, Nrise, Nsteady, Nfall, Npost);
% convert these sample counts back to rounded durations
[RdPreDur RdRiseTime RdSteadyDur RdFallTime RdPostDur] = dealElements(1e3/Fsam*[Npre Nrise Nsteady Nfall Npost]);
% Now that we know the placement in the waveform interval, we can compute
% where to cut from the virtual waveform buffer. We need sub-sample
% resolution, so we have to take into account any rounding errors.
ExcessLag = (RdPreDur-PreDur); % excess lag due to rounding of PreDur to whole sample counts
% Evaluate CutOffset = offset with which to cut from waveform buffer.
% Note that a cut with CutOffset>0  has a LEAD re a zero-CutOffset cut.
switch ITDtype,
    case 'gating', % cutOffset must completely compensate the displacement in the interval ...
        CutOffset = RdPreDur - binCompDt; % ... except the binCompDt part which corrects interaural calibration asymmetry
    case 'waveform', % ITD is realized by placement; only correct sub-sample rounding errors in placement & binaural comp
        CutOffset = ExcessLag;
    case 'ongoing', % CutOffset is identical to gated offset apart from rounding errors; ITD is realized by cut
        CutOffset = -ITDdelay + ExcessLag;
    otherwise, error(['Invalid ITDtype ''' ITDtype '''.']);
end
dt = 1e3/Fsam; % sample period in ms
% rise Ramp
if Nrise<2,
    RiseWin = ones(Nrise,1);
else,
    TshiftRise = ExcessLag; % mismatch of risetime onset due rounding to integer # samples
    phiRise = linspace(0,pi/2,Nrise+2);
    phiRise = phiRise(2:end-1);
    dphi=diff(phiRise(1:2));
    phiRise = phiRise+dphi*TshiftRise/dt; % correct for rounding of onset time
    RiseWin = sin(phiRise.').^2;
end
% fall Ramp
if Nfall<2,
    FallWin = ones(Nfall,1);
else,
    TshiftFall = ((RdPreDur+RdRiseTime+RdSteadyDur)-(PreDur+Dur.RiseTime+SteadyDur)); % mismatch of falltime onset due rounding to integer # samples
    phiFall = linspace(0,pi/2,Nfall+2);
    phiFall = phiFall(2:end-1);
    dphi=diff(phiFall(1:2));
    phiFall = phiFall+dphi*TshiftFall/dt; % correct for rounding of onset time
    FallWin = cos(phiFall.').^2;
end
% implementation of Onset delay as an aftertought: simply steal samples
% from Post segnet and move them to Pre Segment
NsamOnsetDelay = floor(Dur.OnsetDelay/dt); 
[Nsam.Npre, Nsam.Npost] = deal(Nsam.Npre+NsamOnsetDelay, Nsam.Npost-NsamOnsetDelay);
if Nsam.Npost<0,
    error('Negative # samples in "Post" segment. Check bookkeeping of durations, OnsetDelay, etc.');
end

Timing = CollectInStruct(CutOffset, calibDt, binCompDt);





