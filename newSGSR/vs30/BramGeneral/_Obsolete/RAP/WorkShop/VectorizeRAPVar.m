function [Vector, ErrTxt] = VectorizeRAPVar(RAPStat, Value)
%VectorizeRAPVar   vectorizes an RAP numerical variable
%   [Vector, ErrTxt] = VectorizeRAPVar(RAPStat, Value)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 18-03-2004

Vector = []; ErrTxt = '';

if ~isRAPStatDef(RAPStat, 'GenParam.DS'), ds = RAPStat.GenParam.DS;
else, ErTxt = 'No dataset specified'; return; end

iSubSeqs = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs'); 
NSubSeqs = length(iSubSeqs);
NSubRec  = ds.nrec;

if (length(Value) == 1), Vector = repmat(Value, NSubSeqs, 1);
elseif (length(Value) == NSubSeqs), Vector = Value;
elseif (length(Value) >= NSubRec), Vector = Value(iSubSeqs);
else, ErrTxt = 'Wrong number of elements supplied for RAP vector variable'; return; end