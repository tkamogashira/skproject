function [sf, fi, mess] = safeSampleFreq(freq);
% safeSampleFreq - safe sample freq in Hz and filter index for sampling a given freq
%   [sf, fi] = safeSampleFreq(freq);
%   sf and fi have same size as freq
%   zeros are returned for frequencies outside the range
%   (also non-positive frequencies)
%   Note: corrected for TDT sample-period rounding

global SGSR;

sf = zeros(size(freq));
fi = zeros(size(freq));
bf = SGSR.samFreqs.*SGSR.maxSampleRatio; % borderline freqs
% SGST.samFreqs holds available sample freqs in ascending order
for ismp=length(bf):-1:1,
   fi(find(freq<=bf(ismp)))= ismp;
   sf(find(freq<=bf(ismp)))= SGSR.samFreqs(ismp);
end
fi(find(freq<=0))= 0;
sf(find(freq<=0))= 0;

mess = '';
if any(freq(:)==0),
   mess = 'Zero stimulus frequency.';
elseif any(sf(:)==0),
   mess = 'Stimulus frequency too high.';
end
