function s = plotstatsdata(s, minval, maxval, sig, meanval, fftoutput)
%PLOTSTATSDATA  Plot data from dspStats demo.

%   Copyright 2006-2010 The MathWorks, Inc.


% Update only every other frame
if mod(s.framenumber,2) || s.framenumber == 0
  s.hlineplot(1).YData{1} = [minval(end) minval(end)];
  s.hlineplot(1).YData{2} = sig;
  s.hlineplot(1).YData{3} = [maxval(end) maxval(end)];
  s.hlineplot(2).XData{1} = s.framenumber;
  s.hlineplot(2).YData{1} = meanval(end);  
  s.hlineplot(3).YData{1} = 20*log(abs(fftoutput));
end

step(s.hscope);
s.framenumber = s.framenumber+1;

