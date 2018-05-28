function [IndepVarParam, SchData, Err] = reduceIndepVarParam(IndepVarParam, SchData)

%B. Van de Sande, 09-07-2004

Err = 0;

% Independent variables with DCP name none can be safely removed ...
idx = find(strcmp({IndepVarParam.DCPName}, 'none'));
if ~isempty(idx)
    IndepVarParam(idx) = [];
end

% Independent variables that do not change are removed and the the constant value of
% the independent variable overrules the value in the Schema ...
% The variables in the schema that are used as independent variables are set to a
% column vector containing the actual values ...
NVar = length(IndepVarParam); OldIndepVarParam = IndepVarParam;
for n = NVar:-1:1, %Traversing in reverse ...
    Range   = length(OldIndepVarParam(n).Values);
    VarName = OldIndepVarParam(n).DCPName;
    
    if (Range == 1) && (length(IndepVarParam) ~= 1)
        [IndepVarParam, SchData] = removeIndepVar(VarName, IndepVarParam, SchData);
    else
        SchData = resetSchData(VarName, IndepVarParam, SchData);
    end
end

%If number of independent variables is still more than one, then the variables in the schema that are used
%as independent variables are set to a column vector with a length equal to the total number of subsequences ...
%This make sure later that the values in fields of IndepVar, Special and GenStimParam are always set to
%vectors with the appropriate size ...
NVar = length(IndepVarParam);
if (NVar == 2) %More than two independent variables will give an error before this code is reached ...
    Ranges = cellfun('length', {IndepVarParam.Values});
    IndepVarParam(1).Values = mmrepeat(IndepVarParam(1).Values, repmat(Ranges(2), Ranges(1), 1));
    IndepVarParam(2).Values = repmat(IndepVarParam(2).Values, Ranges(1), 1);
    
    for n = 1:NVar
        VarName = IndepVarParam(n).DCPName;
        SchData = resetSchData(VarName, IndepVarParam, SchData);
    end
end

%-----------------------------------------local functions----------------------------------------------------
function [IndepVarParam, SchData] = removeIndepVar(VarName, IndepVarParam, SchData)

SchName = upper(SchData.SchName);

idx = find(strcmp({IndepVarParam.DCPName}, VarName));

if isfield(IndepVarParam(idx).SCHName, SchName)
    SchVName = IndepVarParam(idx).SCHName.(SchName); 
else
    SchVName = '';
end
DSSIdx     = IndepVarParam(idx).DSSidx;
ConstParam = IndepVarParam(idx).Values;

IndepVarParam(idx) = [];

PNames = fieldnames(SchData.DSSDAT);
if any(strcmp(SchVName, PNames)),
    SchData.DSSDAT(DSSIdx).(SchVName) = ConstParam;
end

%-------------------------------------------------------------------------------------------------------------
function SchData = resetSchData(VarName, IndepVarParam, SchData)

SchName = upper(SchData.SchName);

idx = find(strcmp({IndepVarParam.DCPName}, VarName));

if isfield(IndepVarParam(idx).SCHName, SchName)
    SchVName = IndepVarParam(idx).SCHName.(SchName); 
else
    SchVName = '';
end
DSSIdx     = IndepVarParam(idx).DSSidx;
ConstParam = IndepVarParam(idx).Values;

PNames = fieldnames(SchData.DSSDAT);
if any(strcmp(SchVName, PNames))
    SchData.DSSDAT(DSSIdx).(SchVName) = ConstParam;
end
