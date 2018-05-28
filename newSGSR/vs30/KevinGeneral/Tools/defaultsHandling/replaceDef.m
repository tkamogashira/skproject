function result = replaceDef(propertyValue, defValue)
% REPLACEDEF replaces 'def' values by their default value
%
% replaceDef(property, defValue)
% Property can be multidimensional; two dimensional arrays and cell arrays 
% are supported.
%
% Example:
%   >> propertyValue = {5 4 3;'def' 7 'def'}
%   propertyValue = 
%       [  5]    [4]    [  3]
%       'def'    [7]    'def'
%   >> defValue = 100;
%   >> replaceDef(propertyValue, defValue)
%   ans = 
%       [  5]    [4]    [  3]
%       [100]    [7]    [100]

% Created by: Kevin Spiritus
% Last edited: December 11th, 2006

switch class( propertyValue )
    case 'char'
        if isequal('def', propertyValue)
            propertyValue = defValue;
        end
    case 'cell'
        for rowCounter = 1:size(propertyValue , 1)
            for colCounter = 1:size(propertyValue , 2)
                % if 'def' value, replace by default value
                if isequal('def', propertyValue{rowCounter, colCounter})
                    propertyValue{rowCounter, colCounter} = defValue;
                end
            end
        end
    case 'double'
        for rowCounter = 1:size(propertyValue , 1)
            for colCounter = 1:size(propertyValue , 2)
                % if 'def' value, replace by default value
                if isequal('def', propertyValue(rowCounter, colCounter))
                    propertyValue(rowCounter, colCounter) = defValue;
                end
            end
        end
    otherwise
        error(['Class ''' class(propertyValue) ''' is not supported by this function.']);
end
result = propertyValue;