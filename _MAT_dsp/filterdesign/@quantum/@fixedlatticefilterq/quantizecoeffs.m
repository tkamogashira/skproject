function cq = quantizecoeffs(this, c)
%QUANTIZECOEFFS   Quantize the coefficients.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

if this.InheritSettings,
    % Inherit CoeffWL and CoeffFL
    if strcmpi(class(c), 'embedded.fi'),
        this.privcoeffwl = c.WordLength;
        this.privcoefffl = c.FractionLength;
        this.privsigned = c.Signed;
        cq = c;
    elseif strncmpi(class(c), 'int', 3),
        xclass = class(c);
        this.privcoeffwl = str2num(xclass(4:end));
        this.privcoefffl = 0;
        this.privsigned = true;
        cq = fi(c,1,this.privcoeffwl,this.privcoefffl);
    elseif strncmpi(class(c), 'uint', 4),
        xclass = class(c);
        this.privcoeffwl = str2num(xclass(5:end));
        this.privcoefffl = 0;
        this.privsigned = false;
        cq = fi(c,0,this.privcoeffwl,this.privcoefffl);
    else
        % Double or single
        cq = fi(c,this.privsigned,this.privcoeffwl,this.privcoefffl);
    end
else
    % Quantize coeffs
    WL = this.privcoeffwl;
    F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
    if this.privCoeffAutoScale,
        cq = fi(c, this.privsigned, WL, 'fimath', F);
        this.privcoefffl = cq.FractionLength;
    else
        FL = this.privcoefffl;
        cq = fi(c, 'Signed', this.privsigned, 'WordLength', WL, 'FractionLength', FL, 'fimath', F);
    end
end

updateinternalsettings(this);

% [EOF]
