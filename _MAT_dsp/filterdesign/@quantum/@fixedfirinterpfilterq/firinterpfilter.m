function [y,z,tapidx] = firinterpfilter(q,L,p,x,z,tapidx,nx,nchans,ny)
%FIRINTERPFILTER   Filtering method for fir interpolator.

%   Author(s): R. Losada
%   Copyright 1999-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
p = fi(p);
resetlog(p);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Quantize states
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
z = fi(z, 'Signed', z.Signed, 'WordLength', q.privinwl, ...
    'FractionLength', q.privinfl, 'fimath', F);
resetlog(z);

% Attach fimath to fis
x.fimath = q.fimath;
p.fimath = q.fimath;
z.fimath = q.fimath;

% Initialize accum
accWL = q.fimath.SumWordLength;
accFL = q.fimath.SumFractionLength;
acc = fi(0, 'Signed', true, 'WordLength', accWL, ...
    'FractionLength', accFL, 'fimath', q.fimath);
% Disable cast before sum
acc.fimath.CastBeforeSum=false;
resetlog(acc);

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
coeffStruct.L = L;

% State structure
stateStruct.z = z;
stateStruct.tapidx = tapidx;

% Call Mex
fifirinterpfilter(coeffStruct,stateStruct,acc,x,y);

% NOTE: Even though the in-place update to the structure implies that z and
% tapidx have already been updated, we need this assignment AND we need to
% return them both as a left hand side. Otherwise they are not updated
% correctly. This happens with fixed-point only, but it may be related to
% the fact that we pass in a structure...
z = stateStruct.z;
tapidx = stateStruct.tapidx;

%----------------------------------------------------------------------
% Logging: min/max, range
%----------------------------------------------------------------------
if isloggingon(q),
    f = fipref;
    [prodlog,outlog,acclog] = getlog(q,p,y,acc,x,inlog);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.firinterpreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(prodlog), ...
            quantum.fixedlog(acclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.firinterpreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(prodlog), ...
            quantum.doublelog(acclog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end


