function s = thisdesignopts(this, s,hspecs)
%THISDESIGNOPTS   

%   Copyright 2011 The MathWorks, Inc.

removeWeigthIndex = [false false false];

if nargin < 3
  % Called by info method - remove weights if necessary  
  if ~isempty(this.privConstrainedBands)
    if sum(this.privConstrainedBands) == 2
      removeWeigthIndex = ~removeWeigthIndex;
    else
      removeWeigthIndex = logical(this.privConstrainedBands);
    end
  end
else 
  constraintFlagVector = ...
    [hspecs.Stopband1Constrained hspecs.PassbandConstrained hspecs.Stopband2Constrained];

  if sum(constraintFlagVector) > 1
    % No weights if more than one band has been constrained
    removeWeigthIndex = ~removeWeigthIndex;
  else
    % No weight for a constrained band. 
    removeWeigthIndex = constraintFlagVector;
  end
end

if removeWeigthIndex(1)
  s = rmfield(s, 'Wstop1');
end

if removeWeigthIndex(2)
  s = rmfield(s, 'Wpass');
end

if removeWeigthIndex(3)
  s = rmfield(s, 'Wstop2');
end


% [EOF]
