function b = actualdesign(this, hspecs)
%ACTUALDESIGN   Design the filter.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

args = designargs(this, hspecs);

minopts = {};
if this.MinPhase
    minopts = {'min'};
end

switch this.StopbandShape,
    case 'flat',
        if this.StopbandDecay~=0,
            warning(message('dsp:fdfmethod:abstractfirceqrip:actualdesign:InvalidSpecifications'));
        end
        decay = 0;
    case 'linear',
        decay = this.StopbandDecay;
end

b = {firceqrip(args{:}, 'slope', decay, minopts{:})};

% [EOF]
