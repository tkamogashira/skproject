function result = isEquallySpaced(rowVector, precision)
% EQUALLYSPACED Checks if a given vector is equally spaced
%
% result = isEquallySpaced(rowVector, precision)
%  Checks if the elements of rowVector are equally spaced. Returns 1 or 0.
%  Precision indicates how many digits after the dot the function has to
%  check. Standard is 10.

%% check arguments
%nargin ok?
if isequal(1, nargin)
    precision = 10;
elseif ~isequal(2, nargin)
    error('Function arguments in wrong format.');
end

%rowVector ok?
if ~isequal(2, ndims(rowVector)) | ~isequal(1, size(rowVector, 1))  | size(rowVector, 2) < 2 %#ok<OR2> (ML6 compat)
    error('Function arguments in wrong format.');
end
if ~isnumeric(rowVector) | ~isScalar(precision)
    error('Function arguments in wrong format.');
end

%% check spacing
D = diff(rowVector);
D = round(D* 10^precision) / 10^precision;

result = isequal( ones(1, length(D)), D/D(1) );