%% Acoustic Echo Cancellation (AEC) 
% This example shows how to apply adaptive filters to acoustic echo
% cancellation (AEC).
% 
% Author(s): Scott C. Douglas
% Copyright 1999-2014 The MathWorks, Inc.

%% Introduction
% Acoustic echo cancellation is important for audio teleconferencing when
% simultaneous communication (or full-duplex transmission) of speech is
% necessary.  In acoustic echo cancellation, a measured microphone signal
% d(n) contains two  signals:
%       - the near-end speech signal v(n)
%       - the far-end echoed speech signal dhat(n)
% The goal is to remove the far-end echoed speech signal from the 
% microphone signal so that only the near-end speech signal is 
% transmitted.  This example has some sound clips, so you might want to
% adjust your computer's volume now.

%% The Room Impulse Response
%
% First, we describe the acoustics of the loudspeaker-to-microphone signal
% path where the speakerphone is located.  We can use a long finite impulse
% response filter to describe these characteristics. The following sequence
% of commands generates a random impulse response that  is not unlike what
% a conference room would exhibit assuming a system sampling rate of fs =
% 16000 Hz.

fs = 16000;
M = fs/2 + 1; 
FrameSize = 8192;

[B,A] = cheby2(4,20,[0.1 0.7]);

Hd1 = dsp.IIRFilter('Numerator', [zeros(1,6) B], 'Denominator', A);
hFVT = fvtool(Hd1);  % Analyze the filter
set(hFVT, 'Color', [1 1 1])

%%
H = step(Hd1, ...
         (log(0.99*rand(1,M)+0.01).*sign(randn(1,M)).*exp(-0.002*(1:M)))');
H = H/norm(H)*4;    % Room Impulse Response

plot(0:1/fs:0.5, H);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Room Impulse Response');
set(gcf, 'Color', [1 1 1])

Hd2 = dsp.FIRFilter('Numerator', H');

%% The Near-End Speech Signal
%
% The teleconferencing system's user is typically located near the 
% system's microphone.  Here is what a male speech sounds like at the 
% microphone.

load nearspeech
waudiod = warning('off','dsp:system:toAudioDeviceDroppedSamples');

hsr1  = dsp.SignalSource('Signal', v, 'SamplesPerFrame', FrameSize);
Hap   = dsp.AudioPlayer('SampleRate', fs);
Hts1  = dsp.TimeScope('SampleRate', fs, ...
                      'TimeSpan', 35, ...
                      'YLimits', [-1.5 1.5], ...
                      'BufferLength', length(v), ...
                      'Title', 'Near-End Speech Signal', ...
                      'ShowGrid', true);

% Streaming loop
while(~isDone(hsr1))
    % Extract the speech samples from the input signal
    ne_speech = step(hsr1); 
    % Send the speech samples to the output audio device
    step(Hap, ne_speech);
    % Plot the signal
    step(Hts1, ne_speech);   
end

%% The Far-End Speech Signal
%
% Now we describe the path of the far-end speech signal.  A male voice
% travels out the loudspeaker, bounces around in the room, and then
% is picked up by the system's microphone.  Let's listen to what
% his speech sounds like if it is picked up at the microphone without
% the near-end speech present.

load farspeech

hsr2  = dsp.SignalSource('Signal', x, 'SamplesPerFrame', FrameSize);
hlog2 = dsp.SignalSink;                   
Hts2  = dsp.TimeScope('SampleRate', fs, ...
                      'TimeSpan', 35, ...
                      'YLimits', [-0.5 0.5], ...
                      'BufferLength', length(x), ...
                      'Title', 'Far-End Speech Signal', ...
                      'ShowGrid', true);

% Streaming loop
while(~isDone(hsr2))
    % Extract the speech samples from the input signal
    fe_speech = step(hsr2); 
    % Add the room effect to the far-end speech signal
    dhat = step(Hd2, fe_speech);
    % Send the speech samples to the output audio device
    step(Hap, dhat);
    % Plot the signal
    step(Hts2, fe_speech);   
    % Log the signal for further processing
    step(hlog2, dhat);    
end

%% The Microphone Signal
%
% The signal at the microphone contains both the near-end speech
% and the far-end speech that has been echoed throughout the room.
% The goal of the acoustic echo canceler is to cancel out the 
% far-end speech, such that only the near-end speech is transmitted
% back to the far-end listener.

reset(hsr1);
hsr3  = dsp.SignalSource('Signal', hlog2.Buffer, ...
                         'SamplesPerFrame', FrameSize);
hlog3 = dsp.SignalSink;                       
Hts3  = dsp.TimeScope('SampleRate', fs,...
                      'TimeSpan', 35,...
                      'YLimits', [-1 1],...
                      'BufferLength', length(x),...
                      'Title', 'Microphone Signal',...
                      'ShowGrid', true);                    

% Streaming loop
while(~isDone(hsr3))
    % Microphone signal = echoed far-end + near-end
    d = step(hsr3) + step(hsr1) + 0.001*randn(8192,1); 
    % Send the speech samples to the output audio device
    step(Hap, d);
    % Plot the signal
    step(Hts3, d);    
    % Log the signal
    step(hlog3, d);      
end

%% The Frequency-Domain Adaptive Filter (FDAF)
%
% The algorithm that we will use in this example is the
% Frequency-Domain Adaptive Filter (FDAF).  This algorithm is very  useful
% when the impulse response of the system to be identified  is long. The
% FDAF uses a fast convolution technique to compute the output signal and
% filter updates. This computation executes quickly in MATLAB(R).  It also
% has improved convergence performance through frequency-bin step size
% normalization. We'll pick some initial parameters for the filter and see
% how well the far-end speech is cancelled in the error signal.

mu = 0.025;
del = 0.01;
lam = 0.98;

% Construct the Frequency-Domain Adaptive Filter
Hfdaf = dsp.FrequencyDomainAdaptiveFilter('Length', 2048, ...
                                          'StepSize', mu, ...
                                          'InitialPower', del, ...
                                          'AveragingFactor', lam, ...
                                          'Method','Unconstrained FDAF');

Hts4 = dsp.TimeScope(4, fs, ...
              'LayoutDimensions', [4,1], ...
              'TimeSpan', 35, ...
              'BufferLength', length(x));
          
Hts4.ActiveDisplay = 1;
Hts4.ShowGrid = true;
Hts4.YLimits = [-1.5 1.5];
Hts4.Title = 'Near-End Speech Signal';
               
Hts4.ActiveDisplay = 2;
Hts4.ShowGrid = true;
Hts4.YLimits = [-1.5 1.5];
Hts4.Title = 'Microphone Signal';

Hts4.ActiveDisplay = 3;
Hts4.ShowGrid = true;
Hts4.YLimits = [-1.5 1.5];
Hts4.Title = 'Output of Acoustic Echo Canceller mu=0.025';

Hts4.ActiveDisplay = 4;
Hts4.ShowGrid = true;
Hts4.YLimits = [0 50];
Hts4.YLabel = 'ERLE [dB]';
Hts4.Title = 'Echo Return Loss Enhancement mu=0.025';

hsr4 = dsp.SignalSource('Signal', hlog3.Buffer, ...
                        'SamplesPerFrame', FrameSize); 
% Near-end speech signal
release(hsr1);
hsr1.SamplesPerFrame = FrameSize;

% Far-end speech signal
release(hsr2);
hsr2.SamplesPerFrame = FrameSize;

% Far-end speech signal echoed by the room
release(hsr3);
hsr3.SamplesPerFrame = FrameSize;
                   
%% Echo Return Loss Enhancement (ERLE)
%
% Since we have access to both the near-end and far-end speech
% signals, we can compute the echo return loss enhancement
% (ERLE), which is a smoothed measure of the amount (in dB) 
% that the echo has been attenuated.  From the plot, we see 
% that we have achieved about a 35 dB ERLE at the end of the 
% convergence period.

Hd3 = dsp.FIRFilter('Numerator', ones(1,1024));
Hd4 = clone(Hd3);
setfilter(hFVT,Hd3); 

% Streaming loop with mu = 0.025
while(~isDone(hsr1))                 
    
    vsr = step(hsr1);
    xsr = step(hsr2);    
    dhatsr = step(hsr3);
    dsr = step(hsr4);
    % Apply FDAF
    [y,e] = step(Hfdaf, xsr, dsr);
    % Send the speech samples to the output audio device
    step(Hap, e);
    % Compute ERLE
    erle = step(Hd3,(e-vsr).^2)./(step(Hd4, dhatsr.^2));
    erledB = -10*log10(erle);
    % Plot near-end, far-end, microphone, AEC output and ERLE
    step(Hts4, vsr, dsr, e, erledB);   
end

%% Effects of Different Step Size Values
%
% To get faster convergence, we can try using a larger step  size value.
% However, this increase causes another effect, that is,  the adaptive
% filter is "mis-adjusted" while the near-end speaker is talking.  Listen
% to what happens when we choose a step size that is 60\% larger than
% before

newmu = 0.04;

% Change the step size value in FDAF
reset(Hfdaf);
Hfdaf.StepSize = newmu;

Hts4b = clone(Hts4);
Hts4b.ActiveDisplay = 3;
Hts4b.Title = 'Output of Acoustic Echo Canceller mu=0.04';
Hts4b.ActiveDisplay = 4;
Hts4b.Title = 'Echo Return Loss Enhancement mu=0.04';

reset(hsr1);
reset(hsr2);
reset(hsr3);
reset(hsr4);
reset(Hd3);
reset(Hd4);

% Streaming loop with newmu = 0.04
while(~isDone(hsr1))                 
    
    vsr = step(hsr1);
    xsr = step(hsr2);
    dhatsr = step(hsr3);
    dsr = step(hsr4);
    % Apply FDAF
    [y,e] = step(Hfdaf, xsr, dsr);
    % Send the speech samples to the output audio device
    step(Hap, e);
    % Compute ERLE
    erle = step(Hd3,(e-vsr).^2)./(step(Hd4, dhatsr.^2));
    erledB = -10*log10(erle);
    % Plot near-end, far-end, microphone, AEC output and ERLE
    step(Hts4b, vsr, dsr, e, erledB);     
end

%% Echo Return Loss Enhancement Comparison
%
% With a larger step size, the ERLE performance is not as good
% due to the misadjustment introduced by the near-end speech.
% To deal with this performance difficulty, acoustic echo cancellers 
% include a detection scheme to tell when near-end speech is
% present and lower the step size value over these periods.  Without
% such detection schemes, the performance of the system with the
% larger step size is not as good as the former, as can be seen from 
% the ERLE plots.

warning(waudiod);
displayEndOfDemoMessage(mfilename)
