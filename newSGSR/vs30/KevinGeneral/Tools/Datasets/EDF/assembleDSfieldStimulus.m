function Stimulus = assembleDSfieldStimulus(Nsub, NsubRec, DSSParam, FreqParam, GWParam, ShiftGWParam, GenStimParam)

%B. Van de Sande 18-03-2004

%The values of the independent variable are always given by a columnvector in SGSR ...
IndepVar.Name      = 'Subsequence';
IndepVar.ShortName = 'SubSeq';
IndepVar.Values    = [1:NsubRec, repmat(NaN, 1, Nsub-NsubRec) ]';
IndepVar.Unit      = '#';
IndepVar.PlotScale = 'lin';

%The SGSR convention for the special structure is:
%   Special.RepDur   \ If two channels were used for stimulus presentation and the values are different
%   Special.BurstDur / for both channels then these values are given by a two element rowvector ...
%
%   Special.CarFreq \ Differences in channels is given by different columns, differences over subsequences
%   Special.ModFreq / is given by different rows ...
%
%   Special.BeatFreq    \ If the two channels are used and CarFreq (or ModFreq) changes with channel, then
%   Special.BeatModFreq / BeatFreq (or BeatModFreq) is the difference between the two channels ...
%
%   Special.ActiveChan > Left channel is 1, right channel 2 and both channels is denoted by 0 ...

%----------------------------OLD CONVENTION-------------------------------
%Special.RepDur      = GenStimParam.RepDur;
%Special.BurstDur    = GenStimParam.BurstDur;
%
%Special.CarFreq     = FreqParam.CarFreq;
%Special.ModFreq     = FreqParam.ModFreq;
%
%Special.BeatFreq    = abs(diff(Special.CarFreq, 1, 2));
%Special.BeatModFreq = abs(diff(Special.ModFreq, 1, 2));
%-------------------------------------------------------------------------

Special.RepDur      = GenStimParam.RepDur;
Special.BurstDur    = GenStimParam.BurstDur;

Special.CarFreq     = FreqParam.CarFreq;
Special.ModFreq     = FreqParam.ModFreq;

Special.BeatFreq    = Special.CarFreq(:,end)-Special.CarFreq(:,1); % Single channel-> all zeros
Special.BeatModFreq = Special.ModFreq(:,end)-Special.ModFreq(:,1); % Single channel-> all zeros

if DSSParam.Nr == 2, Special.ActiveChan = 0; else, Special.ActiveChan = DSSParam.MasterNr; end

StimParam = structcat(CollectInStruct(FreqParam, GWParam, ShiftGWParam), GenStimParam);
Stimulus = CollectInStruct(IndepVar, Special, StimParam);