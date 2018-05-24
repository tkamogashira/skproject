function varargout = design(this)
%DESIGN   Design the multirate filter.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

sendstatus(this, 'Creating filter ...');

decf = get(this, 'DecimationFactor');
intf = get(this, 'InterpolationFactor');

switch lower(this.Implementation)
    case 'defaultfilter'
        switch lower(this.Type)
            case 'interpolator'
                Hd = mfilt.firinterp(intf);
            case 'decimator'
                Hd = mfilt.firdecim(decf);
            case 'fractional-rate converter'
                Hd = mfilt.firsrc(intf, decf);
        end
    case 'current'
        b = get(reffilter(this.CurrentFilter), 'Numerator');
        switch lower(this.Type)
            case 'interpolator'
                Hd = mfilt.firinterp(intf, b);
            case 'decimator'
                Hd = mfilt.firdecim(decf, b);
            case 'fractional-rate converter'
                Hd = mfilt.firsrc(intf, decf, b);
        end
    case 'cic'
        inputs = {evaluatevars(this.DifferentialDelay), ...
            evaluatevars(this.NumberOfSections)};

        if strcmpi(this.Type, 'decimator')
            Hd = mfilt.cicdecim(decf, inputs{:});
        else
            Hd = mfilt.cicinterp(intf, inputs{:});
        end
    case 'hold'
        Hd = mfilt.holdinterp(intf);
    case 'linear'
        Hd = mfilt.linearinterp(intf);
end

if nargout, varargout = {Hd}; end

info.filter = Hd;
info.mcode  = genmcode(this);

% Send this status here, in case we get a warning status...
sendstatus(this, 'Creating filter ... done.');

send(this, 'FilterDesigned', ...
    sigdatatypes.sigeventdata(this, 'FilterDesigned', info));

set(this, 'isDesigned', true);

% [EOF]
