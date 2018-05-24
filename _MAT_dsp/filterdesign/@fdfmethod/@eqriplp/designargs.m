function args = designargs(this, hs)
%DESIGNARGS   Return the arguments for the design method.

%   Copyright 2008 The MathWorks, Inc.

if isequal(getdesignfunction(this),@firgr)        
    % Get arguments for FIRGR    
    args = {hs.FilterOrder, ...           % Filter Order
        [0 hs.Fpass hs.Fstop 1]};         % Frequency Points
    
    switch this.StopbandShape,
        case 'flat',
            if this.StopbandDecay~=0,
                warning(message('dsp:fdfmethod:eqriplp:designargs:InvalidSpecifications'));
            end
            args(3) = {{@genlp, 0}};
        case 'linear',
            % Sloped Stopband FRESP
            args(3) = {{@genlp, this.StopbandDecay}};
        case '1/f',
            % 1/f Stopband FRESP
            args(3) = {{@genlp, this.StopbandDecay, .5, 0, false, true}};
    end
    
    args(4) = {[this.Wpass this.Wstop]};         % Weights
else
    % Get arguments for FIRPM.
    args = {hs.FilterOrder, [0 hs.Fpass hs.Fstop 1], [1 1 0 0], [this.Wpass this.Wstop]};
end
    
% [EOF]
