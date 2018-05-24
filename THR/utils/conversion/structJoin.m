function S = structJoin(S,T,varargin);
% structJoin - combine struct vars into a single struct
%   structJoin(S,T) is a struct that combines the fields of S and T
%   In case of coinciding fieldnames, the values of T prevail.
%
%   structJoin(S,T, U,..) joins multiple structs. Rightmost fieldnames prevail.
%
%   structjoin(S,'-', T) adds separator field with lots of underscores.
%
%   structjoin(S,'-Foo', T) adds separator named Foo________________ having
%   value '____________________'.
%
%   See also struct/union, CombineStruct, structmerge.

if isempty(S), S=T; return; end
if isempty(T), return; end
if isequal('-',S),
    S = struct(local_sep, '____________________');
elseif ischar(S) && isequal('-', S(1)),
    S = struct(local_sep(S(2:end)), '____________________');
end
if isequal('-',T),
    T = struct(local_sep, '____________________');
elseif ischar(T) && isequal('-', T(1)),
    T = struct(local_sep(T(2:end)), '____________________');
end
if ~isstruct(S) || ~isstruct(T),
    error('arguments of structJoin must be structs.');
end

if nargin>2, % recursion
    S = structJoin(structJoin(S,T), varargin{:});
    return;
end

if numel(S)>1,
    oldS = S;
    clear S;
    Nt = numel(T);
    for ii=1:numel(oldS),
        S(ii) = structJoin(oldS(ii), T(min(ii,Nt)));
    end
    return;
end

% singe struct from here

fns = fieldnames(T);
for ii=1:length(fns),
    fn = fns{ii};
    eval(['S.' fn ' = T.' fn ';']);
end


function s = local_sep(Title);
if nargin<1, % random title
    s = ['x' num2str(randomint(1e4)) 'x_______________'];
else,
    s = [Title '________________'];
end







