function S = add2struct(S, R, idx)
%ADD2STRUCT add struct to array of structure
%   S = ADD2STRUCT(S, R, idx) adds the structure R to the structure array S at the
%   index idx.

%B. Van de Sande 24-03-2003

if nargin ~= 3, error('Wrong number of input arguments.'); end
if ~isstruct(S), error('First argument should be structure array.'); end
if ~isstruct(R) | (length(R) ~= 1), error('Second argument should be scalar structure.'); end
NElem = length(S); if idx > (NElem+1), error('Subscript out of range.'); end

temp = S(idx:NElem);
S(idx) = R;
S(idx+1:NElem+1) = temp;
