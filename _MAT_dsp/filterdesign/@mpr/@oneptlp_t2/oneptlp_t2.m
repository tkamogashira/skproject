function this = oneptlp_t2(N,Fst,dF,wstruct)
%ONEPTLP_T2   Construct an ONEPTLP_T2 object.
%   H = ONEPTLP_T2(N,Fst,DF) constructs a type II, one-passband-point
%   lowpass MPR object H given a filter order N, a stopband-edge frequency
%   Fst, and a density factor DF.
%
%   N must be odd (type II lowpass only). If not specified, it defaults to
%   99. 
%
%   Fst must be greater than zero and less than one. If not specified, it
%   defaults to 0.2.
%
%   DF must be a positive integer. If not specified, it defaults to 16.
%
%   H = ONEPTLP_T2(N,Fst,DF,Wstruct) specifies a structure with parameters to
%   determine the weights. Wstruct has the following fields:
%       iresp - impulse response of filter to shape weights (used for
%               Nyquist designs but can be set to 1)
%       nneg  - boolean indicating whether the response should be
%               non-negative  (also used for Nyquist designs)
%       decay - stopband decay rate in dB.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

this = mpr.oneptlp_t2;

% Set up defaults
if nargin < 1, N = 99; end
if nargin < 2, Fst = 0.2; end
if nargin > 2, this.DensityFactor = dF; end
if nargin < 4, wstruct.nneg = false; wstruct.iresp = 1; wstruct.decay = 0; end

% The algorithm works with half the length
if rem(N,2) == 0,
    error(message('dsp:mpr:oneptlp_t2:oneptlp_t2:evenOrder'));
end
M = (N-1)/2;
this.M = M;

% Initialize all properties
init(this,Fst,wstruct);

% [EOF]
