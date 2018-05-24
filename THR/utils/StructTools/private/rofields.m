function S = rofields(S, Order)
%ROFIELDS reorder structure fields
%   ROFIELDS(S, Order) returns the structure S with the fieldnames reordered according to the variable
%   Order
%
%   ROFIELDS(S, 'alpha') reorders the structure S so the fieldnames appear in alphabetic order
%   ROFIELDS(S, 'reverse') reorders the structure S so the fieldnames appear in reverse alphabetic order
%
%   ROFIELS(S, idx) where idx is a permutation of the indices of the fielnames of S, reorders the structure
%   to match the order given by idx

%B. Van de Sande 27-03-2003

if nargin ~= 2, error('Wrong number of input arguments.'); end
if ~isstruct(S), error('First argument should be a structure.'); end

sizS = size(S);
C = struct2cell(S(:));

if ischar(Order)
    [FNames, idx] = sort(fieldnames(S));
    if strncmpi(Order, 'r', 1)
        idx = idx(end:-1:1);
        S = cell2struct(C(idx, :), FNames(end:-1:1), 1);
    elseif strncmpi(Order, 'a', 1)
        S = cell2struct(C(idx, :), FNames, 1);
    else, error('Unknown order.'); end    
elseif isnumeric(Order)
    FNames = fieldnames(S);
    NFields = length(FNames);
    if NFields ~= length(Order), error('Incorrect number of indices provided.'); end
    if ~isequal(1:NFields, sort(Order(:)')), error('Incorrect fieldname indices provided.'); end
    S = cell2struct(C(Order, :), FNames(Order), 1);
else, error('Unknown second argument.'); end

S = reshape(S, sizS);