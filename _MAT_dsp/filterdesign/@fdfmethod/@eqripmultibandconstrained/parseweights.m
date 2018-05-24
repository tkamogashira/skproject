function [W,Wcell,constraints] = parseweights(this,hspecs)
%PARSEWEIGHTS Parse weights

%   Copyright 2011 The MathWorks, Inc.

NBands = hspecs.NBands;

W = [];
Wcell = cell(1,NBands);
constraints = cell(1,NBands);
constrainedBandsCount = 0;
for idx = 1:NBands
  strW = [sprintf('B%d',idx),'Weights'];
  strF = [sprintf('B%d', idx),'Frequencies'];
  
  F = hspecs.(strF); % vector of frequencies for the idx-th band
  
  if hspecs.([sprintf('B%d',idx),'Constrained'])
    Wcell{idx} = hspecs.([sprintf('B%d',idx),'Ripple']);
    constrainedBandsCount = constrainedBandsCount + 1;
    % In firgr 'c' means treat value in Wcell{idx} as the ripple for the
    % constrained band.
    constraints{idx} = 'c';
  else
    WTemp = this.(strW);
    if isempty(WTemp)
      WTemp = ones(size(F));
    elseif isscalar(WTemp)
      WTemp = WTemp*ones(size(F));
    else
      if length(F) ~= length(WTemp)
        error(message('dsp:fdfmethod:eqripmultibandconstrained:parseweights:InvalidWeightsLength'))
      end
    end
    Wcell{idx} = WTemp;
    % In firgr 'w' means treat values in Wcell{idx} as weights
    constraints{idx} = 'w';
  end
end

if constrainedBandsCount == NBands
  error(message('dsp:fdfmethod:eqripmultibandconstrained:parseweights:InvalidAllBandsConstrained'))
end
