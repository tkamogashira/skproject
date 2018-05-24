function fraclengths = setfraclengths(this, fraclengths)
%SETFRACLENGTHS   PreSet function for the 'fraclengths' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

fraclengths = {fraclengths{:} this.privFracLengths{length(fraclengths):end}};

set(this, 'privFracLengths', fraclengths);

fraclengths = {};

% NO OP

% [EOF]
