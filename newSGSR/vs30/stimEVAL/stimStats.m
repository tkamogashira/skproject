function stats = stimStats(WVF, SUBS);
% evaluate buffer statistics of waveform pool
% result must be placed in DAstats field of stimDef struct
% prior to stimGEN call(s).

MaxAP2buffers = 450; % hard limit is 500 according to TDT specs...
% ... but need some extra for seqplay, sync and silence buffers

Npool=length(WVF);
% do some stats
Nbuffers = 0;
Nsample = zeros(1,Npool);
for ipool=1:Npool,
   Nbuffers = Nbuffers + prod(size(WVF{ipool}.DAdata.bufSizes));
   Nsample(ipool) = sum(sum(WVF{ipool}.DAdata.bufSizes));
end
TotalNsample = sum(Nsample);
stored = zeros(1, Npool); % none of the waveforms is stored yet
% find out how D/A samples can best be stored
if AP2present, maxNwords = s232('freewords');
else, maxNwords = inf;
end
if (Nbuffers<MaxAP2buffers) & (TotalNsample < 0.85*maxNwords),
   advice = 'StoreAllOnAP2';
else,
   advice = 'StorePerSubseq';
end


% do statistics on subsequences
Nsubs = length(SUBS);
SubSeqFitsOnAP2 = zeros(1,Nsubs);
for isub=1:Nsubs,
   wfIndex = SUBS{isub}.ipool;
   wfIndex = wfIndex(find(wfIndex>0)); % remove 0 values of inactive channels
   SubSeqFitsOnAP2(isub) = (sum(Nsample(wfIndex))<0.9*maxNwords);
end
if ~all(SubSeqFitsOnAP2), advice = 'UseDoubleBuffering'; end;
% advice = 'UseDoubleBuffering'; % -----DEBUG-----

stats = CollectInStruct(Nbuffers, TotalNsample, Nsample, stored, advice, ...
   SubSeqFitsOnAP2);


