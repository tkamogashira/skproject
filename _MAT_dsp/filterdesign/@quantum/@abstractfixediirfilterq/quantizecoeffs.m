function [bq,aq] = quantizecoeffs(q,b,a)
% QUANTIZECOEFFS   Quantize coefficients.

%   Author(s): R. Losada
%   Copyright 1988-2005 The MathWorks, Inc.

if q.InheritSettings,
    % Inherit CoeffWL and NumCoeffFL
    if strcmpi(class(b), 'embedded.fi'),
        q.privcoeffwl = b.WordLength;
        q.privcoefffl = b.FractionLength;
        q.privsigned = b.Signed;
        bq = b;
    elseif strncmpi(class(b), 'int', 3),
        xclass = class(b);
        q.privcoeffwl = str2num(xclass(4:end));
        q.privcoefffl = 0;
        q.privsigned = true;
        bq = fi(b,1,q.privcoeffwl,q.privcoefffl);
    elseif strncmpi(class(b), 'uint', 4),
        xclass = class(b);
        q.privcoeffwl = str2num(xclass(5:end));
        q.privcoefffl = 0;
        q.privsigned = false;
        bq = fi(b,0,q.privcoeffwl,q.privcoefffl);
    else
        % Double or single
        bq = fi(b,q.privsigned,q.privcoeffwl,q.privcoefffl);
    end
    % DenCoeffFL
    if strcmpi(class(a), 'embedded.fi'),
        q.privcoefffl2 = a.FractionLength;
        aq = fi(a,q.privsigned,q.privcoeffwl,q.privcoefffl2, ...
            'RoundMode', a.RoundMode, ...
            'OverflowMode', a.OverflowMode);
    elseif strncmpi(class(a), 'int', 3),
        q.privcoefffl2 = 0;
        aq = fi(a,1,q.privcoeffwl,q.privcoefffl2);
    elseif strncmpi(class(a), 'uint', 4),
        q.privcoefffl2 = 0;
        aq = fi(a,0,q.privcoeffwl,q.privcoefffl2);
    else
        % Double or single
        aq = fi(a,q.privsigned,q.privcoeffwl,q.privcoefffl2);
    end
else
    % Quantize coeffs
    WL = q.privcoeffwl;
    F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
    if q.CoeffAutoScale,,
        bq = fi(b, q.privsigned, WL, 'fimath', F);
        aq = fi(a, q.privsigned, WL, 'fimath', F);
        q.privcoefffl = bq.FractionLength;
        q.privcoefffl2 = aq.FractionLength;
    else
        FL1 = q.privcoefffl;
        bq = fi(b,'Signed', q.privsigned,'WordLength',WL,'FractionLength',FL1);
        FL2 = q.privcoefffl2;
        aq = fi(a,'Signed', q.privsigned,'WordLength',WL,'FractionLength',FL2);
    end
end

updateinternalsettings(q);


