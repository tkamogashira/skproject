function l=MinNumLevel;

% MinNumLevel - returns minimum value in dB re RMS=1
% that makes sense (considering 16-bit D/A conversion and
% maximum analog attenuator settings)

global SGSR;

l = 20*log10(SGSR.minMagDA) - MaxAnalogAtten; 
