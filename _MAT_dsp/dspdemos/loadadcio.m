function [y, ys, Fs] = loadadcio
%LOADADCIO Load ADC's input and output signals for IF Subsampling demo

%   Copyright 2007 The MathWorks, Inc.

load audio48.mat;
z = signal48kHz(1:Fs48*2); % 2 secs

% Resample to 20Khz
Hm = mfilt.firsrc(5,12);
s20 = filter(Hm,z);
s20 = s20(13:end);

% Upsample to 1.2 Mhz
Hm1 = mfilt.firinterp(60);
sr = filter(Hm1,s20);
sr = sr(721:end);

Fc = 450e3;
Fs = 1.2e6;
Fsd = 1.2e5;
y = hilbert(modulate(sr,Fc,Fs,'am')); 
ys = downsample(y,Fs/Fsd);

% [EOF]
