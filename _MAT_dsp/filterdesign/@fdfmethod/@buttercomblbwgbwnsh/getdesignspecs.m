function specs = getdesignspecs(this,hs)
%GETDESIGNSPECS   Get specs needed for actual design

%   Copyright 2008 The MathWorks, Inc.

%See if desired number of peaks/notches with their corresponding desired
%bandwidth fit inside the [0 2*pi] interval. If not, send an error.
if hs.BW >= (2/ hs.NumPeaksOrNotches)
    error(message('dsp:fdfmethod:buttercomblbwgbwnsh:getdesignspecs:InvalidPeakNotchBandwidth'));
end

specs.ShelvingFilterOrder = hs.ShelvingFilterOrder;
specs.L = hs.NumPeaksOrNotches;
specs.GBW = hs.GBW;
specs.BW = hs.BW;

% [EOF]
