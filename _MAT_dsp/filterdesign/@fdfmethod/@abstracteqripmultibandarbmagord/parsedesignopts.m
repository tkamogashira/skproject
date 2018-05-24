function [lgrid,phaseStr,N,W,Wcell,constraints] = parsedesignopts(this,hspecs,Fs,realDesignFlag)
%PARSEDESIGNOPTS Parse design options

%   Copyright 2011 The MathWorks, Inc.

N = hspecs.FilterOrder;
NBands = hspecs.NBands;

if Fs == 1
  FsNormFactor = 1;
else
  FsNormFactor = Fs/2;
end

% Density factor
lgrid = this.Densityfactor;
if lgrid<16,
  error(message('dsp:fdfmethod:abstracteqripmultibandarbmagord:parsedesignopts:InvaliddensityFactor'));
end

% Min/Max phase
phaseStr = [];
if this.MinPhase
  phaseStr = 'minphase';
end
if this.MaxPhase
  if ~isempty(phaseStr)
    error(message('dsp:fdfmethod:abstracteqripmultibandarbmagord:parsedesignopts:InvalidPhaseOpt'));
  end
  phaseStr = 'maxphase';
end

if ~isempty(phaseStr) && ~realDesignFlag
  warning(message('dsp:fdfmethod:abstracteqripmultibandarbmagord:parsedesignopts:InvalidComplexMinMaxPhase'));
end


% Order must be greater or equal to 3.
if N < 3
  N = 3;
end

if ~isempty(phaseStr) && (rem(N,2)~=0)
  % Increase order by one when order is odd for min/max-phase designs.
  N = N+1;
end

% Weights and forced frequency points
[W,Wcell,constraints] = parseweights(this,hspecs);
forcedF = [];
for idx = 1:NBands
  strF = [sprintf('B%d', idx),'Frequencies'];
  strForcedFreqPts = [sprintf('B%d', idx),'ForcedFrequencyPoints'];
  
  F = hspecs.(strF); % vector of frequencies for the idx-th band
  forcedFTemp = this.(strForcedFreqPts)/FsNormFactor;
  
  % Check validity of forced frequency points - must be members of the
  % specified frequencies, must be specified in increasing order, must be
  % unique.
  if ~isempty(forcedFTemp)
    if ~realDesignFlag
      warning(message('dsp:fdfmethod:abstracteqripmultibandarbmagord:parsedesignopts:InvalidForcedPointsComplexDesign'));
    else
      if ~all(ismember(forcedFTemp,F))
        error(message('dsp:fdfmethod:abstracteqripmultibandarbmagord:parsedesignopts:InvalidForcedPoints'));
      end
      
      if any(diff(forcedFTemp)<=0)
        error(message('dsp:fdfmethod:abstracteqripmultibandarbmagord:parsedesignopts:InvalidForcedPointsOrder'));
      end
      
      if length(forcedFTemp) == length(F)
        error(message('dsp:fdfmethod:abstracteqripmultibandarbmagord:parsedesignopts:InvalidForcedPointsLength'));
      end
    end
  end
  
  forcedF = [forcedF forcedFTemp]; %#ok<*AGROW>
  
end

% Check if same frequency points have been forced across different bands.
if length(unique(forcedF)) ~= length(forcedF) && realDesignFlag
  error(message('dsp:fdfmethod:abstracteqripmultibandarbmagord:parsedesignopts:InvalidForcedPointsOrder'));
end

if ~isempty(forcedF) && realDesignFlag
  this.privForcedFreqPoints = true;
else
  this.privForcedFreqPoints = false;
end


