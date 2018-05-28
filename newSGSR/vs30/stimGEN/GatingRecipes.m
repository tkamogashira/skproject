function [Rise, Fall] = GatingRecipes(...
   onset, burstDur, riseDur, fallDur, BufSize, SamPeriod);
% GatingRecipes - computes prescription for exact gating windows
% A signal (the waveform source), sampled
% with sample period SamPeriod (in us) is to be gated
% with cos^2 windows. The gated burst has a duration of BurstDur 
% (in ms, including rise/fall durs). It is cut out of the source
% with a delay of Onset ms, where t=0 at the start of the source
% by definition. BufSize is the size of the noise buffer to be gated.
% It is assumed that this buffer contains enough samples for
% the cut to be performed. If BufSize is a single number, the buffer
% is taken to be a ROW vector, and the gating windows are "oriented"
% correspondingly.
% Note: onset must be non-negative

if length(BufSize)==1,
   BufSize = [1, BufSize];
end
NsamBuf = max(BufSize);
isrow = BufSize(1)==1;


% avoid dividing by zero errors
riseDur = max(riseDur,1e-4);
fallDur = max(fallDur,1e-4);

SP = SamPeriod*1e-3; % us->ms

% rise window: starting at sample 1 and ending at onset+riseDur
% starting to rise at onset.
omega = 2*pi*SP/(4*riseDur); % angular frequency of sin^2 in rad/sample
% starting phase of the sin^2 is such that the rise begins at exactly the onset
startPhase = -onset/SP*omega; 
lastPreRiseSample = 1+floor(onset/SP); % samples upto this one preceed the rise window
NsamRiseMI = ceil((onset+riseDur)/SP)-1; % MI is "minus one"
Rise.Window = sin(startPhase+(0:NsamRiseMI)*omega).^2;
% set samples preceding the onset to zero
Rise.Window(1:lastPreRiseSample) = 0;
if ~isrow, Rise.Window = Rise.Window.'; end;
Rise.StartSample = 1; % starting sample in source to be gated with rise window
Rise.EndSample = NsamRiseMI+1; % last sample in source to be gated with rise window
if isequal(0, Rise.Window), Rise.Window = 1; end;

% fall window: starting at onset+burstDur-fallDur and ...
% ... ending at the last sample of the burst
omega = 2*pi*SP/(4*fallDur); % angular frequency of cos^2 in rad/sample
FallStartTime = onset+burstDur-fallDur; % the exact start time of the fall window
% starting phase of the cos^2 is such that the rise begins at exactly at FallTime
startPhase = -FallStartTime/SP*omega; 
firstFallSample = 1+floor(FallStartTime/SP); % first sample of fall window
lastFallSample = NsamBuf; % last sample of fall window
firstPostFallSample = 1+floor((FallStartTime+fallDur)/SP); % from this sample, we're beyond the window
firstPostFallSample = firstPostFallSample-firstFallSample+1; % count from start of window, not burst
Fall.Window = cos(startPhase+(firstFallSample:lastFallSample)*omega).^2;
% set samples fololowing the true window to zero
Fall.Window(firstPostFallSample:end) = 0;
if ~isrow, Fall.Window = Fall.Window.'; end;
Fall.StartSample = firstFallSample;
Fall.EndSample = lastFallSample;
if isequal(0, Fall.Window), Rise.Window = 1; end;







