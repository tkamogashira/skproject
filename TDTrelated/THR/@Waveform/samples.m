function [Y dt]= samples(W, flag);
% Waveform/samples - extract samples from waveform object
%     [Y dt] = samples(W) returns sample array Y and sample period dt [ms]
%     from waveform. Teh waveform is fully expanded, that is, chunks are
%     repeated if specified. W may be a left/right pair, in which case Y
%     is a Nx2 matrix, but not an array.
%
%     [Y dt] = samples(W, 'short') ignores any repeats and just
%     concatenates single chunks.

[flag] = ArginDefaults('flag', '');

if size(W,1)>1, error('Cannot plot multiple waveforms unless L/R pair'); end

Nchan = size(W,2);
dt = 1e3/W(1).Fsam; % sample period in ms
Y = [];
for ichan=1:Nchan,
    x=[];
    for ichunk=1:numel(W(ichan).Samples),
        chunk = W(ichan).Samples{ichunk};
        if isequal('short', flag),
            nrep = 1;
        else,
            nrep = W(ichan).Nrep(ichunk);
        end
        x = [x; repmat(chunk, nrep,1)];
    end
    Y = [Y x];
end
