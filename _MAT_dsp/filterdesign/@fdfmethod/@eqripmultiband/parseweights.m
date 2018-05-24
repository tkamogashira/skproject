function [W,Wcell,constraints] = parseweights(this,hspecs)
%PARSEWEIGHTS Parse weights

%   Copyright 2011 The MathWorks, Inc.

NBands = hspecs.NBands;

W = [];
Wcell = {};

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
      error(message('dsp:fdfmethod:eqripmultiband:parseweights:InvalidWeights'))
    end
  end
  W = [W WTemp];   %#ok<*AGROW>
  Wcell{idx} = WTemp;
end

% There are no constrained bands so set all the elements of the constraints
% cell to 'w' ('w' means treat band weight value as a weight not as
% ripple). This is used in the firgr function.
constraints = repmat({'w'},1,NBands);
