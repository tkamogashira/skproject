function ErrorOnNewRelease(R)
% ErrorOnNewRelease - throw error on newer MatLab release
%   ErrorOnNewRelease(R) throws an error when the release
%   is not equal to R. R defaults to '12.1'.
%   Useful for manual fixes of MatLab bugs.

if nargin<1, R = '12.1'; end

if ~isequal(R, version('-release')), 
   error('New MatLab version - Check inversion bug in overloaded vector.field syntax.'); 
end

