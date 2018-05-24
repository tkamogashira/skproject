function updatefilterinternals(this,clearflag)
%UPDATEFILTERINTERNALS  Update internal settings

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

if nargin < 2,
    clearflag = false;
end

fq = this.filterquantizer;

if ~fq.Initializing,

    if clearflag,
        % Clear any possible fdesign/fmethod objects associated with this filter
        % since params have changed
        clearmetadata(this);
    end

    N = this.NumberOfSections;
    L = this.InterpolationFactor;
    D = this.DifferentialDelay;

    updatefilterinternals(this.filterquantizer,N,L,D);
end

% [EOF]
