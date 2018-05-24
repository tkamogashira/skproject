function s = reorderdesignoptsstruct(~,s,hspecs)
%REORDERDESIGNOPTSSTRUCT

%   Copyright 2011 The MathWorks, Inc.

% Reorder structure so that MinPhase and MaxPhase appear together and
% before the Weights and UniformGrid options.

% Do not re-order if called by the info method.
if nargin > 2
  
  stemp = reorderstructure(s, 'FilterStructure', 'DensityFactor', 'MinPhase',...
    'MaxPhase');
  
  % Interlace BiWeights and BiForcedFrequencyPoints options
  nBands = hspecs.NBands;
  
  for k = 1:nBands
    weightStr = [sprintf('B%d',k),'Weights'];
    forcedFStr = [sprintf('B%d',k),'ForcedFrequencyPoints'];
    if isfield(s,weightStr)
      stemp = rmfield(stemp, weightStr);
    end
    stemp = rmfield(stemp, forcedFStr);
  end
  
  for k = 1:nBands
    weightStr = [sprintf('B%d',k),'Weights'];
    forcedFStr = [sprintf('B%d',k),'ForcedFrequencyPoints'];
    if isfield(s,weightStr)
      stemp.(weightStr) = s.(weightStr);
    end
    stemp.(forcedFStr) = s.(forcedFStr);
  end
  
  s = stemp;
end



% [EOF]