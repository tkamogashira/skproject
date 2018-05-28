function [X, Y] = applyXRange(X, Y, xRange)
% APPLYXRANGE Apply a certain range to an X,Y pair.
%
% [X, Y] = applyXRange(X, Y, xRange)
%
% Arguments: 
%   X and Y: equal length vectors
%   xRange: a 2x1 vector, indicating the range to select
%
% Returns:
%   Returns equal length vectors X and Y; only those X-values in the given
%   xRange are returned though.  For the Y-values, the respective elements
%   are taken.

if ~isnumeric(X) | ~isnumeric(Y)
    error('Wrong format of arguments');
end
if ~isequal(size(X), size(Y)) | ~isequal(1, size(X,1)) | size(X,2) < 1 
    error('Wrong format of arguments');
end
if ~isequal([1,2], size(xRange)) | ~isnumeric(xRange)
    error('Wrong format of arguments');
end

xRangeOK = ( X >= xRange(1) )  &  ( X <= xRange(2) );
X = X( xRangeOK );
Y = Y( xRangeOK );