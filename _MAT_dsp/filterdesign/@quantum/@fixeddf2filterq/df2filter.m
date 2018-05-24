function [y,zf,tapidxf,noverflows] = df2filter(q,b,a,x,zi,tapidxi,limitcycleflag)
% DF2FILTER Filter for DFILT.DF2 class in fixed-point mode.

%   Author(s): P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
b = fi(b); resetlog(b);
a = fi(a); resetlog(a);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Re-quantize states
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
zi = fi(zi,'Signed',true,'WordLength',q.StateWordLength,...
    'FractionLength',q.StateFracLength,'fimath',F);
resetlog(zi);

% Attach fimath to fis
x.fimath = q.fimath;
b.fimath = q.fimath;
a.fimath = q.fimath2;
zi.fimath = q.fimath;  % Don't think it matter what FIMATH is used

% Initialize accumulators
numacc = fi(0,'Signed', true,'WordLength',q.fimath.SumWordLength,...
    'FractionLength',q.fimath.SumFractionLength,'fimath',q.fimath);
denacc = fi(0,'Signed', true,'WordLength',q.fimath2.SumWordLength,...
    'FractionLength',q.fimath2.SumFractionLength,'fimath',q.fimath2);
resetlog(numacc);resetlog(denacc);

% Create y
if strcmpi(q.OutputMode, 'BestPrecision'),
    % Use accum precision
    yWL = q.AccumWordLength;
    yFL = q.fimath.SumFractionLength;
elseif strcmpi(q.OutputMode, 'AvoidOverflow'),
    yWL = q.OutputWordLength;
    yFL = q.privoutfl;
else
    yWL = q.OutputWordLength;
    yFL = q.OutputFracLength;
end
y = fi(zeros(size(x)), 'Signed', true, 'WordLength', yWL, ...
    'FractionLength', yFL, 'fimath', q.fimath);
resetlog(y);

% The DLL is expecting structures with the following fields:
% coeffStruct.num
% coeffStruct.den
%
% statesStruct.states
% statesStruct.tapIndex
%
% mathStruct.numAccumulator
% mathStruct.denAccumulator

% Coefficients (assume they are already row vectors)
coeffStruct.num = b;
coeffStruct.den = a;

% States
sStruct.states = zi;
sStruct.tapIndex = int32(tapidxi);

% Math
mathStruct.numAccumulator = numacc;
mathStruct.denAccumulator = denacc;

% Call the DLL
fidf2filter(coeffStruct,sStruct,mathStruct,x,y);

if strcmpi(q.OutputMode, 'BestPrecision'),
    % Trick for BestPrecision
    y = fi(y, 'Signed', true, 'WordLength', q.OutputWordLength, 'fimath', q.fimath);
    q.privoutfl = y.FractionLength;
end

% Re-create embedded.fi temporarily
zf = sStruct.states;

% Cast to double so that the indexing with circluar to linear conversion
% works properly.
tapidxf = double(sStruct.tapIndex);

noverflows = [];
if nargin==7,
    % Determine if overflows caused limitcycle: look at recursive part of
    % filter only
    noverflows = 0;
    % States
    noverflows = noverflows + get(getqloggerstruct(sStruct.states,0), 'NOverflows');

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
        getlog(q,y,sStruct.states,coeffStruct.num,coeffStruct.den,...
        mathStruct.numAccumulator,mathStruct.denAccumulator,x);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.df2report('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(stateslog), ...
            quantum.fixedlog(numprodlog), ...
            quantum.fixedlog(denprodlog), ...
            quantum.fixedlog(numacclog), ...
            quantum.fixedlog(denacclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.df2report('Double', ...
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


