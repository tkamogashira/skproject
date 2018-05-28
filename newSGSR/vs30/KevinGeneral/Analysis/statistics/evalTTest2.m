function [H, P] = evalTTest2(varargin)
% evalTTest2 - Evaluate a TTest2 on a structure array
%
%    Uses:
%      1. >> [H, P] = evalTTest2(struct S, string columnNameS1, string columnNameS2)
%      2. >> [H, P] = evalTTest2(struct S, string columnNameS, struct T, string columnNameT)
%
%    Both uses do a TTest on the specified columns of the structures. H and
%    P values are returned. See 'help ttest2' for more information on these
%    values.

switch nargin
    case 3
        xStruct = varargin{1};
        yStruct = xStruct;
        xColumnName = varargin{2};
        yColumnName = varargin{3};
    case 4
        xStruct = varargin{1};
        yStruct = varargin{3};
        xColumnName = varargin{2};
        yColumnName = varargin{4};
    otherwise
        error('evalTTest2 expects 3 or 4 arguments.');
end

if ~isstruct(xStruct) || ~isstruct(yStruct)
    error('Structures should be of type struct.');
end

if ~ischar(xColumnName) || ~ischar(yColumnName)
    error('Column names should be strings.');
end
        
xColumn = retrieveField(xStruct, xColumnName);
yColumn = retrieveField(yStruct, yColumnName);

[H, P] = ttest2(xColumn, yColumn);
