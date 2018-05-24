function Hd = reffilter(this)
%REFFILTER   Returns the double representation of the filter object.

%   Author(s): J. Schickler
%   Copyright 1988-2004 The MathWorks, Inc.

Hd = copy(this);
p = findprop(this, 'Arithmetic');
if ~isempty(p),
    Hd.Arithmetic = 'double';
end
reset(Hd);

% [EOF]
