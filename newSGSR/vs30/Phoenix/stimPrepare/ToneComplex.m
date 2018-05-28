function [Pre, Cyc, Rem, Post] = ToneComplex(freqs, amps, phaseOffsets, fsam, ...
   SamCounts, delay, risedur);
% ToneComplex - compute waveform segments of tone complex
%   Usage: 
%      [Pre, Cyc, Rem, Post] = ToneComplex(freqs, amps, phaseOffsets, fsam, ...
%         SamCounts, delay, risedur);
%   PhaseOffsets in CYCLES!!
%   See stimDefinitionFS and source code of toneComplex for details.
%
%   See also ToneComplexLevelChecking

Ntone = length(freqs);
Ntot = sum(SamCounts);
SamCounts = ar2cell(SamCounts);
[Npre, Ncyc, Nrem, Npost] = deal(SamCounts{:});

phaseOffsets = 2*pi*phaseOffsets; % cycles -> radians
% the tones are in four segments: preOnset+rise, cyclic, rem, fall+postOffset
Pre = 0; Cyc = 0; Rem = 0; Post = 0; 
for itone=1:Ntone,
   omega = 2*pi*freqs(itone)/fsam; % freq as radians/sample
   % pre: starts at onset of interval (including any delay); ends at end of rise window
   ph0 = phaseOffsets(itone) - 2*pi*1e-3*delay*freqs(itone); % start phase at begin of interval (i.e., possibily before onset)
   Pre = Pre + amps(itone)*sin(ph0+omega*(0:Npre-1));
   % cyclic: starts after end of rise window; does NOT always contain integer number of cycles!
   ph0 = phaseOffsets(itone) + 2*pi*1e-3*risedur*freqs(itone); % phase in radians at start of steady portion
   Cyc = Cyc + amps(itone)*sin(ph0+omega*(0:Ncyc-1));
   % Rem: starts at end of cyc
   ph0 = ph0 + omega*Ncyc; % start phase: continue where Cyc ended
   Rem  = Rem + amps(itone)*sin(ph0+omega*(0:Nrem-1));
   % Post: starts at begin of fall
   ph0 = ph0 + omega*Nrem; % start phase: continue where Rem ended
   Post = Post + amps(itone)*sin(ph0+omega*(0:Npost-1));
end


