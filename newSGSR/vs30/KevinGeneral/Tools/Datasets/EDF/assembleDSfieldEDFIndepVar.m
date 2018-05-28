function EDFIndepVar = assembleDSfieldEDFIndepVar(IndepVarParam, Nsub, NsubRec)

%B. Van de Sande 18-03-2004

%For SCH008 and CALIB ... IndepVarParam structure always a scalar for these 
%schemata ...
if (nargin == 1), [Nsub, NsubRec] = deal(length(IndepVarParam.Values)); end

%NVar   = length(IndepVarParam);
%Ranges = cellfun('length', {IndepVarParam.Values});
%    
%EDFIndepVar = IndepVarParam;
%
%if (NVar == 1), EDFIndepVar.Values = TailorIndepVal(EDFIndepVar.Values, Nsub, NsubRec);
%else,    
%    EDFIndepVar(1).Values = mmrepeat(IndepVarParam(1).Values, repmat(Ranges(2), Ranges(1), 1));
%    EDFIndepVar(2).Values = repmat(IndepVarParam(2).Values, Ranges(1), 1);
%    
%    EDFIndepVar(1).Values = TailorIndepVal(EDFIndepVar(1).Values, Nsub, NsubRec);
%    EDFIndepVar(2).Values = TailorIndepVal(EDFIndepVar(2).Values, Nsub, NsubRec);
%end

NVar = length(IndepVarParam);
EDFIndepVar = IndepVarParam;
for n = 1:NVar, EDFIndepVar(n).Values = TailorIndepVal(EDFIndepVar(n).Values, Nsub, NsubRec); end

%------------------------------------------local functions------------------------------------------
function V = TailorIndepVal(IndepVal, Nsub, NsubRec)

V = repmat(NaN, Nsub, 1);
V(1:NsubRec) = IndepVal(1:NsubRec);