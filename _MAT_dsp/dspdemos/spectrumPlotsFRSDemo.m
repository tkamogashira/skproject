function spectrumPlotsFRSDemo(xFMBaseBandBuffer,xUp,xDown,interpFactor)
%spectrumPlotsFRSDemo Generates spectrum plots for the dspFRS demo

%   Copyright 2010-2012 The MathWorks, Inc.

Fs = 50e3;
[P1, F1] = pwelch(xFMBaseBandBuffer, hann(64), 0, [], Fs,'centered');
[P2, F2] = pwelch(xDown, hann(64), 0, [], Fs,'centered');
[P3, F3] = pwelch(xUp, hann(length(xUp)/10), 0, [], ...
                  Fs*interpFactor,'centered');
figure
plot(F1*1e-3,10*log10(P1))
hold on
plot(F2*1e-3,10*log10(P2),'r')
grid on
xlabel('Frequency (KHz)')
ylabel('Power/frequency (dB/Hz)')
legend('Baseband signal', 'Down converted signal',3)

figure
plot(F3*1e-3,10*log10(P3))
grid on
xlabel('Frequency (KHz)')
ylabel('Power/frequency (dB/Hz)')
legend('Up converted signal',3)
ax = axis;
axis([420 490 ax(3) ax(4)])
