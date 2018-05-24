function plotlmsadeqdata(s, w)
%PLOTLMSADEQDATA  Plot data in dspLMSEqualizer demo.

%   Copyright 2006-2010 The MathWorks, Inc.

s.hlineplot(1).YData{1} = w;
step(s.hscope);


