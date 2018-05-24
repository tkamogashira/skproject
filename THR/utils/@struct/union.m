function [U, D] = union(S,T, flag);
% struct/union - union for structs
%   union(S,T) is a struct with fields combined from S and T. If S and T
%   have any fieldnames in common, the values of T take precedence.
%
%   [U, D] = union(S,T) also returns any common fieldnames in cell
%   array of strings D.
%
%   See also struct/intersect combinestruct

% XXX handle arrays.

if nargin<3, flag=''; end

U = S;
FS = fieldnames(S);
FT = fieldnames(T);
icommon = ismember(FS,FT);
D = FS(icommon);
for ii=1:length(FT),
    fn = FT{ii};
    U(1).(fn) = T.(fn);
end



