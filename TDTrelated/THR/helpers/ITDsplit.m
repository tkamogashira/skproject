function S = ITDsplit(ITD, ITDtype, EXP, CAL);
% ITDsplit - convert ITD into effective waveform and gating delays
%    S = ITDsplit(ITD, ITDtype, ITDconvention, CAL) evaluates how a 
%    requested ITD must be realized in terms of stimulus generation, while 
%    accounting for any frequency-independent assymmetries in sound delivery.
%    Inputs
%      ITD: ITD [ms] requested by user. Its interpretation depends on the
%           ITDconvention input arg.
%      ITDtype: indicates what the ITD is imposed onto. Possible values are
%           waveform, ongoing, gating. 
%      EXP: experiment. The EXP input arg is passed to ITD2delay, which
%      uses the following pieces of information:
%              ITDconvention: interpretation of ITD signs 
%              RecordingSide: conversion of ipsi/contra into left/right
%              AudioChannelsUsed: DA channels in the experiment.
%      CAL: calib info, of which only the binCompDt values are used 
%           (see calibrate). Currently CAL is identical to the Experiment 
%           EXP for which the stimulus is prepared, but this should soon be 
%           replaced by an Earcalib object or equivalent.
%
%      ITDsplit returns a struct with fields
%       maxGatingDelays: max. delay (ms) of the two DAC channels
%                   L,R: left- and right-channel monaural info in struct 
%                        having fields (all in ms)
%                      requestDelay: delay derived from requested ITD
%                       Acoust_Comp: acoustic delay for compensation calib
%                                    asymmetries
%                      OngoingDelay: delay to be applied to ongoing waveform
%                       GatingDelay: delay to be applied to gating

%        
%
%    See also calibrate, ITD2delay.

% convert requested ITD into nonneg per-chan channel delays
requestDelay = ITD2delay(ITD, EXP); 
requestDelay = sameSize(requestDelay, [1 2]);


switch ITDtype,
    case 'waveform', % both ongoing part & gating
        OngoingDelay = requestDelay;
        GatingDelay = requestDelay;
        AMdelay = requestDelay;
    case 'ongoing',
        OngoingDelay = requestDelay;
        GatingDelay = 0*requestDelay;
        AMdelay = 0*requestDelay;
    case 'gating',
        OngoingDelay = 0*requestDelay;
        GatingDelay = requestDelay;
        AMdelay = requestDelay;
    case 'FS only',
        OngoingDelay = requestDelay;
        GatingDelay = 0*requestDelay;
        AMdelay = 0*requestDelay;
    case 'AM only',
        OngoingDelay = 0*requestDelay;
        GatingDelay = 0*requestDelay;
        AMdelay = requestDelay;
    case 'all except FS',
        OngoingDelay = 0*requestDelay;
        GatingDelay = requestDelay;
        AMdelay = requestDelay;
    case 'all except AM',
        OngoingDelay = requestDelay;
        GatingDelay = requestDelay;
        AMdelay = 0*requestDelay;
    otherwise,
        error(['Unknown ITD type ''' ITDtype '''.']);
end
    
% compensation of acoustic delay. This applies to any kind of delay.
Ichan = channelSelect(AudioChannelsUsed(EXP), [1 2]);
[L_comp, R_comp] = deal(nan);
if ismember(1,Ichan),
    [dum, dum, dum, L_comp]=calibrate(CAL, nan, 'L', []);
end
if ismember(2,Ichan),
    [dum, dum, dum, R_comp]=calibrate(CAL, nan, 'R', []);
end

Acoust_Comp = [L_comp R_comp];
OngoingDelay = OngoingDelay + Acoust_Comp;
GatingDelay = GatingDelay + Acoust_Comp;

DAX = 'LR';
for ii=1:2,
    S.(DAX(ii)).requestDelay = requestDelay(ii);
    S.(DAX(ii)).Acoust_Comp = Acoust_Comp(ii);
    S.(DAX(ii)).OngoingDelay = OngoingDelay(ii);
    S.(DAX(ii)).GatingDelay = GatingDelay(ii);
end
S.maxGatingDelay = max(GatingDelay);






