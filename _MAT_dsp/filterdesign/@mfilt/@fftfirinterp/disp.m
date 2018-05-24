function disp(this)
%DISP Object display.
  
%   Author: V. Pellissier
%   Copyright 1988-2004 The MathWorks, Inc.

fn = fieldnames(this);
N = length(fn);
% Reorder the fields. NumSamplesProcessed, ResetStates and States in
% the end.
nidx = [3, 5, 6, 7, 1];
if this.PersistentMemory,
    nidx = [nidx, 4, 8];
end
fn = fn(nidx);

siguddutils('dispstr', this, fn);

% [EOF]
