function [SpkTimes, WarnTxt] = readEDFSpkTimes(fid, StatTb, Nrep, TimeBase, TimerNrs)

%B. Van de Sande 27-05-2004

SpkTimes      = cell(size(StatTb, 1), Nrep, length(TimerNrs));
UnReqTimerNrs = [];
UnReqNSpikes  = 0;

idx = find(~isnan(StatTb))';
for n = idx
    [SpkTimes(n, :, :), Nt, Ns] = ...
        readEDFStatTbEntry(fid, StatTb(n), Nrep, TimeBase, TimerNrs); 
    UnReqTimerNrs = [UnReqTimerNrs, Nt];
    UnReqNSpikes  = UnReqNSpikes + Ns;
end

if ~isempty(UnReqTimerNrs)
    UnReqTimerNrs = unique(UnReqTimerNrs);
    WarnTxt = sprintf(['%d spiketimes were collected using the unrequested ' ...
        'event timers %s'], UnReqNSpikes, mat2str(UnReqTimerNrs));
else
    WarnTxt = '';
end