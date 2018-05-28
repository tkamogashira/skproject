function Spt = ApplyAnWin(Spt, AnWin)
%APPLYANWIN apply an analysis window to a spiketrain
%   Spt = APPLYANWIN(Spt, AnWin) applies the analyis window given by
%   the vector AnWin to the spiketrain in Spt. Spt can be a numerical 
%   vector or a cell-array of numerical vectors, representing multiple
%   repetitions.
%
%   The analyis window must be given as a numerical vector with an even
%   number of elements, each pair representing a time-interval to be 
%   included in the analysis.

%B. Van de Sande 22-03-2004

if isnumeric(Spt), Spt = {Spt}; end

N = length(AnWin); EvalStr = '(SpkTimes >= AnWin(1) & SpkTimes < AnWin(2))';
for n = 3:2:N, EvalStr = sprintf('%s | (SpkTimes >= AnWin(%d) & SpkTimes < AnWin(%d))', EvalStr, n, n+1); end

N = prod(size(Spt));
for n = 1:N,
    SpkTimes = Spt{n}; 
    idx = find(eval(EvalStr));
    Spt{n} = SpkTimes(idx);
end