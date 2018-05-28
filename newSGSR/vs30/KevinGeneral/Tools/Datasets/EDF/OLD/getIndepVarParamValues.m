function Values = getIndepVarParamValues(IndepVarParam)

%B. Van de Sande 05-08-2003

Range = getIndepVarParamRanges(IndepVarParam);

%Descending order works with same equation because the increment is negative and the highest value is given
%in IndepVarParam.Low for independent variables with descending order ...
if strcmp(IndepVarParam.Scale, 'lin'), Values = IndepVarParam.Low + (0:Range-1) * IndepVarParam.Inc; 
else, Values = IndepVarParam.Low * 2.^( (0:Range-1) * IndepVarParam.Inc ); end;