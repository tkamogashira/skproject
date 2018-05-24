function specs = getdesignspecs(this,hs)
%GETDESIGNSPECS   Get specs needed for actual design

%   Copyright 2008 The MathWorks, Inc.

%See if desired number of peaks/notches with their corresponding desired
%bandwidth fit inside the [0 2*pi] interval. If not, send an error.
if hs.BW >= (2/ hs.FilterOrder)
    error(message('dsp:fdfmethod:buttercombbw:getdesignspecs:InvalidPeakNotchBandwidth'));
end

specs.ShelvingFilterOrder = 1; 
specs.L = hs.FilterOrder; 
specs.GBW = 10*log10(.5); 
specs.BW = hs.BW;

% [EOF]
