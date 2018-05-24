function [y,zf,noverflows] = df1sosfilter(q,num,den,sv,issvnoteq2one,x,zi,limitcycleflag)
% DF1SOSFILTER Filter for DFILT.DF1SOS class in fixed-point

%   Author(s): V. Pellissier
%   Copyright 1988-2006 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
num = fi(num); resetlog(num);
den = fi(den); resetlog(den);
sv = fi(sv); resetlog(sv);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Quantize num & den States
zi = quantizestates(q,zi);
zinum = zi.Numerator;
ziden =  zi.Denominator;
numstWL = q.NumStateWordLength;
denstWL = q.DenStateWordLength;
numstFL = q.NumStateFracLength;
denstFL = q.DenStateFracLength;
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
if isfi(zinum),
    signed = zinum.Signed;
else
    signed = true;
end
zinum = fi(zinum, 'Signed', signed, 'WordLength', numstWL, ...
    'FractionLength', numstFL, 'fimath', F);
ziden = fi(ziden, 'Signed', signed, 'WordLength', denstWL, ...
    'FractionLength', denstFL, 'fimath', F);
resetlog(zinum);resetlog(ziden);

% Attach fimath to fis
x.fimath = q.fimath;
num.fimath = q.fimath;
zinum.fimath = q.fimath;
den.fimath = q.fimath2;
ziden.fimath = q.fimath2;
F = copy(q.fimath);
F.ProductFractionLength = max(q.privinfl,q.privdstatefl)+q.privcoefffl3;
F.ProductWordLength = F.ProductFractionLength + ...
    max(q.privinwl+q.privcoeffwl-q.privinfl-q.privcoefffl3, ...
    q.privcoeffwl+q.privdstatewl-q.privcoefffl3-q.privdstatefl);
F.SumWordLength = F.ProductWordLength+1; % Specify precision of sum for complex arithmetic
F.SumFractionLength = F.ProductFractionLength;
sv.fimath = F; % Scale value products always in full precision

% Vectorize num and den (section by section)
num = num.';
num = num(:);
den = den.';
den = den(:);

% Make num and den row vectors
num = num.';
den = den.';

% Coefficients
coeffStruct.num = num;
coeffStruct.den = den;
coeffStruct.scalevalues = sv;
coeffStruct.applysv = issvnoteq2one;

% States
sStruct.numStates = zinum;
sStruct.denStates = ziden;
instage = fi(0, 'Signed', true, 'WordLength', q.NumStateWordLength, ...
    'FractionLength', q.NumStateFracLength, 'fimath', q.fimath);
resetlog(instage);
sStruct.instage = instage;
outstage = fi(0, 'Signed', true, 'WordLength', q.DenStateWordLength, ...
    'FractionLength', q.DenStateFracLength, 'fimath', q.fimath2);
resetlog(outstage);
sStruct.outstage = outstage;

% Initialize accum
numacc = fi(0, 'Signed', true, 'WordLength', q.fimath.SumWordLength, ...
    'FractionLength', q.fimath.SumFractionLength, 'fimath', q.fimath);
denacc = fi(0, 'Signed', true, 'WordLength', q.fimath2.SumWordLength, ...
    'FractionLength', q.fimath2.SumFractionLength, 'fimath', q.fimath2);
resetlog(numacc);resetlog(denacc);

% Math
mathStruct.numAccumulator = numacc;
mathStruct.denAccumulator = denacc;

% Create y
if strcmpi(q.OutputMode, 'BestPrecision'),
    % Use accum precision
    yWL = q.AccumWordLength;
    yFL = q.fimath2.SumFractionLength;
elseif strcmpi(q.OutputMode, 'AvoidOverflow'),
    yWL = q.OutputWordLength;
    yFL = q.privoutfl;
else
    yWL = q.OutputWordLength;
    yFL = q.OutputFracLength;
end
y = fi(zeros(size(x)), 'Signed', true, 'WordLength', yWL, ...
    'FractionLength', yFL, 'fimath', q.fimath2);
resetlog(y);

% Call DLL
fidf1sosfilter(coeffStruct,sStruct,mathStruct,x,y);

% Re-create embedded.fi temporarily
if strcmpi(q.OutputMode, 'BestPrecision'),
    % Trick for BestPrecision
    y = fi(y, 'Signed', true, 'WordLength', q.OutputWordLength, 'fimath', q.fimath2);
    q.privoutfl = y.FractionLength;
end

zf = zi;
zf.Numerator = sStruct.numStates;
zf.Denominator = sStruct.denStates;

noverflows = [];
if nargin==8,
    % Determine if overflows caused limitcycle: look at recursive part of
    % filter only
    noverflows = 0;
    % States
    noverflows = noverflows + get(getqloggerstruct(sStruct.outstage,0), 'NOverflows');

    % Prod and Sum
    noverflows = noverflows + get(getqloggerstruct(mathStruct.denAccumulator,0), 'NOverflows');
    if isreal(den),
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
    [outlog,numstateslog,denstateslog,numprodlog,denprodlog,numacclog,denacclog] = ...
        getlog(q,y,sStruct.numStates,sStruct.outstage,coeffStruct.num,...
        coeffStruct.den,mathStruct.numAccumulator,mathStruct.denAccumulator,...
        coeffStruct.scalevalues,issvnoteq2one,x);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.df1sosreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(numstateslog), ...
            quantum.fixedlog(denstateslog), ...
            quantum.fixedlog(numprodlog), ...
            quantum.fixedlog(denprodlog), ...
            quantum.fixedlog(numacclog), ...
            quantum.fixedlog(denacclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.df1sosreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(numstateslog), ...
            quantum.doublelog(denstateslog), ...
            quantum.doublelog(numprodlog), ...
            quantum.doublelog(denprodlog), ...
            quantum.doublelog(numacclog), ...
            quantum.doublelog(denacclog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end

