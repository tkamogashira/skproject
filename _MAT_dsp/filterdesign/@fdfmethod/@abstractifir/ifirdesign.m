function Hd = ifirdesign(this,hs,cm)
%IFIRDESIGN   Design the filters using IFIR.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

if nargin == 2,
    cm = 0;
end


if ~ischar(this.UpsamplingFactor)
    Fcritical = 1/this.UpsamplingFactor;
    if hs.Fpass > 0.5,
        fend = 1 - hs.Fpass;
    else
        fend = hs.Fstop;
    end
    if fend >= Fcritical,
        error(message('dsp:fdfmethod:abstractifir:ifirdesign:invalidUF'));
    end
end


if this.JointOptimization,

    % 'Advanced' design

    % Turn off all warnings.  This is to suppress the various convergence
    % warnings.  If we are not converging, the filter will not meet the
    % specifications and the 'simple' flag will be used instead.
    s = warning('off');

    hasMetSpecs = false;

    while ~hasMetSpecs && ~isinf(min(cm))
        try,
            if nargin > 2,
                [minval,minindx] = min(cm);
                cm(minindx:end) = inf; % So we don't try this index again
                this.UpsamplingFactor = minindx;
            end
            Hd = design(this,hs,'advanced');

            % Add the specifications to the filter so GETMEASUREMENTS works.
            Hd.setfdesign(hs);

            % Check if the specifications have been met.
            hasMetSpecs = isspecmet(Hd);               
        catch
            hasMetSpecs = false;
            if nargin == 2,
                % Advanced design has failed, but upsampling factor
                % is not auto.
                error(message('dsp:fdfmethod:abstractifir:ifirdesign:FilterErr'));
            end
        end
    end
    
    warning(s);
else
    if nargin > 2,
        [minval,minindx] = min(cm);
        this.UpsamplingFactor = minindx;
    end
    Hd = design(this,hs,'simple');
end





% [EOF]
