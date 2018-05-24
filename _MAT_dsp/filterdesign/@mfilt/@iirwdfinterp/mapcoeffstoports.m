function [out coeffnames variables] = mapcoeffstoports(this,varargin)
%MAPCOEFFSTOPORTS 

%   Copyright 2009 The MathWorks, Inc.

[out, coeffnames] = super_mapcoeffstoports(this,varargin{:});

% Coefficient variables (call wdfallpass for coefficient values)
nphases = length(this.privphase);
for k = 1:nphases
    Hsection = this.privPhase(k);
    [temp tempname sectionvar] = mapcoeffstoports(Hsection);
    variables.(sprintf('Phase%d',k)) = sectionvar;
    sectionvar = [];
end

% [EOF]
