function [O1, O2] = calcCorr(CLO, varargin)
% CALCCORR Calculates correlograms for given subsequences.
% 
% CLR = calcCorr(CLO, params)
% Calculate correlograms for the given list. Results are returned in a
% corrListResults object. 
% 
% Params:
%  Parameters are given an a 'paramName', paramValue list. For more
%  clarification, look at the example below. 
%  
%  A first obligatory parameter is calcType. It assumes one of the
%  following values:   
%  ''refrow'', ''deltadiscern'', ''all'', ''within'' or ''rows''.
%  
%  refrow: 
%     An extra parameter ''refrow'' is required. Correlograms are
%     calculated between the reference row and all other rows. 
%  deltadiscern:
%     An extra parameter ''delta'' is required. Discernvalues of the rows
%     in the list are compared. If the discernvalue of two rows differs by
%     exactly the value ''delta'', a correlogram is calculated. This
%     parameter was used in [[deltaCorr]]. 
%  all:
%     Calculate correlograms for all possible permutations of entries in
%     the list. 
%  within:
%     Calculate autocorrelograms for all entries in the list.
%  rows:
%     An extra parameter ''rows'' is required, being a 1x2 array of
%     integers. These refer to two rows between which we want to calculate
%     correlograms. This functionality is recursively used by the other
%     options. 
%   
%  Other parameters are:
%     DFRunAvgRange [100]: In calculating the Dominant Frequency (DF), a
%                          spectrum is calculated. Before calculating the
%                          DF, the spectrum is smoothed over the given
%                          range. It is given in Hz. 
%
% Example:
%  CLR = calcCorr(CLO, 'calcType', 'refRow', 'refRow', refRow)

% Created by Kevin Spiritus
% Last adjusted: 2007-04-20

%% handle argins
defParams.calcType = '';
defParams.refRow = 0;
defParams.delta = 0;
defParams.rows = [0, 0];
defParams.DFRunAvgRange = 100;
defParams.DFRunAvgUnit = 'Hz';
defParams.corrType = 'dif';
defParams.DFRange = [-Inf Inf];
params = processParams(varargin, defParams);

%% calculate
switch lower(params.calcType)
    case 'refrow'
        result = calcCorrRefRow(CLO, params.refRow, 'DFRange', params.DFRange, 'DFRunAvgUnit', params.DFRunAvgUnit, 'DFRunAvgRange', params.DFRunAvgRange, 'corrType', params.corrType);
        O1 = corrListResult('CLO', CLO, 'corrLag', result.corrLag, 'corrFncs', result.corrFncs, 'corrType', result.corrType, 'calcType', 'refRow', 'refRow', params.refRow, 'THR', result.THR, 'DF', result.DF');
    case 'deltadiscern'
        result = calcCorrDeltaDiscern(CLO, 'delta', params.delta, 'DFRange', params.DFRange, 'DFRunAvgUnit', params.DFRunAvgUnit, 'DFRunAvgRange', params.DFRunAvgRange, 'corrType', params.corrType);
        O1 = corrListResult('CLO', CLO, 'corrLag', result.corrLag, 'corrFncs', result.corrFncs, 'corrType', result.corrType, 'calcType', 'deltaDiscern', 'delta', params.delta, 'THR', result.THR, 'DF', result.DF');
    case 'all'
        result = calcCorrAll(CLO, 'DFRunAvgUnit', params.DFRunAvgUnit, 'DFRange', params.DFRange, 'DFRunAvgRange', params.DFRunAvgRange, 'corrType', params.corrType);
        O1 = corrListResult('CLO', CLO, 'corrLag', result.corrLag, 'corrFncs', result.corrFncs, 'corrType', result.corrType, 'calcType', 'All', 'THR', result.THR, 'DF', result.DF);
    case 'within'
        result = calcCorrWithin(CLO, 'DFRunAvgUnit', params.DFRunAvgUnit, 'DFRange', params.DFRange, 'DFRunAvgRange', params.DFRunAvgRange, 'corrType', params.corrType);
        O1 = corrListResult('CLO', CLO, 'corrLag', result.corrLag, 'corrFncs', result.corrFncs, 'corrType', result.corrType, 'calcType', 'Within', 'THR', result.THR, 'DF', result.DF);
    case 'rows'
        if ~isequal( [0 0], mod(params.rows, 1) ) | any(params.rows <= 0) %#ok<OR2> %row numbers should be wholes, and > 0
            errorArgFormat;
        end

        corrFncs = deal(zeros(1, length(CLO.props.lag)));
        if isequal(params.rows(1), params.rows(2))
            [corrFncs(:), corrType] = calcAutoCorr(CLO, params.rows(1), 'corrType', params.corrType);
        else
            [corrFncs(:), corrType] = calcCrossCorr(CLO, params.rows, 'corrType', params.corrType);
        end

        O1 = corrFncs;
        O2 = corrType;
    otherwise
        error('unknown calctype');
end