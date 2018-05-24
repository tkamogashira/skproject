function [y,zf] = latticemaminfilter(q,k,kconj,x,zi)
% LATTICEMAMINFILTER Filter for DFILT.LATTICEMAMIN class in fixed-point mode

%   Author(s): V.Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

[coeffStruct,zi,mathStruct,x,y,inlog] = input2latticearmex(q,k,kconj,x,zi);

% Call DLL
filatticemaminphasefilter(coeffStruct,zi,mathStruct,x,y);

zf = zi;

if strcmpi(q.OutputMode, 'BestPrecision'),
    % Trick for BestPrecision
    y = fi(y, 'Signed', true, 'WordLength', q.OutputWordLength, 'fimath', q.fimath);
    q.privoutfl = y.FractionLength;
end

%----------------------------------------------------------------------
% Logging: min/max, range
%----------------------------------------------------------------------
if isloggingon(q),
    f = fipref;
    %----------------------------------------------------------------------
    % Fixed-point logging: min/max, range
    %----------------------------------------------------------------------
    [prodlog, outlog, acclog, statelog] = ...
        getlogma(q,coeffStruct.lattice,coeffStruct.conjlattice,y,...
        mathStruct.acc1,mathStruct.acc2,zi,mathStruct.prevacc1,x);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.latticereport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(statelog), ...
            quantum.fixedlog(prodlog), ...
            quantum.fixedlog(acclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.latticereport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(statelog), ...
            quantum.doublelog(prodlog), ...
            quantum.doublelog(acclog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end

