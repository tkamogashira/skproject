function boolean = compfields(S1, S2)
%COMPFIELDS compare fieldnames of two structures
%   COMPFIELDS(S1, S2)

%B. Van de Sande 27-03-2003

if nargin ~= 2, error('Wrong number of input arguments.'); end 
if ~isa(S1, 'struct') | ~isa(S2, 'struct'), error('Both input arguments should be structures.'); end

if isequal(fieldnames(S1), fieldnames(S2)), boolean = logical(1);
else, boolean = logical(0); end
     
