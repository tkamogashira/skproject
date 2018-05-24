function c = getconstraints(~, hs)
%GETCONSTRAINTS Returns the constraints for the design

%   Copyright 2011 The MathWorks, Inc.

% Constrained differentiator designs do not work well when the constrained
% band is the passband. To achieve the correct design, we weight the
% passband.
rPass = convertmagunits(hs.Apass,'db','linear','pass');
wpass = hs.Fpass*pi;
N = 4096;
htheo = linspace(0,wpass,N);
hUpper = db(htheo(2:end))+hs.Apass/2;
hLower = db(htheo(2:end))-hs.Apass/2;

% Check if the initial design has a ripple that is too small or too large
% when compared to the specification.
args = {hs.FilterOrder, [0 hs.Fpass hs.Fstop 1], [0 wpass 0 0],...
  [1/rPass 1],{'w','w'},'differentiator'};
b = fircband(args{:});
hact = freqz(b,1,linspace(0, wpass, N));
measured_apass = ...
  max(db(htheo(2:end))-db(hact(2:end)))-min(db(htheo(2:end))-db(hact(2:end)));

rPassNew = rPass;
rPassPrev = rPass;
isDone = false;
count = 0;
rippleStep = 2;
maxIters = 200;
lastwarn('');
wState = [];

if (measured_apass < hs.Apass)
  % Do not display warnings about numerical accuracy or convergence issues.
  wState = warning('off'); %#ok<WNOFF>
    
  % The ripple can be relaxed, by increasing the weight value, since it is
  % smaller than what was specified.
  while ~isDone
    count = count + 1;    
    rPassPrev = rPassNew;
    rPassNew = rPassPrev*rippleStep;
    
    args = {hs.FilterOrder, [0 hs.Fpass hs.Fstop 1], [0 wpass 0 0],...
      [1/rPassNew 1],{'w','w'},'differentiator'};
    
    b = fircband(args{:});  
    
    % Check if a warning has been issued. If so, then stop the iterations
    % and use the original specifications, or those obtained in the
    % previous iteration.
    [~, lastId] = lastwarn;
   
    hact = 20*log10(abs(freqz(b,1,htheo(2:end))));
    
    if any(hact > hUpper) || any(hact < hLower) || count > maxIters || ~isempty(lastId)
      isDone = true;
    end
  end
elseif (measured_apass > hs.Apass)
  % The ripple is too large. We need to reduce the weight value. 

  % Do not display warnings about numerical accuracy or convergence issues.
  wState = warning('off'); %#ok<WNOFF>
  
  while ~isDone
    count = count + 1;    
    
    rPassPrev = rPassNew;
    rPassNew = rPassPrev/rippleStep;
        
    args = {hs.FilterOrder, [0 hs.Fpass hs.Fstop 1], [0 wpass 0 0],...
      [1/rPassNew 1],{'w','w'},'differentiator'};
    
    b = fircband(args{:});
    
    % Check if a warning has been issued. If so, then stop the iterations
    % and use the original specifications, or those obtained in the
    % previous iteration.
    [~, lastId] = lastwarn;
    
    hact = 20*log10(abs(freqz(b,1,htheo(2:end))));
        
    if (all(hact <= hUpper) && all(hact >= hLower)) || count > maxIters || ~isempty(lastId)
      isDone = true;
      if  isempty(lastId)
        % If we are done because of a warning then we want to use the
        % previous constraint value and not the one that caused the
        % warning. Otherwise, we want to use the constraint value that made
        % the design meet the passband ripple specification.
        rPassPrev = rPassNew;
      end
    end
  end
end

if count > maxIters
  % Use the original weight value if the design did not converge. 
  rPassPrev = rPass;
end

% Return final constraints
c{1} = [1/rPassPrev 1];
c{2} = {'w','w'};

if ~isempty(wState)
  warning(wState);
end
