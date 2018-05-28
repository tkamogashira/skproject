function Spt = ApplyMinISI(Spt, MinISI)
%APPLYMINISI apply a minimum ISI to a spiketrain
%   Spt = APPLYMINISI(Spt, MinISI) restricts the spiktrain Spt to all spikes
%   with an interval greater than or equal to MinISI. Spt can be a numerical 
%   vector or a cell-array of numerical vectors, representing multiple
%   repetitions.
%
%   The minimum InterSpike Interval must be given as a positive scalar
%   and in ms.

%B. Van de Sande 22-03-2004

if (MinISI == 0) %Nothing to do ...
    return;
end

%Making sure that every interval between spikes can never less than the mininum
%ISI requested ... Logical indexing is not good enough ...
N = numel(Spt);
for n = 1:N
    OldSpkTrain = Spt{n}; 
    if isempty(OldSpkTrain)
        continue;
    end
    
    Intervals = diff(OldSpkTrain);
    NewSpkTrain = OldSpkTrain(1);
    idx = 1;
    while 1
        %Without cumulative intervals, the next spike included has an interval
        %equal or larger than MinISI ...
        newidx = find((Intervals(idx:end) >= MinISI), 1, 'first');
        %Using cumulative intervals, the interval between the next spike and the 
        %following is equal or larger than MinISI ...
        %newidx = find((cumsum(Intervals(idx:end)) >= MinISI), 1, 'first');
        if isempty(newidx)
            break;
        end
        idx = idx + newidx;
        NewSpkTrain = [NewSpkTrain, OldSpkTrain(idx)]; %#ok
    end    
    
    Spt{n} = NewSpkTrain;
end