function s = reorderdesignoptsstruct(~,s,N)
%REORDERDESIGNOPTSSTRUCT

%   Copyright 2011 The MathWorks, Inc.

% Do not re-order if called by the info method.
if nargin > 2
  % Reorder structure so that MinPhase and MaxPhase appear together and
  % before the Weights and UniformGrid options.
  stemp = reorderstructure(s, 'FilterStructure', 'DensityFactor', 'MinPhase',...
    'MaxPhase');
  
  % Interlace BiWeights and BiForcedFrequencyPoints options
  nBands = N;
  
  for k = 1:nBands
    str = [sprintf('B%d',k),'Weights'];
    str1 = [sprintf('B%d',k),'ForcedFrequencyPoints'];
    stemp = rmfield(stemp, str);
    stemp = rmfield(stemp, str1);
  end
  stemp = rmfield(stemp,'UniformGrid');
  
  
  for k = 1:nBands
    str = [sprintf('B%d',k),'Weights'];
    str1 = [sprintf('B%d',k),'ForcedFrequencyPoints'];
    stemp.(str) = s.(str);
    stemp.(str1) = s.(str1);
  end
  
  stemp.UniformGrid = s.UniformGrid;
  
  s = stemp;
end


% [EOF]