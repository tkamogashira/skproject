function [lgrid,phaseStr, minOrderStr, N] = parsedesignopts(this)
%PARSEDESIGNOPTS Parse design options

%   Copyright 2011 The MathWorks, Inc.

% Density factor
lgrid = this.Densityfactor;
if lgrid<16,
  error(message('dsp:fdfmethod:abstracteqriparbmagmin:parsedesignopts:InvaliddensityFactor'));
end

% Min/Max phase
phaseStr = [];
if this.MinPhase
  phaseStr = 'minphase';
end
if this.MaxPhase
  if ~isempty(phaseStr)
    error(message('dsp:fdfmethod:abstracteqriparbmagmin:parsedesignopts:InvalidPhaseOpt'));
  end
  phaseStr = 'maxphase';
end

% Order
if this.InitOrder < 3
  N = 3;
else
  N = this.InitOrder;
end

switch this.MinOrder
  case 'any'
    minOrderStr = 'minorder';
    if ~isempty(phaseStr) && (rem(N,2)~=0)
      % Decrease initial order by one when order is odd for min/max-phase
      % designs
      N = max(4,N-1);
    end
    
  case 'odd'
    minOrderStr = 'minodd';
    if ~isempty(phaseStr)
      error(message('dsp:fdfmethod:abstracteqriparbmagmin:parsedesignopts:InvalidOddOrder'));
    end
    if rem(N,2)==0
      % Decrease initial order by one if initial order is even
      N = N-1;
    end
    
  case 'even'
    minOrderStr = 'mineven';
    if rem(N,2)~=0
      % Decrease initial order by one if initial order is odd
      N = max(4,N-1);
    end
end
