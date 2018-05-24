function args = designargs(this, hs)
%DESIGNARGS Return the arguments for the design method.

%   Copyright 2011 The MathWorks, Inc.

if isequal(getdesignfunction(this),@firgr)       
    % Get arguments for FIRGR    
    args = {hs.FilterOrder,[0 hs.Fstop hs.Fpass 1]};
    
    switch this.StopbandShape,
        case 'flat'
            if this.StopbandDecay~=0,
                warning(message('dsp:fdfmethod:eqriphp:designargs:InvalidSpecifications'));
            end
            args(3) = {{@genhp, 0}};
        case 'linear'
            % Sloped Stopband FRESP
            args(3) = {{@genhp, this.StopbandDecay}};
        case '1/f'
            % 1/f Stopband FRESP
            args(3) = {{@genhp, this.StopbandDecay, .5, 0, false, true}};
    end
    
    args(4) = {[this.Wstop this.Wpass]};         % Weights
else
    % Get arguments for FIRPM.
    args = {hs.FilterOrder, [0 hs.Fstop hs.Fpass 1], [0 0 1 1], [this.Wstop this.Wpass]};
end

% If the filter order requested is odd, we need to append 'h' to design a
% hilbert transformer and avoid erroring.
if rem(hs.FilterOrder, 2) == 1
    args{end+1} = 'h';
end
    
% [EOF]
