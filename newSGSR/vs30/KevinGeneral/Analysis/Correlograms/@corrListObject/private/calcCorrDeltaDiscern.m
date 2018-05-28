function result = calcCorrDeltaDiscern(CLO, varargin)

defParams.DFRunAvgUnit = 'Hz';
defParams.DFRunAvgRange = 100;
defParams.DFRange = [-Inf Inf];
defParams.delta = 0;
defParams.corrType = 'dif';
params = processParams(varargin, defParams);

if ~isnumeric(params.delta) | isequal(0, params.delta) %#ok<OR2>
    error('Arguments were given in the wrong format.');
end
listLength = length(CLO.list);
for row=1:listLength
    % get reference discernvalue for this row
    refDiscernValue = CLO.list(row).discernvalue;
    % look for rows for which the discernValue is parans.delta
    % greater than refDiscernValue
    for col = 1:listLength
        otherDiscernValue = CLO.list(col).discernvalue;
        if (otherDiscernValue - refDiscernValue <= params.delta) & (otherDiscernValue - refDiscernValue >= 0)
            [result.corrFncs{row, col}, result.corrType{row, col}] = calcCorr(CLO, 'calcType', 'rows', 'rows', [col, row], 'corrType', params.corrType);
            result.corrLag{row, col} = CLO.props.lag;
            %get DF
            FFTCorr = spectana(result.corrLag{row, col}, detrend(result.corrFncs{row, col}, 'constant'), 'RunAvUnit', params.DFRunAvgUnit, 'RunAvRange', params.DFRunAvgRange);
            result.DF(row, col) = FFTCorr.DF;
        else
            result.corrFncs{row, col} = [];
            result.corrType{row, col} = '';
            result.corrLag{row, col} = [];
            result.DF(row, col) = 0;
        end
    end

end
result.CF = getListCF(CLO);