function s = structOfStruct(s,n);
% structOfstruct - empty tree structure of struct without the values of fields.
%   structOfstruct(S) is a version of S in which all non-struct fields of S 
%   are replaced by []. This is done recursively. 
%
%   structOfstruct(S, N) descends with a maximum recursive level of N.
%   The default value is N==inf.

if nargin<2, n=inf; end;

if ~isstruct(s) | (n<1), 
   s = []; 
else, % visit fields
   FNS = fieldnames(s);
   for ii=1:length(FNS),
      fn = FNS{ii};
      f = getfield(s, fn);
      f = structOfStruct(f,n-1);
      s = setfield(s, fn, f);
   end
end