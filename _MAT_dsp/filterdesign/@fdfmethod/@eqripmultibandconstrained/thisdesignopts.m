function s = thisdesignopts(this, s, hspecs)
%THISDESIGNOPTS

%   Copyright 2011 The MathWorks, Inc.

if nargin < 3,
  % Called by info method.
  NBands = this.privNBands;
  constraintVect = this.privConstrainedBands;
  for idx = 1:NBands
    % remove BiForcedFrequencyPoints from the info if no point has been
    % specified.
    str = [sprintf('B%d',idx),'ForcedFrequencyPoints'];
    if isempty(get(this,str)),
      s = rmfield(s, str);
    end
  end
else
  NBands = hspecs.NBands;
  constraintVect = [];
  for idx = 1:NBands
    if hspecs.([sprintf('B%d',idx),'Constrained'])
      constraintVect = [constraintVect idx];  %#ok<*AGROW>
    end
  end
end

for idx = 1:NBands
  if any(constraintVect == idx)
    s = rmfield(s,[sprintf('B%d',idx),'Weights']);
  end
end

for idx = NBands+1:10
  s = rmfield(s, {[sprintf('B%d',idx),'Weights']});
  s = rmfield(s, {[sprintf('B%d',idx),'ForcedFrequencyPoints']});
end




% [EOF]
