function c = getconstraints(~, hs)
%GETCONSTRAINTS Returns the constraints for the design

%   Copyright 2011 The MathWorks, Inc.

% Get the required attenuation considering the largest magnitude of the
% differentiator
peakMagdB = 20*log10(hs.Fpass*pi);
newAttenuationdB = abs(peakMagdB - hs.Astop);
rStop = convertmagunits(newAttenuationdB,'db','linear','stop');

% If necessary, add a correction to the computed stopband attenuation so
% that the specifications are met. In general, the required corrections are
% small.
N = 4096;
isDone = false;
count = 0;
rStopNew = rStop;
maxIters = 50;
lastwarn('');

% Do not display warnings about numerical accuracy or convergence
% issues.
wState = warning('off'); %#ok<WNOFF>

while ~isDone
  count = count + 1;
  if count == 2
  end  
  args = {hs.FilterOrder, [0 hs.Fpass hs.Fstop 1], [0 hs.Fpass*pi 0 0],...
    [1 rStopNew],{'w','c'},'differentiator'};
  
  b = fircband(args{:});  
  
  % Check if a warning has been issued. If so, then stop the iterations
  % and use the original specifications, or those obtained in the
  % previous iteration.
  [~, lastId] = lastwarn;
  
  hact = 20*log10(abs(freqz(b,1,linspace(0,hs.Fpass*pi,N))));
  maxPassbandMag = max(hact);
  hact = 20*log10(abs(freqz(b,1,linspace(hs.Fstop*pi,pi,N))));
  maxStopbandMag = max(hact);
  
  if (maxPassbandMag-maxStopbandMag)<hs.Astop && (count < maxIters) && isempty(lastId)
    rStopNew = rStopNew*.999;
  else
    isDone = true;
    % If we are leaving because of a warning then use original specification
    % or previous specification.
    if ~isempty(lastId) && count > 1
      rStopNew = rStopNew/.999;
    end
  end  
end

if count > maxIters
  % Use the original constraint value if the design did not converge. 
  rStopNew = rStop;
end

% Return final constraints
c{1} = [1 rStopNew];
c{2} = {'w','c'};

warning(wState);
