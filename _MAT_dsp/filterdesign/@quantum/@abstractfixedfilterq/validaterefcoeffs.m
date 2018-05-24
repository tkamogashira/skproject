function validaterefcoeffs(q, prop, val)
%VALIDATEREFCOEFFS   

%   Author(s): V. Pellissier
%   Copyright 1999-2011 The MathWorks, Inc.

if ~(strcmpi(class(val), 'double') || strcmpi(class(val), 'single') ...
        || strcmpi(class(val), 'embedded.fi') ...
        || strncmpi(class(val), 'int', 3) || strncmpi(class(val), 'uint', 4)),
    error(message('dsp:quantum:abstractfixedfilterq:validaterefcoeffs:invalidDataType1', prop));
end

if issparse(val),
    error(message('dsp:quantum:abstractfixedfilterq:validaterefcoeffs:invalidDataType2', prop));
end

    
% [EOF]
