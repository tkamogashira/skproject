function s = genmcode(this)
%GENMCODE   Generate MATLAB code .

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

s = sigcodegen.mcodebuffer;

% Special case CICs

switch lower(this.Type)
    case 'interpolator'
        p = {'intf'};
        v = {num2str(this.InterpolationFactor)};
        d = {'Interpolation Factor'};
    case 'decimator'
        p = {'decf'};
        v = {num2str(this.DecimationFactor)};
        d = {'Decimation Factor'};
    case 'fractional-rate converter'
        p = {'intf', 'decf'};
        v = {num2str(this.InterpolationFactor), num2str(this.DecimationFactor)};
        d = {'Interpolation Factor', 'Decimation Factor'};
end

switch lower(this.Implementation)
    case 'defaultfilter'
        switch lower(this.Type)
            case 'interpolator'
                code = 'Hd = mfilt.firinterp(intf);';
            case 'decimator'
                code = 'Hd = mfilt.firdecim(decf);';
            case 'fractional-rate converter'
                code = 'Hd = mfilt.firsrc(intf, decf);';
        end
    case 'current'
        p{end+1} = 'num';
        v{end+1} = 'get(Hd, ''Numerator'')';
        d{end+1} = 'Get the numerator from the current filter.';
        switch lower(this.Type)
            case 'interpolator'
                code = 'Hd  = mfilt.firinterp(intf, num);';
            case 'decimator'
                code = 'Hd  = mfilt.firdecim(decf, num);';
            case 'fractional-rate converter'
                code = 'Hd  = mfilt.firsrc(intf, decf, num);';
        end
    case 'cic'
        p = [p {'diffd', 'numsecs'}];
        v = [v {num2str(evaluatevars(this.DifferentialDelay)), ...
            num2str(evaluatevars(this.NumberOfSections))}];
        d = [d {'Differential Delay', 'Number of Sections'}];
        
        if strcmpi(this.Type, 'decimator')
            code = 'Hd = mfilt.cicdecim(decf, diffd, numsecs);';
        else
            code = 'Hd = mfilt.cicinterp(intf, diffd, numsecs);';
        end
            
    case 'hold'
        code = 'Hd = mfilt.holdinterp(intf);';
    case 'linear'
        code = 'Hd = mfilt.linearinterp(intf);';
end

s.addcr(s.formatparams(p,v,d));
s.cr;
s.add(code);

% [EOF]
