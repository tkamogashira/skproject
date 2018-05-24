function S = methodsHelp(A,M);
% methodsHelp - display help onliners for all methods for object
%    methodsHelp(A) or methodsHelp('Class') produces a list of methods for
%    object A or class 'Class'. For each method, the one-line help text is
%    displayed.
%
%    S = methodsHelp(A) returns the information in struct S.
%
%    S = methodsHelp(A, {'Foo' 'Goo' ..}) only returns the help on methods
%    named Foo, Goo, .. .
%
%    See also methodsdirs, methods.

M = methods(A);

if ~ischar(A), A = class(A); end

for ii=1:length(M),
    m = [A '/' M{ii}];
    fn=which(m);
    if ~isempty(fn),
        S.(M{ii}) = oneliner(m);
    end
end


