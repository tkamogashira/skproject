function args = parseic(this,args,NumOrder,DenOrder)
%PARSEIC Make sure InitNum and InitDen are of the correct length

%   Author(s): V. Pellissier
%   Copyright 2005-2011 The MathWorks, Inc.

if ~isempty(this.InitNum),
    InitNum = this.InitNum(:).';
    if length(InitNum)~=NumOrder+1,
        error(message('dsp:fdfmethod:abstractlpnorm:parseic:InvalidInput1', NumOrder + 1));
    else
        args = [args, {InitNum}];
    end
    if ~isempty(this.InitDen),
        InitDen = this.InitDen(:).';
        if length(InitDen)~=DenOrder+1,
            error(message('dsp:fdfmethod:abstractlpnorm:parseic:InvalidInput2', DenOrder + 1));
        else
            args = [args, {InitDen}];
        end
    else
        error(message('dsp:fdfmethod:abstractlpnorm:parseic:InvalidInput3'));
    end
elseif ~isempty(this.InitDen),
    error(message('dsp:fdfmethod:abstractlpnorm:parseic:InvalidInput4'));
end

% [EOF]
