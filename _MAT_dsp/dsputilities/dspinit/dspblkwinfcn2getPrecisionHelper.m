function [wQ, Etag] = dspblkwinfcn2getPrecisionHelper(w,isSingleDataType,OflowDiagnostic,UflowDiagnostic,PrecnDiagnostic,BlockPath,OflowStr,PrecnStr,UflowStr,isSigned,WrLen,FrLen)
%DSPBLKWINFCN2GETPRECISIONHELPER Adjust generated window coefficients for precision constraints
%   [WQ, ETAG] = DSPBLKWINFCN2GETPRECISIONHELPER(W,ISSINGLEDATATYPE,OFLOWDIAGNOSTIC,UFLOWDIAGNOSTIC,PRECNDIAGNOSTIC,BLOCKPATH,OFLOWSTR,PRECNSTR,UFLOWSTR,ISSIGNED,WRLEN,FRLEN) 
%   adjusts double precision coefficients in W to the required fixed-point 
%   precision, if ISSINGLEDATATYPE is zero; to single precision if 
%   ISSINGLEDATATYPE is 1. The adjusted window coefficients are returned in WQ. 
%
%   OFLOWDIAGNOSTIC, UFLOWDIAGNOSTIC and PRECNDIAGNOSTIC govern the action to be taken on 
%   detecting an overflow, underflow and precision loss, respectively;
%   each can have a value of 0, 1, or 2, where:
%   0 implies that there is no action
%   1 impiles that the appropriate action is to throw a warning and,
%   2 implies that the appropriate action is to throw an error
%
%   OFLOWSTR, PRECNSTR and UFLOWSTR are the strings used for throwing warnings,
%   if required, when any of the events - overflow, precision-loss or underflow,
%   respectively, - are detected.
%
%   BLOCKPATH is used to indicate the originating block in the warning thrown.
%
%   The fixed-point datatype attributes are determined by isSigned (signedness),
%   WrLen (wordlength), and FrLen (fractionlength).
%
%   ETAG is used to return an error tag to the caller function, and can
%   have a value of 0, 1, 2 or 3, where:
%   0 implies no error
%   1 implies error due to overflow
%   2 implies error due to precision-loss and,
%   3 implies error due to underflow
%
%   NOTE 1: This function is called only when the specified or inferred precision is 
%   single or fixed-point, and the double precision window coefficients need to be
%   modified accordingly.
%
%   NOTE 2: This function does not throw an error by itself; it only returns the
%   appropriate error-tag (ETAG) to the caller. 

% Copyright 2007-2011 The MathWorks, Inc.
Etag = [];
OrigFromStr = ' This originated from ''%s''';

% Store warning state to restore at the end 
warnstate = warning; 
warning off fixed:fi:overflow 
warning off fixed:fi:underflow 

if (isSingleDataType == 1) 
    % The function expects wQ to be a double data type, 
    % quantized to single precision 
    wQ = single(w);
    epsQ = eps(single(1));
elseif (isSigned == 1) 
    q = quantizer('fixed',[WrLen FrLen],'nearest','saturate'); 
    wQ = quantize(q,w);
    epsQ  = eps(q);
else 
    q = quantizer('ufixed',[WrLen FrLen],'nearest','saturate'); 
    wQ = quantize(q,w);
    epsQ  = eps(q);
end

% Cast here to avoid optimize out cast for single case. For other cases wQ
% is a double, so no harm.
wQ = double(wQ);

ind_arr = 1:length(w);
wPosInd = ind_arr(w>=0);
wNegInd = ind_arr(w<0);
qErr = abs(w - wQ);


if (OflowDiagnostic ~= 0)
    % find if there has been an overflow
    qErrMax_wPos = max(qErr(wPosInd));
    qErrMax_wNeg = max(qErr(wNegInd));
    if (~isempty(qErrMax_wPos)&&(qErrMax_wPos > epsQ))||(~isempty(qErrMax_wNeg)&&(qErrMax_wNeg >= epsQ))
        if (OflowDiagnostic == 1)
            OflowStr     = [OflowStr,     OrigFromStr];
            warning(message('dsp:window:overflow', OflowStr, BlockPath));
        elseif (OflowDiagnostic == 2)
            Etag = 1;
        end        
    end    
end

if (PrecnDiagnostic ~= 0)
    % find if there has been precision loss
    nzErrPos = (qErr(wPosInd) > 0);
    nzErrNeg = (qErr(wNegInd) > 0);
    posPrecn = ((qErr(wPosInd) <= epsQ)&(nzErrPos));    
    negPrecn = ((qErr(wNegInd) < epsQ)&(nzErrNeg));

    if (~isempty(find(posPrecn,1)))||(~isempty(find(negPrecn,1)))
        if (PrecnDiagnostic == 1)
            PrecnStr     = [PrecnStr,     OrigFromStr];
            warning(message('dsp:window:precisionLoss', PrecnStr, BlockPath)); 
        elseif (PrecnDiagnostic == 2)
            Etag = [Etag 2];
        end          
    end
end

if (UflowDiagnostic ~= 0)
    % find if there has been an underflow
    uflowCases = ((wQ == 0)&(w ~= 0));
    if (~isempty(find(uflowCases,1)))
        if (UflowDiagnostic == 1)
            UflowStr     = [UflowStr,     OrigFromStr];
            warning(message('dsp:window:underflow', UflowStr, BlockPath));
        elseif (UflowDiagnostic == 2)
            Etag = [Etag 3]; 
        end        
    end
end

if (isempty(Etag))
    Etag = 0;
else
    Etag = min(Etag);
end

warning(warnstate);
