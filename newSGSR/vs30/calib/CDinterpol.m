function trf = CDinterpol(CD, ifilt, freq);
% CDinterpol - interpolate transfer coeficients from calibrations

DF = CD.Freq.DF(ifilt); % freq spacing in Hz
index = 1+ freq./DF; % Hz -> unrounded index of components
% clip indices to avoid exceeding the size
imin = min(CD.Freq.iLow(:,ifilt)); % lowest index calibrated
imax = max(CD.Freq.iHigh(:,ifilt)); % lowest index calibrated
index = clip(index,imin,imax);
trf = interp1(imin:imax, CD.TRF{ifilt}(imin:imax), index, '*linear');




