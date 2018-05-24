function validaterefcoeffs(q, prop, val)
%VALIDATEREFCOEFFS   

%   Author(s): V. Pellissier
%   Copyright 1999-2011 The MathWorks, Inc.

if ~(strcmpi(class(val), 'double') || strcmpi(class(val), 'embedded.fi') ...
        || strncmpi(class(val), 'int', 3) || strncmpi(class(val), 'uint', 4)),
    error(message('dsp:quantum:abstractfixedsosfilterq:validaterefcoeffs:invalidDataType', prop));
end

if issparse(val),
    error(message('dsp:quantum:abstractfixedsosfilterq:validaterefcoeffs:invalidDataTypeSparce', prop));
end

if strcmpi(prop, 'sosMatrix'),
    if (strcmpi(class(val), 'double') || ...
            strncmpi(class(val), 'int', 3) || ...
            strncmpi(class(val), 'uint', 4)) && any(val(:,4)~=1),
        % if coefficients are passed in using a double data-type, a0 must be
        % exactly equal to 1 or an error will occur.        
        error(message('dsp:quantum:abstractfixedsosfilterq:validaterefcoeffs:invalidsosMatrix'));
    elseif strcmpi(class(val), 'embedded.fi') && any(val(:,4)<1-eps(val)),        
        error(message('dsp:quantum:abstractfixedsosfilterq:validaterefcoeffs:invalidsosMatrix1', num2str(double(1-eps(val)))));
    end
end


% [EOF]
