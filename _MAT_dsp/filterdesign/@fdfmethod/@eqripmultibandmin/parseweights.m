function Wcell = parseweights(this,hspecs)
%PARSEWEIGHTS Parse weights

%   Copyright 2011 The MathWorks, Inc.

NBands = hspecs.NBands;

Wcell = cell(NBands,1);
for idx = 1:NBands
  strW = [sprintf('B%d',idx),'Weights'];
  strF = [sprintf('B%d', idx),'Frequencies'];
  
  F = hspecs.(strF); % vector of frequencies for the idx-th band
  
  WTemp = this.(strW);
  if isempty(WTemp)
    WTemp = ones(size(F));
  elseif isscalar(WTemp)
    WTemp = WTemp*ones(size(F));
  else
    if length(F) ~= length(WTemp)
      error(message('dsp:fdfmethod:eqripmultibandmin:parseweights:InvalidWeights'))
    end
  end
  Wcell{idx} = WTemp;
end
