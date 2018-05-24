function [y,zfNum,zfDen,noverflows] = df1tfilter(q,b,a,x,ziNum,ziDen,limitcycleflag)
%DF1TFILTER   Filter method for DFILT.DF1T class in fixed-point.

%   Author(s): P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
b = fi(b); resetlog(b);
a = fi(a); resetlog(a);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Re-quantize states
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
ziNum = fi(ziNum,'Signed',true,'WordLength',q.StateWordLength,...
    'FractionLength',q.privnstatefl,'fimath',F);
ziDen = fi(ziDen,'Signed',true,'WordLength',q.StateWordLength,...
    'FractionLength',q.privdstatefl,'fimath',F);
resetlog(ziNum);resetlog(ziDen);

% Attach fimath to fis
x.fimath = q.fimath;
b.fimath = q.fimath;
a.fimath = q.fimath2;
ziNum.fimath = q.fimath;
ziDen.fimath = q.fimath2;

% Initialize accumulators
numAccWL = q.fimath.SumWordLength;
numAccFL = q.fimath.SumFractionLength;
numacc = fi(0,'Signed', true,'WordLength',numAccWL,...
    'FractionLength',numAccFL,'fimath',q.fimath);
denacc = fi(0,'Signed', true,'WordLength',q.fimath2.SumWordLength,...
    'FractionLength',q.fimath2.SumFractionLength,'fimath',q.fimath2);
resetlog(numacc);resetlog(denacc);

% Multiplicand
mult = fi(0, 'Signed', true, 'WordLength', q.MultiplicandWordLength, ...
    'FractionLength', q.MultiplicandFracLength, 'fimath', q.fimath2);
resetlog(mult);

% Create y
yWL = q.OutputWordLength;
yFL = q.privoutfl;
if strcmpi(q.OutputMode, 'BestPrecision'),
    % Use Numerator accumulator precision
    yWL = numAccWL;
    yFL = numAccFL;
end
y = fi(zeros(size(x)), 'Signed', true, 'WordLength', yWL, ...
    'FractionLength', yFL, 'fimath', q.fimath);
resetlog(y);

% The DLL expects structures with the following fields
% coeffStruct.num
% coeffStruct.den
%
% statesStruct.numStates
% statesStruct.denStates
%
% mathStruct.numAccumulator
% mathStruct.denAccumulator
% mathStruct.multiplicand

% Coefficients
coeffStruct.num = b;
coeffStruct.den = a;

% States
sStruct.numStates = ziNum;
sStruct.denStates = ziDen;

% Math
mathStruct.numAccumulator = numacc;
mathStruct.denAccumulator = denacc;
mathStruct.multiplicand   = mult;

% Call DLL
fidf1tfilter(coeffStruct,sStruct,mathStruct,x,y);

% As seen above, for 'BestPrecision', we use the "full" numerator
% accumulator precision, however if the user specified an output word
% length, we need to re-quantize y back to that precision.
if strcmpi(q.OutputMode, 'BestPrecision'),
    y = fi(y, 'Signed', true, 'WordLength', q.OutputWordLength, 'fimath', q.fimath);
    q.privoutfl = y.FractionLength;
end

% Return final states
zfNum = sStruct.numStates;
zfDen = sStruct.denStates;

noverflows = [];
if nargin==7,
    % Determine if overflows caused limitcycle: look at recursive part of
    % filter only
    noverflows = 0;
    % Multiplicand
    noverflows = noverflows + get(getqloggerstruct(mathStruct.multiplicand,0), 'NOverflows');

    % States
    noverflows = noverflows + get(getqloggerstruct(sStruct.denStates,0), 'NOverflows');

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
    [outlog,numstateslog,denstateslog,multiplicandlog, ...
        numprodlog,denprodlog,numacclog,denacclog] = ...
        getlog(q,y,sStruct.numStates,sStruct.denStates, ...
        mathStruct.multiplicand, coeffStruct.num, coeffStruct.den, ...
        mathStruct.numAccumulator,mathStruct.denAccumulator,x);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.df1treport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(numstateslog), ...
            quantum.fixedlog(denstateslog), ...
            quantum.fixedlog(multiplicandlog), ...
            quantum.fixedlog(numprodlog), ...
            quantum.fixedlog(denprodlog), ...
            quantum.fixedlog(numacclog), ...
            quantum.fixedlog(denacclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.df1treport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(numstateslog), ...
            quantum.doublelog(denstateslog), ...
            quantum.doublelog(multiplicandlog), ...
            quantum.doublelog(numprodlog), ...
            quantum.doublelog(denprodlog), ...
            quantum.doublelog(numacclog), ...
            quantum.doublelog(denacclog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end


