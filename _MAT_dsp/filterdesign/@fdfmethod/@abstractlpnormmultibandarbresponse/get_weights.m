function W = get_weights(this,hspecs,nfpts)
%GET_WEIGHTS Get the weights.

%   Copyright 2010-2011 The MathWorks, Inc.

% Weights
NBands = hspecs.NBands;

% Cache number of bands so that it can be used by the info method.
this.privNBands = NBands;

W = []; 

for i = 1:NBands,
    aux = get(this, ['B',num2str(i),'Weights']);
    if isempty(aux)
        aux = ones(size(get(hspecs,['B',num2str(i),'Frequencies'])));
    elseif isscalar(aux)
      aux = aux*ones(size(get(hspecs,['B',num2str(i),'Frequencies'])));
    end
    W = [W aux];  %#ok<*AGROW>
end

if length(W)~=nfpts,
    error(message('dsp:fdfmethod:abstractlpnormmultibandarbresponse:get_weights:InvalidWeights'))
end

% [EOF]
