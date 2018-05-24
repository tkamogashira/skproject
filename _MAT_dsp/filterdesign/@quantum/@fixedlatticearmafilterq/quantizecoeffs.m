function [latq, conjlatq, ladq] = quantizecoeffs(q,lat,conjlat,lad)
% Quantize coefficients

%   Author(s): V. Pellissier
%   Copyright 1988-2005 The MathWorks, Inc.

if q.InheritSettings,
    % Inherit CoeffWL and NumCoeffFL
    if strcmpi(class(lat), 'embedded.fi'),
        q.privcoeffwl = lat.WordLength;
        q.privcoefffl = lat.FractionLength;
        q.privsigned = lat.Signed;
        latq = lat;
        conjlatq = conjlat;
    elseif strncmpi(class(lat), 'int', 3),
        xclass = class(lat);
        q.privcoeffwl = str2num(xclass(4:end));
        q.privcoefffl = 0;
        q.privsigned = true;
        latq = fi(lat,1,q.privcoeffwl,q.privcoefffl);
        conjlatq = fi(conjlat,1,q.privcoeffwl,q.privcoefffl);
    elseif strncmpi(class(lat), 'uint', 4),
        xclass = class(lat);
        q.privcoeffwl = str2num(xclass(5:end));
        q.privcoefffl = 0;
        q.privsigned = false;
        latq = fi(lat,0,q.privcoeffwl,q.privcoefffl);
        conjlatq = fi(conjlat,0,q.privcoeffwl,q.privcoefffl);
    else
        % Double or single
        latq = fi(lat,q.privsigned,q.privcoeffwl,q.privcoefffl);
        conjlatq = fi(conjlat,q.privsigned,q.privcoeffwl,q.privcoefffl);
    end
    %  Ladder FL
    if strcmpi(class(lad), 'embedded.fi'),
        q.privcoefffl2 = lad.FractionLength;
        ladq = fi(lad,q.privsigned,q.privcoeffwl,q.privcoefffl2, ...
            'RoundMode', lad.RoundMode, ...
            'OverflowMode', lad.OverflowMode);
    elseif strncmpi(class(lad), 'int', 3),
        q.privcoefffl2 = 0;
        ladq = fi(lad,1,q.privcoeffwl,q.privcoefffl2);
    elseif strncmpi(class(lad), 'uint', 4),
        q.privcoefffl2 = 0;
        ladq = fi(lad,0,q.privcoeffwl,q.privcoefffl2);
    else
        % Double or single
        ladq = fi(lad,q.privsigned,q.privcoeffwl,q.privcoefffl2);
    end
else
    % Quantize coeffs
    WL = q.privcoeffwl;
    F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
    if q.privCoeffAutoScale,
        latq = fi(lat, q.privsigned, WL, 'fimath', F);
        conjlatq = fi(conjlat, q.privsigned, WL, 'fimath', F);
        q.privcoefffl = latq.FractionLength;
        ladq = fi(lad, q.privsigned, WL, 'fimath', F);
        q.privcoefffl2 = ladq.FractionLength;
    else
        FL = q.privcoefffl;
        latq = fi(lat, 'Signed', q.privsigned, 'WordLength', WL, 'FractionLength', FL, 'fimath', F);
        conjlatq = fi(conjlat, 'Signed', q.privsigned, 'WordLength', WL, 'FractionLength', FL, 'fimath', F);
        FL = q.privcoefffl2;
        ladq = fi(lad, 'Signed', q.privsigned, 'WordLength', WL, 'FractionLength', FL, 'fimath', F);
    end
end

updateinternalsettings(q);


