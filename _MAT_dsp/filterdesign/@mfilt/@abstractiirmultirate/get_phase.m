function phase = get_phase(this, phase)
%GET_PHASE   PreGet function for the 'phase' property.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

for k = 1:length(this.privphase),
    fn{k} = sprintf('Phase%d',k);
    switch class(this.privphase(k)),
        case {'dfilt.cascadeallpass','dfilt.cascadewdfallpass'},
            phase{k} = this.privphase(k).AllpassCoefficients;
        case {'dfilt.delay','dfilt.scalar'},
            [b,a] = tf(this.privphase(k));
            phase{k} = struct('Section1',b);
        otherwise
            error(message('dsp:mfilt:abstractiirmultirate:get_phase:invalidPhase'));
    end
end
if ~isempty(phase),
    phase = cell2struct(phase,fn,2);
end

% [EOF]
