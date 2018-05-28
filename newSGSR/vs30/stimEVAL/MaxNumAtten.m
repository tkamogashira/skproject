function m=MaxNumAtten;

% returns maximum attenuation in dB 
% featured by numercal attenuation (i.e., using
% fewer than the full bitrange of the D/A converter)

global SGSR;

m = a2db(SGSR.maxMagDA/SGSR.minMagDA);
