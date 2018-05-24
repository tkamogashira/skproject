function [y,zf] = cicinterpfilter(q,x,zi,R,M,N)
%CICINTERPFILTER Filter method for the MFILT.CICINTERP filter in fixed-point mode.

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

% Output signal
%
[nx,nchans] = size(x);
ny = zeros((nx*R),nchans);
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

% The FI-based DLL is expecting structures with the following fields:
% coeffStruct.M    // Differential delay
% coeffStruct.N    // Number of sections
% coeffStruct.R    // Decimation factor
%
% statesStruct.combStates // Cell array of N*nchans FIs representing the comb states
% statesStruct.intStates  // Cell array of N*nchans FIs representing the integrator states
%
% mathStruct.yCombUPOut // Single FI representing the output of Comb and Upsampling portions
% mathStruct.yCombOut   // Cell array of N*nchans FIs representing the intermediate output of each
%                       // comb section of the filter.
% mathStruct.yIntOut    // Cell array of N*nchans FIs representing the intermediate output of each
%                       // integrator section of the filter.

coeffStruct.M    = int32(M);
coeffStruct.N    = int32(N);
coeffStruct.R    = int32(R);

% States Structure
statesStruct.intStates = zInt;
statesStruct.combStates = zComb;


% Math Structure

% FI representing the output of comb and upsample portions of the filter.
fm_intOut = fimath('SumMode','SpecifyPrecision',...
    'SumWordLength',q.SectionWordLengths(N),...
    'SumFractionLength',q.SectionFracLengths(N),...
    'RoundMode',q.RoundMode,...
    'OverflowMode',q.OverflowMode,...
    'CastBeforeSum',1);
yCombUPOut = fi(ny,'WordLength',q.SectionWordLengths(N),...
    'FractionLength',q.SectionFracLengths(N),...
    'fimath',fm_intOut);
resetlog(yCombUPOut);
mathStruct.yCombUPOut = yCombUPOut;

% Create FIs representing the output of each section of the filter
yCombOut = cell(size(zComb));
yIntOut  = cell(size(zComb));
for k = 1:length(zComb),
    % Comb portion
    yCombOut{k} = fi(0,'WordLength',zComb{k}.WordLength,...
        'FractionLength',zComb{k}.FractionLength,...
        'fimath',zComb{k}.fimath);
    resetlog(yCombOut{k});
    % Integrator portion
    yIntOut{k} = fi(zInt{k},'WordLength',zInt{k}.WordLength,...
        'FractionLength',zInt{k}.FractionLength,...
        'fimath',zInt{k}.fimath);
    resetlog(yIntOut{k});
end
mathStruct.yCombOut = yCombOut;
mathStruct.yIntOut  = yIntOut;

% Call the FI-based DLL
ficicinterpfilter(coeffStruct,statesStruct,mathStruct,x,y);

% FIs containing the final filter states
zf = filtstates.cic(statesStruct.intStates,statesStruct.combStates,N);

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
        qlog = quantum.cicinterpreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            intlog,comblog);
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.cicinterpreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            intlog,comblog);
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end

% [EOF]
