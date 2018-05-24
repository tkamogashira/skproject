function varargout = actualdesign(this,fspec, R, M)
%ACTUALDESIGN   CIC Decimator Number of Sections (N) estimator.

%   Author(s): P. Costa
%   Copyright 2005 The MathWorks, Inc.

% Normalize usable passband frequency (fp); This algorithm expects that all
% frequencies are normalized (i.e., fp and fs);
nfreq = get(fspec, 'NormalizedFrequency'); 
normalizefreq(fspec, true); 
fp = get(fspec, 'Fpass'); 
normalizefreq(fspec, nfreq);

N = abstract_design(this,R,M,fp,fspec.Astop,'decim');

% Construct and return the MFILT.CICDECIM object.
Hm = mfilt.cicdecim(R,M,N);

varargout = {Hm};


% [EOF]
