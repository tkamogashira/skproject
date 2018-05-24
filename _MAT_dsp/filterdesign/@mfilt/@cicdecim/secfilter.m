function [y,zf] = secfilter(this,x,zi)
%SECFILTER Filter this section.

%   Author: P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

% Get the Filter quantizer
q = this.filterquantizer;

modIdx = this.InputOffset;

[nx, nchans] = size(x);
ny = allocate(this,nx,modIdx);

% Call the filter quantizer method
[y,zf,modIdxf] = cicdecimfilter(q,x,zi,this.DecimationFactor,...
    this.DifferentialDelay,...
    this.NumberOfSections,...
    modIdx,nx,nchans,ny);

% Store the positions of the modulus value
this.InputOffset = modIdxf;

% [EOF]
