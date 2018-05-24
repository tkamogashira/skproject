function b = actualdesign(this, hspecs)
%ACTUALDESIGN   Design the equipripple filter.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

tw = hspecs.TransitionWidth;

L = hspecs.Band;
R = tw*L/2;

if this.MinPhase
    if this.ZeroPhase
        error(message('dsp:fdfmethod:eqripnyqordntw:actualdesign:InvalidParamVal'));
    end
    phasecstr = {'minphase'};
elseif this.ZeroPhase
    phasecstr = {'nonnegative'};
else
    phasecstr = {};
end

switch this.StopbandShape,
    case 'flat',
        if this.StopbandDecay~=0,
            warning(message('dsp:fdfmethod:eqripnyqordntw:actualdesign:InvalidSpecifications'));
        end
        decay = 0;
    case 'linear',
        decay = this.StopbandDecay;
end

b = {firnyquist(hspecs.FilterOrder, L, R, decay, phasecstr{:})};

% [EOF]
