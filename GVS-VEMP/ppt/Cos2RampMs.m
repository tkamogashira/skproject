function Out=LinRampMs(In,ms,Fs)
%Cos2RampMs -- Apply raised-cosine rise/fall ramps with specified duration to the input signal
%
%In : Input vector
%ms : Ramp duration (ms)
%Fs : Sampling frequency (Hz)
%
%Usage: Out=Cos2RampMs(In,ms,Fs)
%By SF, 7/24/01

NPts=ceil(ms*1e-3*Fs); % No of points corresponding to the ramp duration
Out=Cos2RampNPts(In,NPts); %Apply ramp

