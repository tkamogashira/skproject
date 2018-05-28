function ii=filterIndex(samPeriod);

% FILTERINDEX - returns index of anti-imaging filter 
% to pick when using a sample period of SamPeriod us.
% The index corresponds to that of the global SGSR.samFreqs
% vector.
% Samperiod must be scalar.

global SGSR;
ii = min(find(1e6/samPeriod<=SGSR.samFreqs));
if isempty(ii), error('sample period out of realistic range'); end;


