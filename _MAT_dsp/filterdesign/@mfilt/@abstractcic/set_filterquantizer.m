function fq = set_filterquantizer(this, fq)
%SET_FILTERQUANTIZER   PreSet function for the 'filterquantizer' property.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

set(this, 'privfilterquantizer', fq);


nsec = this.NumberOfSections;
if ~isempty(nsec),
    validatestates(this);
end

% Remove the properties of the old quantizer.
rmprops(this, this.filterquantizer);

addprops(this, fq);

fq = [];

% [EOF]
