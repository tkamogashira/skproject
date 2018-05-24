function W = AppendSilence(W, TotalDur, NsamBlock);
% Waveform/AppendSilence - append zeros to waveform
%   AppendSilence(W, TotalDur, NsamBlock) appends zeros to waveform W in order
%   to make W's duration TotalDur. NsamBlock is the size of the cyclic zero
%   buffer. NsamBlock defaults to 1e4. For a matrix W, each component is
%   appended to have duration TotalDur or of its corresponding components.

NsamBlock = arginDefaults('NsamBlock', 1e4);

[W, TotalDur] = SameSize(W, TotalDur);
for ii=1:numel(W),
    W(ii) = local_doit(W, TotalDur(ii), NsamBlock);
end

%==========================
function W = local_doit(W, Dur, Nz);
Nadd = round((Dur-Duration(W))*1e-3*W.Fsam);
if Nadd < 0,
    error('New duration is smaller than current duration.');
end
Nblock = floor(Nadd/Nz);
Nrem = rem(Nadd, Nz);
W.Samples{end} = [W.Samples{end}; zeros(Nrem,1)];
W.NsamStore = W.NsamStore + Nrem;
if Nblock>0,
    W.Samples{end+1} = zeros(Nz,1);
    W.Nrep(end+1) = Nblock;
    W.Nwav = W.Nwav + 1;
    W.NsamStore = W.NsamStore + Nz;
end
W.NsamPlay = W.NsamPlay + Nadd;


