function disp(this)
%DISP   Display this object.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

if length(this) > 1
    vectordisp(this);
    return;
end

fn = fieldnames(this);
N = length(fn);

% Reorder the fields. NumSamplesProcessed, ResetStates and States in
% the end.
nidx = [3, 5, 6, 1];
if this.PersistentMemory,
    nidx = [nidx, 4, 8, 7];
end
fn = fn(nidx);

siguddutils('dispstr', this, fn);

% [EOF]
