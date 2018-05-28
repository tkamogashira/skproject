function D = getleave(S, varargin)
%GETLEAVE get field from structure-array
%   D = GETLEAVE(S, FN, ...) gets fieldname FN from structure-array S for all elements. Multiple fields can be 
%   retrieved at once. Fields of branched structure-arrays can be requested using a dot as fieldname separator.

%B. Van de Sande 07-07-2003

if (nargin < 2)
    error('Wrong number of input parameters.'); 
end
if ~isstruct(S)
    error('First argument should be structure-array.'); 
end
if ~iscellstr(varargin)
    error('Additional arguments should be names of fields to retrieve from structure-array.'); 
end

[C, F] = destruct(S);
if ~all(ismember(varargin, F))
    error('One of the requested fieldnames doesn''t exist.'); 
end

idx = find(ismember(F, varargin));
D = C(:, idx);

if size(D, 2) == 1 & isa(D{1}, 'double')
    D = cat(1, D{:}); 
end