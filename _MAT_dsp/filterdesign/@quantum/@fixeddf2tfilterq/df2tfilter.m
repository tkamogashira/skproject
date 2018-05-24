function [y,zf,noverflows] = df2tfilter(q,b,a,x,zi,limitcycleflag)
% DF2TFILTER Filter for DFILT.DF2T class in fixed-point

%   Author(s): V. Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
b = fi(b); resetlog(b);
a = fi(a); resetlog(a);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Re-quantize states
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
zi = fi(zi,'Signed',true,'WordLength',q.StateWordLength,...
    'FractionLength',q.privstatefl,'fimath',F);
resetlog(zi);

% Attach fimath to fis
x.fimath = q.fimath;
b.fimath = q.fimath;
a.fimath = q.fimath2;
zi.fimath = q.fimath;  % Don't think it matter what FIMATH is used

% Initialize accumulators
numacc = fi(0, 'Signed', true, 'WordLength', q.fimath.SumWordLength, ...
    'FractionLength', q.fimath.SumFractionLength, 'fimath', q.fimath);
denacc = fi(0, 'Signed', true, 'WordLength', q.fimath2.SumWordLength, ...
    'FractionLength', q.fimath2.SumFractionLength, 'fimath', q.fimath2);
resetlog(numacc);resetlog(denacc);

% Create y
y = fi(zeros(size(x)),'Signed',true,'WordLength',q.OutputWordLength,...
    'FractionLength',q.OutputFracLength);
y.fimath = q.fimath2;
resetlog(y);

% The DLL is expecting structures with the following fields:
% coeffStruct.num
% coeffStruct.den
%
% mathStruct.numAccumulator
% mathStruct.denAccumulator

% Coefficients
coeffStruct.num = b;
coeffStruct.den = a;

% Math
mathStruct.numAccumulator = numacc;
mathStruct.denAccumulator = denacc;

% Call DF2T DLL
fidf2tfilter(coeffStruct,zi,mathStruct,x,y);

% Return updated states
zf = zi;

noverflows = [];
if nargin==6,
    % Determine if overflows caused limitcycle: look at recursive part of
    % filter only
    noverflows = 0;
    % States
    noverflows = noverflows + get(getqloggerstruct(zi,0), 'NOverflows');

    % Prod and Sum
    noverflows = noverflows + get(getqloggerstruct(mathStruct.denAccumulator,0), 'NOverflows');
    if isreal(a),
        noverflows = noverflows + get(getqloggerstruct(coeffStruct.den,2), 'NOverflows');
    else
        noverflows = noverflows + get(getqloggerstruct(coeffStruct.den,3), 'NOverflows');
    end
end

%----------------------------------------------------------------------
% Logging: min/max, range
%----------------------------------------------------------------------
if isloggingon(q),
    f = fipref;
    [outlog,stateslog,numprodlog,denprodlog,numacclog,denacclog] = ...
        getlog(q,y,zi,coeffStruct.num,...
        coeffStruct.den,mathStruct.numAccumulator,mathStruct.denAccumulator,x);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.df2treport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(stateslog), ...
            quantum.fixedlog(numprodlog), ...
            quantum.fixedlog(denprodlog), ...
            quantum.fixedlog(numacclog), ...
            quantum.fixedlog(denacclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.df2treport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(stateslog), ...
            quantum.doublelog(numprodlog), ...
            quantum.doublelog(denprodlog), ...
            quantum.doublelog(numacclog), ...
            quantum.doublelog(denacclog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end

