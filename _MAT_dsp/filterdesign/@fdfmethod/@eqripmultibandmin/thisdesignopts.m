function s = thisdesignopts(this, s, N)
%THISDESIGNOPTS

%   Copyright 2011 The MathWorks, Inc.

if nargin < 3
  % Called by info method - remove BiForcedFrequencyPoints from the info if
  % no point has been specified.
  NBands = this.privNBands;  
else
  NBands = N;
end

for k = NBands+1:10
  str = [sprintf('B%d',k),'Weights'];
  s = rmfield(s, str);
end


% [EOF]
