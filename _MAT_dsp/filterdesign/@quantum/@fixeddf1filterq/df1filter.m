function [y,zfNum,zfDen,nTIf,dTIf,noverflows] = df1filter(q,b,a,x,ziNum,ziDen,nTI,dTI,limitcycleflag)
%DF1FILTER Filter for the DFILT.DF1 class in Fixed-Point

%   Author(s): P. Costa
%   Copyright 1988-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
b = fi(b); resetlog(b);
a = fi(a); resetlog(a);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Attach fimath to FIs
x.fimath     = q.fimath;
ziNum.fimath = q.fimath;
b.fimath     = q.fimath;
a.fimath     = q.fimath2;
ziDen.fimath = q.fimath2;

% The DLL is expecting structures with the following fields
% coeffStruct.num
% coeffStruct.den
%
% statesStruct.numStates
% statesStruct.denStates
% statesStruct.numTapIndex
% statesStruct.denTapIndex
%
% mathStruct.numAccumulator
% mathStruct.denAccumulator

% Coefficients (assume they are already row vectors)
coeffStruct.num = b;
coeffStruct.den = a;

% States
statesStruct.numStates = ziNum;
statesStruct.denStates = ziDen;
statesStruct.numTapIndex = int32(nTI);
statesStruct.denTapIndex = int32(dTI);

% Initialize accumulators
numacc = fi(0,'Signed', true,'WordLength',q.fimath.SumWordLength,...
    'FractionLength',q.fimath.SumFractionLength,'fimath',q.fimath);
denacc = fi(0,'Signed', true,'WordLength',q.fimath2.SumWordLength,...
    'FractionLength',q.fimath2.SumFractionLength,'fimath',q.fimath2);
resetlog(numacc); resetlog(denacc);
% Math
mathStruct.numAccumulator = numacc;
mathStruct.denAccumulator = denacc;

% Create y
y = fi(zeros(size(x)),'Signed',true,'WordLength',q.OutputWordLength,...
    'FractionLength',q.OutputFracLength,'fimath',q.fimath2);
resetlog(y);

% Call the DLL
fidf1filter(coeffStruct,statesStruct,mathStruct,x,y);

zfNum = statesStruct.numStates;
zfDen = statesStruct.denStates;
nTIf = int32(statesStruct.numTapIndex);
dTIf = int32(statesStruct.denTapIndex);

noverflows = [];
if nargin==9,
    % Determine if overflows caused limitcycle: look at recursive part of
    % filter only
    noverflows = 0;
    % States
    noverflows = noverflows + get(getqloggerstruct(y,0), 'NOverflows');

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
    [outlog,numprodlog,denprodlog,numacclog,denacclog] = ...
        getlog(q,y,coeffStruct.num,coeffStruct.den,...
        mathStruct.numAccumulator,mathStruct.denAccumulator,x);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.df1report('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(numprodlog), ...
            quantum.fixedlog(denprodlog), ...
            quantum.fixedlog(numacclog), ...
            quantum.fixedlog(denacclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.df1report('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(numprodlog), ...
            quantum.doublelog(denprodlog), ...
            quantum.doublelog(numacclog), ...
            quantum.doublelog(denacclog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end


