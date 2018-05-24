function disp(this)
%DISP Object display.
  
%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

fn = fieldnames(this);
N = length(fn);
% Reorder the fields. Persistentmemory in the end.
fn = fn([3, 4:N, 1, 2]);

rfn = fieldnames(this.CapturedProperties);

% Remove the properties that can be reset, but make sure that we retain the
% correct order for the remaining fields.
[fn, ia] = setdiff(fn, rfn);
[ia, ib] = sort(ia);
fn = fn(ib);

if this.PersistentMemory
    % Add them back to the bottom if the are not going to be reset.
    fn = [fn; rfn];
end

siguddutils('dispstr', this, fn);

% [EOF]
