function newfq = set_filterquantizer(this, newfq)
%SET_FILTERQUANTIZER   PreSet function for the 'filterquantizer' property.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

oldfq = get(this, 'filterquantizer');

set(this, 'privfilterquantizer', newfq);

% Remove current dynamic properties
rmprops(this, oldfq);

set_ncoeffs(newfq, naddp1(this));
set_nphases(newfq, this.DecimationFactor);

try
    
    % Quantize the coefficients
    quantizecoeffs(this);
catch
    
    % Get the old quantizer because the new one errors.
    set(this, 'privfilterquantizer', oldfq);

    newfq = oldfq;
    quantizecoeffs(this);
end

addprops(this, newfq);

validatestates(this);
validateacc(this);

% Store nothing, its stored in private.
newfq = [];

% [EOF]
