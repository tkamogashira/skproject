function result = calcCorrAll(CLO, varargin)

defParams.DFRunAvgUnit = 'Hz';
defParams.DFRunAvgRange = 100;
defParams.corrType = 'dif';
defParams.DFRange = [-Inf Inf];
params = processParams(varargin, defParams);

listLength = length(CLO.list);
for row = 1:listLength
    for col = 1:(row-1)
        [result.corrFncs{row,col}, result.corrType{row,col}] = calcCorr(CLO, 'calcType', 'rows', 'rows', [row,col], 'corrType', params.corrType);
        result.corrLag{row,col} = CLO.props.lag;

        %get DF
        FFTCorr = spectana(result.corrLag{row,col}, detrend(result.corrFncs{row,col}, 'constant'), 'RunAvUnit', params.DFRunAvgUnit, 'RunAvRange', params.DFRunAvgRange);
        result.DF(row,col) = FFTCorr.DF;
    end
end
result.THR = getListTHR(CLO);