function [y,zf,noverflows] = df2tsosfilter(q,num,den,sv,issvnoteq2one,x,zi,limitcycleflag)
% DF2TSOSFILTER Filter for DFILT.DF2TSOS class in fixed-point

%   Author(s): V. Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
num = fi(num); resetlog(num);
den = fi(den); resetlog(den);
sv = fi(sv); resetlog(sv);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Quantize States
stWL = q.StateWordLength;
stFL = q.privStatefl;
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
zi = fi(zi, 'Signed', true, 'WordLength', stWL, ...
    'FractionLength', stFL, 'fimath', F);
resetlog(zi);

% Attach fimath to fis
x.fimath = q.fimath;
num.fimath = q.fimath;
den.fimath = q.fimath2;
zi.fimath = q.fimath;
% Specify precision of sum for complex arithmetic
F = copy(q.fimath);
F.ProductFractionLength = max(q.privinfl,q.privstageoutfl)+q.privcoefffl3;
F.ProductWordLength = F.ProductFractionLength + ...
    max(q.privinwl+q.privcoeffwl-q.privinfl-q.privcoefffl3, ...
    q.privcoeffwl+q.privstageoutwl-q.privcoefffl3-q.privstageoutfl);
F.SumWordLength = F.ProductWordLength+1; % Specify precision of sum for complex arithmetic
F.SumFractionLength = F.ProductFractionLength;
sv.fimath = F;

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
sStruct.states = zi;
instage = fi(0,'Signed', true, 'WordLength', q.SectionInputWordLength, ...
    'FractionLength', q.privstageinfl, 'fimath', q.fimath);
resetlog(instage);
sStruct.instage = instage;

outstage = fi(0,'Signed', true, 'WordLength', q.SectionOutputWordLength, ...
    'FractionLength', q.privstageoutfl, 'fimath', q.fimath2);
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
    yWL = q.fimath.SumWordLength;
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

% Call DLL
fidf2tsosfilter(coeffStruct,sStruct,mathStruct,x,y);
zf =sStruct.states;

if strcmpi(q.OutputMode, 'BestPrecision'),
    % Trick for BestPrecision
    y = fi(y, 'Signed', true, 'WordLength', q.OutputWordLength, 'fimath', q.fimath);
    q.privoutfl = y.FractionLength;
end

noverflows = [];
if nargin==8,
    % Determine if overflows caused limitcycle: look at recursive part of
    % filter only
    noverflows = 0;
    % States
    noverflows = noverflows + get(getqloggerstruct(sStruct.states,0), 'NOverflows');

    % Stage output
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
    [outlog,sectinlog,sectoutlog,stateslog,numprodlog,denprodlog,numacclog,denacclog] = ...
        getlog(q,y,sStruct.instage,sStruct.outstage,sStruct.states,coeffStruct.num,...
        coeffStruct.den,mathStruct.numAccumulator,mathStruct.denAccumulator,...
        coeffStruct.scalevalues,issvnoteq2one,x);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.df2tsosreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(sectinlog), ...
            quantum.fixedlog(sectoutlog), ...
            quantum.fixedlog(stateslog), ...
            quantum.fixedlog(numprodlog), ...
            quantum.fixedlog(denprodlog), ...
            quantum.fixedlog(numacclog), ...
            quantum.fixedlog(denacclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.df2tsosreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(sectinlog), ...
            quantum.doublelog(sectoutlog), ...
            quantum.doublelog(stateslog), ...
            quantum.doublelog(numprodlog), ...
            quantum.doublelog(denprodlog), ...
            quantum.doublelog(numacclog), ...
            quantum.doublelog(denacclog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end
