function rcf = get_ratechangefactors(this, rcf)
%GET_RATECHANGEFACTORS   PreGet function for the 'ratechangefactors' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

rcf = getratechangefactors(this);

rcf = prod(rcf);

% [EOF]
