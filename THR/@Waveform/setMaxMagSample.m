function W=setMaxMagSample(W, flag);
% Waveform/setMaxMagSample - evaluate and store maximum sample magnitude
%   W = setMaxMagSample(W) checks whether the MaxMagSample field of W
%   equals Nan and, if so, provides W with the correct value derived from
%   the samples. W may be an array, in which case the maximum magnitudes
%   are evaluated for each component of W.
%
%   W = setMaxMagSample(W, 'force') always substitutes the new value.
%
%   See also Waveform.

[flag] = arginDefaults('flag','');
if ~isequal(1, nargout),
    error('setMaxMagSample requires one output argument.');
end

for ii=1:numel(W),
    if isnan(W(ii).MaxMagSam) || isequal('force', lower(flag)),
        W(ii).MaxMagSam = max(abs(cat(1,W(ii).Samples{:})));
    end
end


