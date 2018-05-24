function [timeRes, segLen] = getWinDurationForAGivenRBW(desiredRBW,win,SLA,Fs)
% getWinDurationForAGivenRBW

%   Copyright 2013 The MathWorks, Inc.

% Segment length will depend on ENBW (which in turns depends on segment
% length). Thus, an initial ENBW is obtained using a segment length of
% 1000
ENBW = getENBW(1000, win, SLA);

% Compute segment length
segLen = ceil(ENBW*Fs/desiredRBW);

% Iterate over segment length to minimize
% error between requested RBW and actual RBW:
count = 1;
segLenVect = segLen;
while(count<100) % protect against very long convergence
  new_segLen = ceil(getENBW(ceil(segLen),win,SLA) * Fs/ desiredRBW);
  err = abs(new_segLen - segLen);
  if (err == 0) % we have converged
    segLen = new_segLen;
    timeRes = segLen/Fs;
    break;
  end
  if ~any(segLenVect == new_segLen)
    segLenVect = [ segLenVect new_segLen]; %#ok<AGROW>
    segLen = new_segLen;
    count = count + 1;
  else
    % We hit a previously computed segment length. The sequence
    % will repeat. Break out and select the segment length that
    % minimizes the error
    L = length(segLenVect);
    computed_RBW = zeros(L,1);
    for ind=1:L
      % Get RBW corresponding to segLenVect(ind)
      computed_RBW(ind) = getENBW(segLenVect(ind),win,SLA) * Fs / segLenVect(ind);
    end
    % Select segment length that minimizes absolute error between
    % actual and desired RBW:
    RBWErr = abs(desiredRBW -  computed_RBW);
    [~,ind_min] = min(RBWErr);
    segLen = segLenVect(ind_min);
    timeRes = segLen/Fs;
    break;
  end
end

if count == 100
  error(message('measure:SpectrumAnalyzer:MinTimeResConvergence'));
end
 %------------------------------------------------------------------------  
  function ENBW = getENBW(L, Win, sideLobeAttn)
  % Get window parameters based on a segment legnth L
    
    switch Win
      case 'Rectangular'
        ENBW = 1;
      case 'Hann'
        w = hann(L);
        ENBW = (sum(w.^2)/sum(w)^2)*L;    
      case 'Hamming'
        w = hamming(L);
        ENBW = (sum(w.^2)/sum(w)^2)*L;    
      case 'Flat Top'        
        w = flattopwin(L);
        ENBW = (sum(w.^2)/sum(w)^2)*L; 
      case 'Chebyshev'       
        w = chebwin(L,sideLobeAttn);
        ENBW = (sum(w.^2)/sum(w)^2)*L;
      case 'Kaiser'
        SLA = sideLobeAttn;
        if SLA > 50
          winParam = 0.1102*(SLA-8.7);
        elseif SLA < 21
          winParam = 0;
        else
          winParam = (0.5842*(SLA-21)^0.4) + 0.07886*(SLA-21);
        end
        w = kaiser(L,winParam);
        ENBW = (sum(w.^2)/sum(w)^2)*L;   
    end    
