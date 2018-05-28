function sp = samplePeriod(filtIndex);
% samplePeriod - sample period in us as a function of the filter index
global SGSR
sp = 1e6./SGSR.samFreqs(filtIndex);
sp = reshape(sp,size(filtIndex));