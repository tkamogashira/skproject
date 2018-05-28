function [Freq, Err] = extractSCHFreqVal(SchData, DSSParam, IndepVarParam, SCHName, DCPNames);

%B. Van de Sande 03-10-2003

%Error 1 : Internal inconsistency: Multiple independent variables with same name.
%Error 2 : Internal inconsistency: Schema name that corresponds to name of independent variable is not set to NaN.
%Error 3 : In DCP expressions only references to the other DSS for that same setting are implemented.

Freq = []; Err = 0;

VarNames = {IndepVarParam.DCPName};
idx = find(ismember(VarNames, DCPNames));
if length(idx) > 1, Err = 1; return; end
    
if ~isempty(idx),
    IndepValues = IndepVarParam(idx).Values;
    IndepRange  = length(IndepValues);
    
    if DSSParam.Nr > 1,
        MFreq = translateEDFVecStr(getfield(SchData.DSSDAT(DSSParam.MasterIdx), SCHName));
        SFreq = translateEDFVecStr(getfield(SchData.DSSDAT(DSSParam.SlaveIdx), SCHName));
        
        if isnan(MFreq) & isnumeric(SFreq) & strcmp(IndepVarParam(idx).DSS, 'master'),
            Freq = [IndepValues, repmat(SFreq, IndepRange, 1)];
        elseif isnan(MFreq) & isDCPExpr(SFreq, DCPNames) & strcmp(IndepVarParam(idx).DSS, 'master'),
            Freq = [IndepValues, evalDCPExpr(SFreq, IndepValues, DCPNames)];
        elseif isnan(SFreq) & isnumeric(MFreq) & strcmp(IndepVarParam(idx).DSS, 'slave'),
            Freq = [repmat(MFreq, IndepRange, 1), IndepValues];
        elseif isnan(SFreq) & isDCPExpr(MFreq, DCPNames) & strcmp(IndepVarParam(idx).DSS, 'slave'),
            Freq = [evalDCPExpr(MFreq, IndepValues, DCPNames), IndepValues];
        else, Err = 2; return; end
    elseif strcmp(IndepVarParam(idx).DSS, 'master'),
        Freq = IndepValues;
    else, Err = 2; return; end    
else,
    if DSSParam.Nr > 1,
        MFreq = translateEDFVecStr(getfield(SchData.DSSDAT(DSSParam.MasterIdx), SCHName));
        SFreq = translateEDFVecStr(getfield(SchData.DSSDAT(DSSParam.SlaveIdx), SCHName));
        
        if isnumeric(MFreq) & isDCPExpr(SFreq, DCPNames),
            Freq = [MFreq, evalDCPExpr(SFreq, MFreq, DCPNames)];
        elseif isnumeric(SFreq) & isDCPExpr(MFreq, DCPNames),
            Freq = [evalDCPExpr(MFreq, SFreq, DCPNames), SFreq];
        elseif isnumeric(MFreq) & isnumeric(SFreq),
            Freq = [MFreq, SFreq];
        else, Err = 3; return; end
    else,
        Freq = translateEDFVecStr(getfield(SchData.DSSDAT(DSSParam.MasterIdx), SCHName));
        if ischar(Freq), Err = 3; return; end
   end    
end