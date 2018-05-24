function [y,zf] = latticearmafilter(q,k,kconj,ladder,x,zi)
% LATTICEARMAFILTER Filter for DFILT.LATTICEARMA class in fixed-point

%   Author(s): V.Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

[coeffStruct,zi,mathStruct,x,y,inlog] = input2latticearmex(q,k,kconj,x,zi);

% Re-construct FI coeff for DataTypeOverride to work all the time
ladder = fi(ladder);
resetlog(ladder);

% Adder ladder part
ladder.fimath = q.fimath2;
coeffStruct.ladder = ladder;
accWL = q.fimath.SumWordLength;
accFL = q.fimath2.SumFractionLength;
acc = fi(0, 'Signed', true, 'WordLength', accWL, ...
    'FractionLength', accFL, 'fimath', q.fimath2);
mathStruct.ladderacc = acc;
resetlog(acc);

% Call DLL
filatticearmafilter(coeffStruct,zi,mathStruct,x,y);

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
    % Lattice Part
    [prodlog, outlog, acclog, statelog, ladderprodlog, ladderacclog] = ...
        getlog(q,coeffStruct.lattice,coeffStruct.conjlattice,y,...
        mathStruct.acc1,mathStruct.acc2,zi,mathStruct.prevacc1,...
        coeffStruct.ladder,mathStruct.ladderacc,x);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.latticearmareport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(statelog), ...
            quantum.fixedlog(prodlog), ...
            quantum.fixedlog(acclog),...
            quantum.fixedlog(ladderprodlog), ...
            quantum.fixedlog(ladderacclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.latticearmareport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(statelog), ...
            quantum.doublelog(prodlog), ...
            quantum.doublelog(acclog),...
            quantum.doublelog(ladderprodlog), ...
            quantum.doublelog(ladderacclog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end

