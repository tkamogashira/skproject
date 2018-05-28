function [MG, PH] = Cspec2Magn_Phase(Cspec);
% Cspec2Magn_Phase - convert complex spectrum into magnitude and phase
%    [MG, PH] = Cspec2Magn_Phase returns the magnitide MG in dB re RMS=1,
%    and the phase PH in cycles of complex spectrum Cspec.
%  
%    See also Magn_phase2Cspec, ad2dB, FFT, cunwrap, ucunwrap.

MG = a2db(abs(Cspec));
PH = angle(Cspec)/2/pi;

