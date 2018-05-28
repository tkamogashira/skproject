function EDFData = assembleDSfieldEDFData(SpkTimes, TimerNrs)

%B. Van de Sande 27-05-2004

EDFData = [];

if isempty(SpkTimes), 
    EDFData = setfield(EDFData, sprintf('SpikeTimes%d', TimerNrs), []); 
else,    
    N = length(TimerNrs);
    for n = 1:N, EDFData = setfield(EDFData, sprintf('SpikeTimes%d', TimerNrs(n)), SpkTimes(:, :, n)); end    
end