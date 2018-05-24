function [y, zf, acc, phaseidx, tapidx] = firdecimfilter(q,M,p,x,z,acc,phaseidx,tapidx,nx,nchans,ny)
%FIRDECIMFILTER

%   Author(s): V. Pellissier
%   Copyright 1988-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
p = fi(p);
resetlog(p);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Quantize states
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
z = fi(z, 'Signed', true, 'WordLength', q.privinwl, ...
    'FractionLength', q.privinfl, 'fimath', F);
resetlog(z);

% Attach fimath to fis
x.fimath = q.fimath;
p.fimath = q.fimath;
z.fimath = q.fimath;
acc.fimath = q.fimath;

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

% State structure
stateStruct.z = z;
stateStruct.tapidx = tapidx;

% Math Structure
mathStruct.acc = acc;
mathStruct.phaseidx = phaseidx;
phaseidxini = double(phaseidx);

% Call Mex
fifirdecimfilter(coeffStruct,stateStruct,mathStruct,x,y);

zf = stateStruct.z;
tapidx = stateStruct.tapidx;

acc = mathStruct.acc;
phaseidx = mathStruct.phaseidx;

%----------------------------------------------------------------------
% Logging: min/max, range
%----------------------------------------------------------------------
if isloggingon(q),
    f = fipref;
    [prodlog, outlog, acclog] = getlog(q,p,y,acc,x,phaseidxini);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.firdecimreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(prodlog), ...
            quantum.fixedlog(acclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.firdecimreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(prodlog), ...
            quantum.doublelog(acclog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end

