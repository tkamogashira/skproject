function Sn = NthElemOfStruct(n,S);
% NthElemOfStruct - returns struct containing nth elements fo fields of struct
% SYNTAX
% Sn = NthElemOfStruct(n,S);
% e.g. S.a = 1; S.b = [1 2 3]; 
% NthElemOfStruct(2,S)
% ans =
%  a:   1
%  b:   2

if ~isstruct(S),
   error('non-struct input arg');
end
FNS = fieldnames(S);
Sn = [];
for ii=1:length(FNS),
   fn = FNS{ii};
   Fval = (getfield(S,fn));
   L = length(Fval);
   Fval = Fval(min(L,n)); % extract nth value unless there's only a single one
   Sn = setfield(Sn,fn,Fval);
end
