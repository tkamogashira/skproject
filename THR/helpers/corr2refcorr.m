function Corr = corr2refcorr(Corr, CorrChan, Chan, EXP);
% corr2refcorr - convert interaural correlation to correlation re reference
%    corr2refcorr(Corr, CorrChan, Chan, EXP) returns a Corr or 1, depending 
%    on whether the channel specification CorrChan requires channel Chan to
%    be varied or not. If CorrChan is Ipsi or Contra (or an abbreviation),
%    it is first converted to a L/R spec. If it then matches Chan, the
%    input value Corr is returned. If not, 1 is returned. This is used to
%    realize binaural correlations by varying the noise in one of the two
%    channels, while the other channel is fixed (the "reference channel").
%
%    See also ITD2delay.

% bring both channel specs into standard form L/R
CorrChan = ipsicontra2LR(CorrChan, EXP);
Chan = ipsicontra2LR(Chan, EXP); 
if ~isequal(Chan,CorrChan),
    Corr = 1;
end








