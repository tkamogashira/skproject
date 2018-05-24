function S = comstruct(S1, S2)
%COMSTRUCT  combine structures
%   S = COMSTRUCT(S1, S2) combines structures S1 and S2, so that all fields of S1 that are present in S2, have
%   the value of the respective fields in S2.
%   Attention! All fields of S2 should exist in S1.

%B. Van de Sande 23-3-2003

if (nargin ~= 2), error('Wrong number of input parameters.'); end
if ~isa(S1, 'struct') | ~isa(S2, 'struct'), error('Arguments should be structures.'); end

sizS1 = size(S1);
sizS2 = size(S2);
if any(sizS1 ~= sizS2) %Potential dimension mismatch
    if (min(sizS1) == 1) & (min(sizS2) == 1)
        S1 = reshape(S1, 1, prod(sizS1));
        S2 = reshape(S2, 1, prod(sizS2));
    else, error('Structures must have same dimensions.'); end    
end    

Args = repmat({':'}, 1, ndims(S1));

F = fieldnames(S1);
C = struct2cell(S1);

F2 = fieldnames(S2);
C2 = struct2cell(S2);

if ~all(ismember(F2, F)), error('All fields of second structure should be present in the first.'); end

for n = 1:length(F2)
    idx = find(ismember(F, F2(n)));
    C(idx, Args{:}) = C2(n, Args{:});
end

S = cell2struct(C, F);
