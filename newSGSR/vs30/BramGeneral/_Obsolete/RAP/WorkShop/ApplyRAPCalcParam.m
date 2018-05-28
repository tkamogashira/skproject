function [AdjDS, ErrTxt] = ApplyRAPCAlcParam(RAPStat, ParamList)
%ApplyRAPCalcParam  apply the RAP calculation parameters on the dataset loaded
%   [AdjDS, ErrTxt] = ApplyRAPCAlcParam(RAPStat)
%   [AdjDS, ErrTxt] = ApplyRAPCAlcParam(RAPStat, ParamList)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 13-11-2003

ErrTxt = '';

%Attention! The analysis window is applied after the subtraction of a time
%constant ...
if nargin == 1, ParamList = {'Reps', 'ConSubst', 'MinISI', 'AnWin', 'ReWin'}; end

%Applying the calculation parameters Reps, AnWin, ReWin, MinISI and ConstSubst by
%creating an adjustable dataset ...
AdjDS = adjds(RAPStat.GenParam.DS);

%If a constant is subtracted from the spiketimes, this must always be applied
%before any analysis or window is applied to it ...  
idx = find(strcmpi(ParamList, 'ConSubst'));
if ~isempty(idx), [ParamList(1), ParamList(idx)] = swap(ParamList(1), ParamList(idx)); end

NParams = length(ParamList);
for n = 1:NParams, eval(sprintf('AdjDS.%s = GetRAPCalcParam(RAPStat, ''nr'', ''%s'');', ParamList{[n n]})); end