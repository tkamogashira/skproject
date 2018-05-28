function Spt = ApplyTimeSubtr(Spt, TimeConst)
%APPLYTIMESUBTR substract constant time from a sipketrain
%   Spt = APPLYTIMESUBTR(Spt, TimeConst) subtract the constant TimeConst from
%   every spike in the spiktrain Spt. Spike that become negative from this 
%   operation are discarded. Spt can be a numerical vector or a cell-array of
%   numerical vectors, representing multiple repetitions.
%
%   The time constant to subtract must be given as a positive scalar and in ms.

%B. Van de Sande 23-03-2004

if (TimeConst == 0) %Nothing to do ...
    return;
end

N = numel(Spt);
for n = 1:N
    %Negative spiketimes are discarded ...
    SpkTimes = Spt{n} - Const;
    Spt{n} = SpkTimes(SpkTimes >= 0);
end
