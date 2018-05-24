function [y,zf] = secfilter(Hm,x,zi)
%SECFILTER Filter this section.

%   Author: P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

% Get the Filter quantizer
q = Hm.filterquantizer;

% Call the fixed-point filter quantizer method
[y,zf] = cicinterpfilter(q,x,zi,Hm.InterpolationFactor,...
    Hm.DifferentialDelay,Hm.NumberOfSections);

% [EOF]
