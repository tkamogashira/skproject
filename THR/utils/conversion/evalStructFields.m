function S = evalStructFields(S, X);
% evalStructFields - evaluate the fields of a struct
%   S = evalStructFields(S) tries to evaluate the fields of S
%   Example:   struct('sum', '2+3') becomes struct('sum', 5) 
%   Evaluation is done in caller workspace.
%   Unevaluatable fields are left alone.
%
%   S = evalStructFields(S, X) excludes the fields listed 
%   in cellstring X from evaluation. 
%   The fieldnames in X are case-INsensitive.
%
%   See also VariedParam.

if nargin<2, X={}; end;
X = lower(X); % case insensitive handling of exclude list
FNS = fieldnames(S);
for ii=1:length(FNS),
   fn = FNS{ii};
   fv = getfield(S, fn);
   try, 
      if isempty(strmatch(lower(fn), X, 'exact')),
         fv = evalin('caller', fv);
         S = setfield(S, fn, fv);
      end
   end
end





