function [Entry, UnReqTimerNrs, UnReqNSpikes] = readEDFStatTbEntry(fid, Loc, Nrep, TimeBase, TimerNrs)

%B. Van de Sande 27-05-2004

%Spiketimes are saved as unsigned 32 bit integers, but because the DSS timers are only accurate
%over 24 bits the remaining 8 bits are used to store the timer number for the corresponding
%spiketime. The decimal point is given by a time base variabele in the dataset schema.
%Spiketimes are thus stored as a fixed-point real number representation.
%Attention! One consequence of a 24 bit timer is that the clock can roll-over for long recording
%times. With a 1 microsecond time base, this occurs after 16 secs (2^16 = 16,777,216). When
%repetition times greater than 16 secs are used spiketime values have to be corrected for this,
%but this is not implemented yet.

fseek(fid, Loc, 'bof');

%Extracting spiketimes and corresponding event timer numbers ...
NrepVec = freadVAXG(fid, Nrep, 'uint32')';
Nspks = sum(NrepVec);
DataMat = reshape(freadVAXG(fid, Nspks*4, 'ubit8'), 4, Nspks);
SpkTimesMat = (DataMat(1, :) + bitshift(DataMat(2, :), 8) + bitshift(DataMat(3, :), 16))*TimeBase;
TimerNrsMat = bitand(15, DataMat(4, :)); %Maximum 16 timers so only first 4 bits should be used (15 = 00001111) ...

%Collecting unrequested timer numbers ...
idx = find(~ismember(TimerNrsMat, TimerNrs));
UnReqTimerNrs = unique(TimerNrsMat(idx));
UnReqNSpikes  = length(idx);

%Sorting spiketimes according to repetition and timer numbers ...
Ntimers = length(TimerNrs); Entry = cell(Nrep, Ntimers);
idx_end   = cumsum(NrepVec);
idx_start = [0, idx_end(1:end-1)] + 1;
for nRep = 1:Nrep, 
    for nTimer = 1:Ntimers,
        idx = idx_start(nRep) + find(TimerNrsMat(idx_start(nRep):idx_end(nRep)) == TimerNrs(nTimer)) - 1;
        Entry{nRep, nTimer} = SpkTimesMat(idx); 
    end    
end

%Old implementation: timer number is simply stripped and all spiketimes are pooled ...
%SpkTimesMat = fread(fid, sum(NrepVec), 'ubit24', 8)'*TimeBase;