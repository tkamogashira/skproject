function X = tocol( X )
%
% TOCOL Converts a vector or a matrix into a column vector.
%   If input is already a column vector, it is returned with no change.
%   If input is a row vector, it is converted into a column vector and
%   returned.
%   If input is a matrix, each row is converted into a column, and all
%   resulting columns are placed in series into a single column which is
%   returned.
%
% Input:
%   X - input vector or matrix
%
% Output:
%   X - column vector
%
% Examples:
%   tocol([ 0 1 2 3 ])
%       returns [ 0 1 2 3 ]'
%   tocol([ 0 1 2 3 ]')
%       returns [ 0 1 2 3 ]'
%   tocol([ 0 1; 2 3 ])
%       returns [ 0 1 2 3 ]'
%   tocol([ 0 1; 2 3 ]')
%       returns [ 0 2 1 3 ]'
%
% Author:	Tashi Ravach
% Version:	1.0
% Date:     07/07/2010
%

%% ---------------- CHANGELOG -----------------------
%  Wed May 18 2011  Abel
%   - added struct support

%by Abel:
%Loop over leaves if input is a struct
if isa(X, 'struct')
	fieldNames = fieldnames(X);
	for n=1:length(fieldNames)
		X.(fieldNames{n}) = tocol(X.(fieldNames{n}));
	end
	return;
end


% check if input is a vector
[ m, n ] = size(X);
if m*n==m
	return % input is already a column vector with n rows
elseif m*n==n
	X = X'; % input is converted from row vector to column vector
elseif (m*n>n) || (m*n>m)
	X = X';
	X = X(:); % input is converted from matrix to column vector by row
else
	X = []; % input is unknown and an empty output is returned
end

end
