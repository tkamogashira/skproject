function cq = quantizecoeffs(q,c)
% Quantize coefficients

%   Author(s): V. Pellissier
%   Copyright 1988-2005 The MathWorks, Inc.

if q.InheritSettings,
    % Inherit CoeffWL and CoeffFL
    if strcmpi(class(c), 'embedded.fi'),
        q.privcoeffwl = c.WordLength;
        q.privcoefffl = c.FractionLength;
        q.privsigned = c.Signed;
        cq = c;
    elseif strncmpi(class(c), 'int', 3),
        xclass = class(c);
        q.privcoeffwl = str2num(xclass(4:end));
        q.privcoefffl = 0;
        q.privsigned = true;
        cq = fi(c,1,q.privcoeffwl,q.privcoefffl);
    elseif strncmpi(class(c), 'uint', 4),
        xclass = class(c);
        q.privcoeffwl = str2num(xclass(5:end));
        q.privcoefffl = 0;
        q.privsigned = false;
        cq = fi(c,0,q.privcoeffwl,q.privcoefffl);
    else
        % Double or single
        cq = fi(c,q.privsigned,q.privcoeffwl,q.privcoefffl);
    end
else
    % Quantize coeffs
    WL = q.privcoeffwl;
    F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
    if q.privCoeffAutoScale,
        cq = fi(c, q.privsigned, WL, 'fimath', F);
        q.privcoefffl = cq.FractionLength;
    else
        FL = q.privcoefffl;
        cq = fi(c, 'Signed', q.privsigned, 'WordLength', WL, 'FractionLength', FL, 'fimath', F);
    end
end

updateinternalsettings(q);

