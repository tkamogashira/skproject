function s = plotlpcdata(s, sigA, sigwin)
%PLOTLPCDATA - Plot data in dspLinearPredictiveCoder demo.

%   Copyright 2006-2010 The MathWorks, Inc.

% Compute the signal and LPC spectrum  
f = fft(sigA,s.fftLen);
fdb1 = -20*log10(abs(f(1:s.fftLen/2)));

f = fft(sigwin,s.fftLen);
fdb2 = 20+(20*log10(abs(f(1:s.fftLen/2))));

% Update plots - Scrolls data to the left in frame-size chunks
s.hlineplot(1).YData{1} = fdb2;
s.hlineplot(1).YData{2} = fdb1;
step(s.hscope);

% Update the time vector
s.time = s.time + s.frameSize/s.Fs*1e3;   
% [EOF]
