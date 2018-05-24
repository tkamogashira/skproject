function plotlmsadtedata(s, w)
%PLOTLMSADTEDATA  Plot data in dspLMSTimeDelayEstimator demo.

%   Copyright 2007-2010 The MathWorks, Inc.


[M, Idx] = max(w(2:end));
maxw = NaN(size(w));
maxw(Idx+1) = M;

s.hlineplot(1).YData{1} = w;
s.hlineplot(1).YData{2} = maxw;

step(s.hscope);


