function Ranges = getIndepVarParamRanges(IndepVarParam)

%B. Van de Sande 07-08-2003

NVar = length(IndepVarParam);
for n = 1:NVar, 
    if strcmp(IndepVarParam(n).Scale, 'lin'), Ranges(n) = floor(((IndepVarParam(n).High - IndepVarParam(n).Low)/IndepVarParam(n).Inc) + 1); 
    else, Ranges(n) = floor(log2(IndepVarParam(n).High/IndepVarParam(n).Low)/IndepVarParam(n).Inc + 1); end;    
end 