function [out coeffnames variables] = mapcoeffstoports(this,varargin)
%MAPCOEFFSTOPORTS 

%   Copyright 2009 The MathWorks, Inc.


[out, coeffnames] = super_mapcoeffstoports(this,varargin{:});

% Coefficient variables
nphases = length(this.privphase);
for k = 1:nphases
    coef = coefficients(this.privPhase(k));
    nsections = length(coef);
    for n = 1:nsections
        sectionvar{n} = coef{n};
    end
    variables.(sprintf('Phase%d',k)) = sectionvar;
    sectionvar = [];
end

% [EOF]
