function fresp = getfresp(this)
%GETFRESP   Get the fresp.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

switch this.StopbandShape,
    case 'flat',
        if this.StopbandDecay~=0,
            warning(message('dsp:fdfmethod:eqriphbordntw:getfresp:InvalidSpecifications'));
        end
        fresp = {@genlp, 0, 1, 0, true}; 
    case 'linear',
        % Sloped Stopband FRESP
        fresp = {@genlp, this.StopbandDecay, 1, 0, true}; 
    case '1/f',
        % 1/f Stopband FRESP
        fresp = {@genlp, this.StopbandDecay, 1, 0, true, true}; 
end

% [EOF]
