function l=MaxNumToneLevel;

% MaxNumLevel - returns maximum value in dB re RMS=1
% that can be achieved by full output & open attenuators
% using tones

% srqt(1/2) is RMS of unity-ampl sinusoid
l = 20*log10(MaxMagDA/2^0.5); 
