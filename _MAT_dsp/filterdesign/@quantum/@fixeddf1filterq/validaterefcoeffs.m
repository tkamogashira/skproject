function validaterefcoeffs(q, prop, val)
%VALIDATEREFCOEFFS Utility to check for valid reference coefficients.

%   Author(s): V. Pellissier
%   Copyright 1999-2012 The MathWorks, Inc.

if ~(strcmpi(class(val), 'double') || strcmpi(class(val), 'embedded.fi') ...
        || strncmpi(class(val), 'int', 3) || strncmpi(class(val), 'uint', 4)),
    error(message('dsp:quantum:fixeddf1filterq:validaterefcoeffs:invalidDataType', prop));
end

if issparse(val),
    error(message('dsp:quantum:fixeddf1filterq:validaterefcoeffs:invalidDataType',prop));
end

if strcmpi(prop, 'Denominator'),
    if (strcmpi(class(val), 'double') || ...
            strncmpi(class(val), 'int', 3) || ...
            strncmpi(class(val), 'uint', 4)) && any(val(1,1)~=1),
        % if coefficients are passed in using a double data-type, a0 must be
        % exactly equal to 1 or an error will occur.
        error(message('dsp:quantum:fixeddf1filterq:validaterefcoeffs:invalidA0'));
    elseif strcmpi(class(val), 'embedded.fi') && val(1,1)<1-eps(val),
        error(message('dsp:quantum:fixeddf1filterq:validaterefcoeffs:invalidA0Range', num2str(double(1-eps(val)))));
    end
end

% [EOF]
