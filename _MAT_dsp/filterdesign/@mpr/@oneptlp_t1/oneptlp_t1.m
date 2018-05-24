function this = oneptlp(N,Fst,dF,wstruct)
%ONEPTLP   Construct an ONEPTLP object.
%   H = ONEPTLP_T1(N,Fst,DF) constructs a type I, one-passband-point
%   lowpass MPR object H given a filter order N, a stopband-edge frequency
%   Fst, and a density factor DF.
%
%   N must be even (type I lowpass only). If not specified, it defaults to
%   100. 
%
%   Fst must be greater than zero and less than one. If not specified, it
%   defaults to 0.2.
%
%   DF must be a positive integer. If not specified, it defaults to 16.
%
%   H = ONEPTLP_T1(N,Fst,DF,Wstruct) specifies a structure with parameters to
%   determine the weights. Wstruct has the following fields:
%       iresp - impulse response of filter to shape weights (used for
%               Nyquist designs but can be set to 1)
%       nneg  - boolean indicating whether the response should be
%               non-negative  (also used for Nyquist designs)
%       decay - stopband decay rate in dB.


%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

this = mpr.oneptlp_t1;

% Set up defaults
if nargin < 1, N = 100; end
if nargin < 2, Fst = 0.2; end
if nargin > 2, this.DensityFactor = dF; end
if nargin < 4, wstruct.nneg = false; wstruct.iresp = 1; wstruct.decay = 0; end


% The algorithm works with half the order
if rem(N,2) == 1,
    error(message('dsp:mpr:oneptlp_t1:oneptlp_t1:oddOrder'));
end
M = N/2;
this.M = M;

% Initialize all properties
init(this,Fst,wstruct);

% [EOF]
