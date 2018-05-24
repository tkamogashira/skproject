function s = plotDDCDesignDemo(s,x, y)
%plotDDCDesignDemo Helper function to plot spectrum of signals for
%dspDigitalDownConverterDesign demo

%   Copyright 2010 The MathWorks, Inc.

persistent inputSignal outputSignal;
if (s.cnt == 0)     
    inputSignal = [];
    outputSignal = [];
end
s.cnt = s.cnt+1;
inputSignal = [inputSignal;double(x)];
outputSignal = [outputSignal;double(y)];
if ~mod(s.cnt,64)
    figure(s.hfig1);
    [Pxx, Fin] = periodogram(inputSignal, [], [], s.fs);
    plot(Fin*1e-6, 10*log10(1000*Pxx));
    xlabel('Frequency (MHz)')
    ylabel('Power (dB)')
    title('Mean-Square Spectrum Estimate: Input signal')
    grid on
    inputSignal = []; 
end
if ~mod(s.cnt,64)
    figure(s.hfig2);
    [Pyy, Fout] = periodogram(outputSignal,hann(length(outputSignal)), ...
        [], s.fs1);
    plot(Fout*1e-3, 10*log10(1000*Pyy));
    xlabel('Frequency (kHz)')
    ylabel('Power (dB)')
    title('Mean-Square Spectrum Estimate: Down converted signal') 
    grid on
    axis([0,270.383, -160, 0]);
    outputSignal = []; 
end

% [EOF]
end

