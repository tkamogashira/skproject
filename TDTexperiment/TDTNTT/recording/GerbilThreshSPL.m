function ThreshSPL=GerbilThreshSPL(Freq)
%GerbilThreshSPL -- Gerbil's threshold SPL for given freq.
%
%Usage : ThreshSPL=GerbilThreshSPL(Freq)
%Freq : (scalar or matrix) Frequency (Hz)
%ThreshSPL : Threshold SPL (dB), corresponding to Freq
%
%Threshold SPL is computed by linearly interpolating Table I in Ryan
%(1976).
%
%By SF, 3/5/03

%Table I by Ryan (1976)
x=[0.01 0.1 0.3 0.5 1.0 2.0 4.0 8.0 16.0 32.0 40.0 50.0 60.0 100.0]*1000; %Freq
y=[42.15 42.15 28.97 19.33 6.19 3.43 2.68 5.37 5.31 16.51 21.95 40.05 65.76 65.76]; %Thresh

%Linear interpolation
%Frequency is regarded linear on the log scale
ThreshSPL=interp1(log10(x),y,log10(Freq));

