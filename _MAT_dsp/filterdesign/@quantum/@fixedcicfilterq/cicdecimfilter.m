function [y,zf,modIdxf] = cicdecimfilter(q,x,zi,R,M,N,modIdx,nx,nchans,ny)
%CICDECIMFILTER Filter for the MFILT.CICDECIM filter in fixed-point mode.

%   Author(s): P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Re-construct FI for DataTypeOverride to work all the time
for i=1:length(zi.Integrator),
   zi.Integrator(i).Value = fi(zi.Integrator(i).Value);
end
for j=1:length(zi.Comb),
   zi.Comb(j).Value = fi(zi.Comb(j).Value);
end

% Extract the states for filtering.
[zInt, zComb] = cell(zi);

%
% Output signal
%
ny = zeros(ny,nchans);
if ~isreal(x),
    ny = complex(ny,ny);
end

fm_out = fimath('SumMode','SpecifyPrecision',...
    'SumWordLength',q.OutputWordLength,...
    'SumFractionLength',q.OutputFracLength,...
    'RoundMode',q.RoundMode,...
    'OverflowMode',q.OverflowMode,...
    'CastBeforeSum',1);
y = fi(ny,'Signed', true,'WordLength',q.OutputWordLength,...
    'FractionLength',q.OutputFracLength,'fimath',fm_out);
resetlog(y);

%
% FI-based DLL
%
coeffStruct.M    = int32(M);
coeffStruct.N    = int32(N);
coeffStruct.R    = int32(R);

% Math Structure
mathStruct.modj = int32(modIdx);

% FI representing the output of integrator portion of the filter.
fm_intOut = fimath('SumMode','SpecifyPrecision',...
    'SumWordLength',q.SectionWordLengths(N),...
    'SumFractionLength',q.SectionFracLengths(N),...
    'RoundMode',q.RoundMode,...
    'OverflowMode',q.OverflowMode,...
    'CastBeforeSum',1);
yIntOut = fi(ny,'WordLength',q.SectionWordLengths(N),...
    'FractionLength',q.SectionFracLengths(N),...
    'fimath',fm_intOut);
resetlog(yIntOut);
mathStruct.yIntOut = yIntOut;

% Create FIs representing the output of each comb section
yCombOut = cell(size(zComb));
for k = 1:length(zComb),
    yCombOut{k} = fi(0,'WordLength',zComb{k}.WordLength,...
        'FractionLength',zComb{k}.FractionLength,...
        'fimath',zComb{k}.fimath);
    resetlog(yCombOut{k});
end
mathStruct.yCombOut = yCombOut;

% States Structure
statesStruct.intStates = zInt;
statesStruct.combStates = zComb;

% Call the FI-based DLL
ficicdecimfilter(coeffStruct,statesStruct,mathStruct,x,y);

% FIs containing the final filter states
zf = filtstates.cic(statesStruct.intStates,statesStruct.combStates,N);

modIdxf = mathStruct.modj;

%----------------------------------------------------------------------
% Logging: min/max, range
%----------------------------------------------------------------------
if isloggingon(q),
    f = fipref;
    [outlog, intlog, comblog] = getlog(q,y,yIntOut,zInt,yCombOut,zComb,inlog);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.cicdecimreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            intlog,comblog);
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.cicdecimreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            intlog,comblog);
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end

% [EOF]
