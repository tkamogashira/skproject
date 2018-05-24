function V = defragment(W, maxNrep);
% Waveform/defragment - defragmentation of waveform
%   W = defragment(W, maxNrep) checks for repeated chunks whose repetition
%   count exceeds maxNrep and reduces them by larger chunks that require 
%   less reps. This helps avoiding overly long play lists.
%   If W is a waveform array, the indiviudal elements of W are
%   defragmented. Default maxNrep is 20.
%
%   See methods waveform.

if nargin<2, maxNrep = 20; end
    
if numel(W)>1, % use recursion to handle multiple elements
    for iw=1:numel(W),
        V(iw) = defragment(W(iw));
    end
    V = reshape(V,size(W));
    return;
end

% delegate to local. Call it twice to weed out remaining large rep counts
V = local_defragment(W, maxNrep);
V = local_defragment(V, maxNrep);

function V = local_defragment(W, maxNrep);
V = W;
V.Samples = {};
V.Nrep = [];
V.NsamStore = 0;
Nchunk = numel(W.Nrep);
for ichunk=1:Nchunk,
    NrepOld = W.Nrep(ichunk);
    if NrepOld<=maxNrep, % small enough, just take over unchanged
        V.Samples = [V.Samples W.Samples{ichunk}];
        V.Nrep = [V.Nrep NrepOld];
    else, % too many reps, take less reps of larger chunks
        Mreduce = ceil(NrepOld/maxNrep); % reduction factor (at least 2)
        NrepNew = floor(NrepOld/Mreduce); % reduced #reps of larger chunk
        NrepTail = NrepOld-NrepNew*Mreduce; % remainder of smaller chunks
        V.Samples = [V.Samples repmat(W.Samples{ichunk}, Mreduce, 1)];
        V.Nrep = [V.Nrep NrepNew];
        if NrepTail>0,
            V.Samples = [V.Samples W.Samples{ichunk}];
            V.Nrep = [V.Nrep NrepTail];
        end
    end
end
V.NsamStore = sum(cellfun(@numel, V.Samples));
V.Nwav = numel(V.Samples);





