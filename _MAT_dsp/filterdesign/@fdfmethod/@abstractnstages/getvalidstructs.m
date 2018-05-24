function validstructs = getvalidstructs(this)
%GETVALIDSTRUCTS   Get the validstructs.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

if this.rcf == 1,
    validstructs = {'firinterp','firdecim', 'firtdecim'};
elseif this.rcf < 0,
    validstructs = {'firdecim', 'firtdecim'};
else
    validstructs = {'firinterp'};
end

% [EOF]
