function [y, zf, polyacc, phaseidx] = firtdecimfilter(q,M,p,x,z,polyacc,phaseidx,nx,nchans,ny)
%FIRTDECIMFILTER

%   Author(s): V. Pellissier
%   Copyright 1988-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
p = fi(p); resetlog(p);
polyacc = fi(polyacc); resetlog(polyacc);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Quantize states
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
z = fi(z, 'Signed', z.Signed, 'WordLength', q.privstatewl, ...
    'FractionLength', q.privstatefl, 'fimath', F);
resetlog(z);

% Attach fimath to fis
x.fimath = q.PolyAccfimath;
p.fimath = q.PolyAccfimath;
z.fimath = q.fimath;
polyacc.fimath = q.PolyAccfimath;

% Initialize acc
accWL = q.fimath.SumWordLength;
accFL = q.fimath.SumFractionLength;
acc = fi(0, 'Signed', true, 'WordLength', accWL, ...
    'FractionLength', accFL, 'fimath', q.fimath);
resetlog(acc);
resetlog(polyacc);

% Create y
yWL = q.OutputWordLength;
yFL = q.OutputFracLength;
ny = zeros(ny,nchans);
if ~isreal(x),
    ny = complex(ny,ny);
end
y = fi(ny, 'Signed', true, 'WordLength', yWL, ...
    'FractionLength', yFL, 'fimath', q.fimath);
resetlog(y);

% Coefficients Structure
coeffStruct.p = p;
coeffStruct.M = M;

% Math Structure
mathStruct.polyAcc = polyacc;
mathStruct.acc = acc;
mathStruct.phaseidx = phaseidx;
phaseidxini = double(phaseidx);

% Call Mex
fifirtdecimfilter(coeffStruct,z,mathStruct,x,y);

zf = z;
polyacc = mathStruct.polyAcc;
phaseidx = mathStruct.phaseidx;

%----------------------------------------------------------------------
% Logging: min/max, range
%----------------------------------------------------------------------
if isloggingon(q),
    f = fipref;
    [prodlog, outlog, acclog, statelog, polyacclog] = getlog(q,p,y,acc,z,polyacc,x,phaseidxini);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.firtdecimreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(statelog), ...
            quantum.fixedlog(prodlog), ...
            quantum.fixedlog(acclog), ...
            quantum.fixedlog(polyacclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.firtdecimreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(statelog), ...
            quantum.doublelog(prodlog), ...
            quantum.doublelog(acclog), ...
            quantum.doublelog(polyacclog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end


% [EOF]
