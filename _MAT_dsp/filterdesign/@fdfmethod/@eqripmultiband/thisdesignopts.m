function s = thisdesignopts(this, s, N)
%THISDESIGNOPTS

%   Copyright 2011 The MathWorks, Inc.

if nargin < 3
  % Called by info method - remove BiForcedFrequencyPoints from the info if
  % no point has been specified.
  NBands = this.privNBands;  
  for k = 1:NBands
    str = [sprintf('B%d',k),'ForcedFrequencyPoints'];
    if isempty(get(this,str)),
      s = rmfield(s, str);
    end
  end    
else
  NBands = N;
end

for k = NBands+1:10
  str = [sprintf('B%d',k),'Weights'];
  str1 = [sprintf('B%d',k),'ForcedFrequencyPoints'];
  s = rmfield(s, str);
  s = rmfield(s, str1);
end


% [EOF]
