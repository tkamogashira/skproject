function Out=LinRampMs(In,ms,Fs)
%LinRampMs -- Apply linear rise/fall ramps with specified duration to the input signal
%
%In : Input vector
%ms : Ramp duration (ms)
%Fs : Sampling frequency (Hz)
%
%Usage: Out=LinRampMs(In,ms,Fs)
%By SF, 7/24/01

NPts=ms*1e-3*Fs; % No of points corresponding to the ramp duration
Out=LinRampNPts(In,NPts); %Apply ramp

