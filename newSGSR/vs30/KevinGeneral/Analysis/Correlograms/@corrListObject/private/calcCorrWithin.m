function result = calcCorrWithin(CLO, varargin)

defParams.DFRunAvgUnit = 'Hz';
defParams.DFRunAvgRange = 100;
defParams.DFRange = [-Inf Inf];
defParams.corrType = 'dif';
params = processParams(varargin, defParams);

for row = 1:listLength
    [corrFncs{row}, corrType{row}] = calcCorr(CLO, 'calcType', 'rows', 'rows', [row, row], 'corrType', params.corrType);
    corrLag{row} = CLO.props.lag;

    %get DF
    FFTCorr = spectana(corrLag{row}, detrend(corrFncs{row}, 'constant'), 'RunAvUnit', params.DFRunAvgUnit, 'RunAvRange', params.DFRunAvgRange);
    result.DF(row) = FFTCorr.DF;
end
result.corrFncs = corrFncs';
result.corrType = corrType';
result.corrLag = corrLag';
result.THR = getListTHR(CLO);