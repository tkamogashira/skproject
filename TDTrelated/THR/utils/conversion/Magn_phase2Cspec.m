function Cspec = Magn_phase2Cspec(MG, PH);
% Magn_phase2Cspec - convert complex spectrum into magnitude and phase
%    Magn_phase2Cspec(MG, PH) returns the complex spectrum from the
%    magnitide MG in dB re RMS=1 and the phase PH in cycles.
%
%    Magn_phase2Cspec(S), where S is a struct, is the same as 
%    Magn_phase2Cspec(S.MG, S.PH).
%  
%    See also Cspec2Magn_Phase, ad2dB, FFT, cunwrap, ucunwrap.

if nargin==1 && isstruct(MG), % get MG ,PH fields from the single input arg
    PH = MG.PH;
    MG = MG.MG;
end
Cspec = db2a(MG).*exp(2*pi*i*PH);

