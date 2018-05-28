function Tol = StandardTolerances(Freqs);

% frequency tolerances: for freqs<4 kHz, a cumulative phase 
% drift of less than 0.01 cycle for each channel is imposed
% (because fine structure may show up in neural data)
% for freqs>=4 kHz, a relative freq deviation of 2e-4 
% (i.e., 2 parts in 10,000) is considered good enough.
% For the sign convention of these tolerances, see evalCyclicStorage2

FineStructLimit = 4e3;
MaxPhaseDrift = 0.01;
MaxFreqDev = 2e-4;
Tol = -MaxPhaseDrift*(Freqs<FineStructLimit)...
   + MaxFreqDev*(Freqs>=FineStructLimit);
