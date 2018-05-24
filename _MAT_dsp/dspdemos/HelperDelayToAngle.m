function angleInRadians = HelperDelayToAngle(delayInSamples, fs, pairSeparation)
%HELPEDELAYTOANGLE Converts delay in sample periods into angle in radians.
%
% This function HelperDelayToAngle is only in support of the example
% AudioArrayDOAEstimationExample. It may change in a future release.

% Copyright 2013 The MathWorks, Inc.

% Hard-coded speed of sound in m/s
c = 340;

delayInSeconds = delayInSamples / fs;

sinOfAngle = delayInSeconds * c / pairSeparation;
if(abs(sinOfAngle) > 1)
    angleInRadians = sign(sinOfAngle) * pi/2;
else
    angleInRadians = asin(sinOfAngle);
end
