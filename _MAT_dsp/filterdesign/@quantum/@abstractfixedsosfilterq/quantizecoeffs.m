function [bq,aq,svq] = quantizecoeffs(q,b,a,sv,optimizesv)
% Quantize coefficients

%   Author(s): R. Losada
%   Copyright 1988-2008 The MathWorks, Inc.

if strcmpi(class(a), 'double'),
    if any(a(:,1)~=1),
        error(message('dsp:quantum:abstractfixedsosfilterq:quantizecoeffs:invalidsosMatrix'));
    end
end
 
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
    % Scale Value FL
    if strcmpi(class(sv), 'embedded.fi'),
        q.privcoefffl3 = sv.FractionLength;
        svq = fi(sv,q.privsigned,q.privcoeffwl,q.privcoefffl3, ...
            'RoundMode', sv.RoundMode, ...
            'OverflowMode', sv.OverflowMode);
    elseif strncmpi(class(sv), 'int', 3),
        q.privcoefffl3 = 0;
        svq = fi(sv,1,q.privcoeffwl,q.privcoefffl3);
    elseif strncmpi(class(sv), 'uint', 4),
        q.privcoefffl3 = 0;
        svq = fi(sv,0,q.privcoeffwl,q.privcoefffl3);
    else
        % Double or single
        svq = fi(sv,q.privsigned,q.privcoeffwl,q.privcoefffl3);
    end
else
    % Quantize coeffs
    WL = q.privcoeffwl;
    F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
    if q.privCoeffAutoScale,
        bq = fi(b, q.privsigned, WL, 'fimath', F);
        aq = fi(a, q.privsigned, WL, 'fimath', F);
        svq = fi(sv, q.privsigned, WL, 'fimath', F);
        if optimizesv == 1
            % Excludes unit scale values and quantized unit scale values
            % for autoscaling
            notoneindex = ~((sv == 1) | (svq==1));
            svq = fi(sv(notoneindex), q.privsigned, WL, 'fimath', F);
            % Requantize all scalevalues
            svq = fi(sv, q.privsigned, WL,svq.FractionLength, 'fimath', F);
        end
        q.privcoefffl = bq.FractionLength;
        q.privcoefffl2 = aq.FractionLength;
        q.privcoefffl3 = svq.FractionLength;
        
    else
        FL1 = q.privcoefffl;
        bq = fi(b, 'Signed', q.privsigned, 'WordLength', WL, 'FractionLength', FL1, 'fimath', F);
        FL2 = q.privcoefffl2;
        aq = fi(a, 'Signed', q.privsigned, 'WordLength', WL, 'FractionLength', FL2, 'fimath', F);
        FL3 = q.privcoefffl3;
        
        svq = fi(sv, 'Signed', q.privsigned, 'WordLength', WL, 'FractionLength', FL3, 'fimath', F);
    end
end

updateinternalsettings(q);

