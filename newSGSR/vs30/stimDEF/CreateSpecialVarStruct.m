function SPV = CreateSpecialVarStruct(...
   RepDur, BurstDur, CarFreq, ModFreq, BeatFreq, BeatModFreq, ActiveChan);

% CreateSpecialVarStruct - creates standard struct in which special stimparams are stored
%   SYNTAX:
% SPV = CreateSpecialVarStruct(RepDur, BurstDur, CarFreq, ModFreq, BeatFreq, BeatModFreq, ActiveChan);

% trivial but needed as a bottleneck to standardize this info 
SPV = CollectInStruct(RepDur, BurstDur, CarFreq, ModFreq, BeatFreq, BeatModFreq, ActiveChan);

