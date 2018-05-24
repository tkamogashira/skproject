function b = fireqint(N,L,alpha,W)
%FIREQINT Equiripple interpolation FIR filter design.
%   B = FIREQINT(N,L,ALPHA) designs an FIR equiripple filter useful for
%   interpolation purposes.
%
%   N is the filter order (must be an integer). L is the interpolation
%   factor (must be an integer). ALPHA is the bandlimitedness factor, same
%   as in INTFILT. The signal to be interpolated is assumed to have zero
%   (negligible) power in the frequency band between ALPHA*Pi and Pi. ALPHA
%   must therefore be a positive scalar between 0 and 1. FIREQINT will
%   treat such band as a "don't care" band.
%
%   B = FIREQINT(N,L,ALPHA,W) allows for the specification of weights in
%   vector W. The number of weights is given by 1 + FLOOR(L/2). The use of
%   weights enable having different attenuations in different parts of the
%   stopband as well as the ability to adjust the compromise between
%   passband ripple and stopband attenuation.
%
%   B = FIREQINT('minorder',L,ALPHA,DEV) allows for the design of a filter
%   of minimum-order that meets the design specifications. DEV is a vector
%   of maximum deviations or ripples (in linear units) from the ideal
%   response. The length of DEV is given by 1 + FLOOR(L/2).
%
%   B = FIREQINT({'minorder',INITORD},L,ALPHA,DEV) allows for the
%   specification of an initial estimate of the filter order.
%
%   EXAMPLE: Design a minimum order interpolation filter for L = 6 and
%            % ALPHA = 0.8. A vector of ripples must be supplied.
%            b = fireqint('minorder',6,.8,[0.01 .1 .05 .02]);
%            h = mfilt.firinterp(6,b); % Create a polyphase interpolator filter
%            zerophase(h); 
%
%   See also FIRNYQUIST, FIRGR, FIRHALFBAND, INTFILT, FIRLS, MFILT.

%   Author(s): R. Losada
%   Copyright 1999-2008 The MathWorks, Inc.

% Check for right number of inputs
error(nargchk(3,4,nargin,'struct'));

% Some error checking
if N ~= round(N),
	error(message('dsp:fireqint:nonIntOrd'));
end

if L ~= round(L),
	error(message('dsp:fireqint:nonIntL'));
end

if alpha <= 0  || alpha >= 1,
	error(message('dsp:fireqint:alpha0t1'));
end

if nargin > 3 && length(W) ~= floor(L/2) + 1,
	error(message('dsp:fireqint:wronglengthw'));
end

if (iscell(N) || ischar(N)) && nargin < 4,
    error(message('dsp:fireqint:nodevs'));
end


% Determine length of F
lf = L+2;
lastf = 1;
if rem(L,2),
    lastf=[];
end

fpartialedges = (alpha+0:2:lf-2)/L;
fpartialedges2 = (-alpha+2:2:lf-2)/L;

% Determine frequency vector
F = sort([0,fpartialedges,fpartialedges2,lastf]);

% Determine magnitude vector
A = [1 1 zeros(1,length(F)-2)];

if nargin < 4, W = ones(1,length(A)/2); end

% If L is odd, estimate the order with the previous even factor first
if rem(L,2) && ischar(N),
    btemp = fireqint(N,L-1,alpha,W);
    N = {'minorder',length(btemp)-1};
end
    
b = L*firgr(N,F,A,W/L);



