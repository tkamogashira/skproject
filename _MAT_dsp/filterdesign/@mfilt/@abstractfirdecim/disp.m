function disp(this)
%DISP Object display.
  
%   Author: V. Pellissier
%   Copyright 1988-2004 The MathWorks, Inc.

fn = fieldnames(this);
N = length(fn);
% Reorder the fields. NumSamplesProcessed, ResetStates and States in
% the end.
ispersistent = this.PersistentMemory;
if N>8,
    nidx = [3, 7, 5, 6, 1];
    if ispersistent,
        nidx = [nidx, 4, 8, 9];
    end
else
    nidx = [3, 5, 6, 1];
    if ispersistent,
        nidx = [nidx, 4, 7, 8];
    end
end
fn = fn(nidx);

siguddutils('dispstr', this, fn, 20);
disp(this.filterquantizer, 20);

% [EOF]
