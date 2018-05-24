function [chanStr, ichan]  = ear2DAchan(EarSpec, RecSide);
% ear2DAchan - convert ear specification to DA-channel spec
%    [chanStr, ichan]  = ear2DAchan(EarSpec, RecSide)
%    Conversion table in case of RecSide==L(eft):
%
%    Earspec     |  I(psi) | C(ontra) | B(oth)
%    ------------------------------------------
%       chanStr  |   L     |   R      |  B
%       ichan    |   1     |   2      |  [1 2]
%    ------------------------------------------
%
%    RecSide may also be experiment object.

if isa(RecSide, 'experiment'),
    RecSide = RecSide.RecordingSide;
end

switch upper(RecSide(1)),
    case 'L', CH = 'LR'; ICH = [1 2];
    case 'R', CH = 'RL'; ICH = [2 1];
    otherwise,
        error(['Recording side ''' RecSide '''.']);
end

switch upper(EarSpec(1)),
    case 'I',
        chanStr = CH(1);
        ichan = ICH(1);
    case 'C',
        chanStr = CH(2);
        ichan = ICH(2);
    case 'B',
        chanStr = 'B';
        ichan = [1 2];
    otherwise,
        error(['Invalid ear spec ''' EarSpec '''.']);
end

