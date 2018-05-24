function s = thisdesignopts(this,s,N)
%THISDESIGNOPTS 

%   Copyright 2010-2011 The MathWorks, Inc.

% iirgrpdelay only accepts initial conditions for denominator. Do not show
% the InitNum design option since it is useless in this design.
s = rmfield(s, 'InitNum');

if nargin < 3,
    % Called by info method
    NBands = this.privNBands;  
else    
   NBands = N;
end

for k = NBands+1:10
  str = [sprintf('B%d',k),'Weights'];
  s = rmfield(s, str);
end


% [EOF]