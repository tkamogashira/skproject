function SpkOut = SNModelSLOW(P, varargin)

%Concatenating all input spiketrains ...
Spks = cat(2, varargin{:}); NSpks = length(Spks);
Vmem = zeros(1, NSpks);
Ampl = mmrepeat(P.ainputs, cellfun('length',varargin));
[Spks, idx] = sort(Spks); Ampl = Ampl(idx);

%Actual model ...
idx = 1; SpkOut = [];
while (idx <= NSpks),
    Vmem(idx) = Vmem(idx) + Ampl(idx);
    if (Vmem(idx) >= P.thr),
        SpkOut = [SpkOut, Spks(idx)]; 
        idx = idx + min(find((Spks(idx+1:end)-Spks(idx)) > P.trefrac));
        Vmem(idx:end) = 0;
    else, 
        Vmem(idx+1:end) = Vmem(idx+1:end) + Ampl(idx+1:end).*exp(-(Spks(idx+1:end)-Spks(idx))/P.tdecay); 
        idx = idx + 1;
    end
end