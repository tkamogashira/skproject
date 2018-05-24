function checkfilterinputs(h,Sx,Sd)
%CHECKFILTERINPUTS Check for valid filter inputs
%
%   Inputs:
%      h - Filter object
%      Sx - Size of input signal (two element vector)
%      Sd - Size of desired signal (two element vector)

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

if ~any(Sx == 1) || ~any(Sd == 1),
    error(message('dsp:adaptfilt:baseclass:checkfilterinputs:InvalidDimensions1'));
end

if max(Sx) ~= max(Sd),
    error(message('dsp:adaptfilt:baseclass:checkfilterinputs:InvalidDimensions2'));
end
