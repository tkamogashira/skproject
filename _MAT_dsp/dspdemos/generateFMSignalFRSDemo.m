function [xFM,integralState] = generateFMSignalFRSDemo(HLP, ...
    frameLength,deltaF,Fs,integralState)
%generateFMSignalFRSDemo Function to generate FM signal for dspFRS demo

%   Copyright 2010-2011 The MathWorks, Inc.

x = filter(HLP,randn(frameLength,1));
x = x/max(abs(x));
x(1) = x(1) + integralState;
integral = cumsum(x);
integralState = integral(end);
xFM = cos(2*pi*deltaF*integral/Fs);
