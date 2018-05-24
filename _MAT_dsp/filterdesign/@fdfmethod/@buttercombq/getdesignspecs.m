function specs = getdesignspecs(this,hs)
%GETDESIGNSPECS   Get specs needed for actual design

%   Copyright 2008 The MathWorks, Inc.

%See if desired number of peaks/notches with their corresponding desired
%quality factor fit inside the [0 2*pi] interval. If not, send a warning.
if hs.Q <= 1
    error(message('dsp:fdfmethod:buttercombq:getdesignspecs:InvalidPeakNotchQualityFactor'));
end

specs.ShelvingFilterOrder = 1; 
specs.L = hs.FilterOrder; 
specs.GBW = 10*log10(.5); 
specs.BW = (2/hs.FilterOrder)/(hs.Q);


% [EOF]
