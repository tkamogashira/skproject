%    Equalizing Signal RMS Level to the Level for MeddisHairCell
%    Irino, T.
%    Created:   9 Jun. 2004
%    Modified:  9 Jun. 2004
%
%    function [SndEqM, AmpdB] = Eqlz2MeddisHCLevel(Snd,fs,OutLeveldB);
%    INPUT  Snd:
%           fs: sampling frequency
%           OutLeveldB : Output level (default: 50 dB SPL)
%
%    OUTPUT SndEq: Equalized Sound (rms value of 1 is 30 dB SPL)
%           AmpdB: 3 values in dB 
%                  [OutLevel, Compensation value, SourceLevel]
%
% Ref: Meddis (1986), JASA, 79(3),pp.702-711.
%
% rms(s(t)) == sqrt(mean(s.^2)) == 1   --> 30 dB SPL
% rms(s(t)) == sqrt(mean(s.^2)) == 10  --> 50 dB SPL
% rms(s(t)) == sqrt(mean(s.^2)) == 100 --> 70 dB SPL
%
function [SndEqM, AmpdB] = Eqlz2MeddisHCLevel(Snd,fs,OutLeveldB);

if nargin < 2, help Eqlz2MeddisHCLevel; end;
if nargin < 3, OutLeveldB = []; end;  
if length(OutLeveldB) == 0, OutLeveldB = 50; end; % for speech
if nargin < 4, Method = 'Peak'; end;

SourceLevel = sqrt(mean(Snd.^2))*10^(30/20); % level in terms of Meddis Level

Amp = (10^(OutLeveldB/20))/SourceLevel;
SndEqM = Amp * Snd; 

AmpdB = [OutLeveldB  20*log10([Amp, SourceLevel])];
