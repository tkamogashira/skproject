function polyphaseaccum = set_polyphaseaccum(h, polyphaseaccum)
%SET_POLYPHASEACCUM   PreSet function for the 'polyphaseaccum' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

polyphaseaccum = polyaccscalarexpand(h, polyphaseaccum);

% Check data type, quantize if needed
polyphaseaccum = validateacc(h.filterquantizer, polyphaseaccum);

% [EOF]
