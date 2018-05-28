function  result = calcCorrRefRow(CLO, refRow, varargin)
% CALCCORRREFROW Calculates correllograms with given refrow
%
% result = calcCorrRefRow(CLO, refRow, varargin)
%
% result.corrFncs
% result.corrType
% result.corrLag
% result.CF
% result.DF

defParams.DFRunAvgUnit = 'Hz';
defParams.DFRunAvgRange = 100;
defParams.DFRange = [-Inf Inf];
defParams.corrType = 'dif';
params = processParams(varargin, defParams);

listLength = length(CLO.list);
if ~isnumeric(refRow) | ~isequal( 0, mod(refRow,1) ) | isequal(0, refRow) %#ok<OR2>
    error('Arguments were given in the wrong format.');
end
for row=1:listLength
    [corrFncs{row}, corrType{row}] = calcCorr(CLO, 'calcType', 'rows', 'rows', [refRow, row], 'corrType', params.corrType);
    corrLag{row} = CLO.props.lag;

    %get DF
    DFIdx = find( corrLag{row} >= params.DFRange(1) & corrLag{row} <= params.DFRange(2) );
    DFX = corrLag{row}(DFIdx);
    DFY = corrFncs{row}(DFIdx);
    FFTCorr = spectana(DFX, detrend(DFY, 'constant'), 'RunAvUnit', params.DFRunAvgUnit, 'RunAvRange', params.DFRunAvgRange);
    result.DF(row) = FFTCorr.DF;
end
result.corrFncs = corrFncs';
result.corrType = corrType';
result.corrLag = corrLag';
result.THR = getListTHR(CLO);