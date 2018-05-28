function ps = PackInStructStr(varNameList, excludeList);
% PackInStructStr - command that packes variables in a struct
%    PackInStructStr(varNameList) returns a char string containing
%    a command which, when evoked, packs the variables listed
%    by name into a struct.
%    For instance, S=PackInStructStr({'A' 'B'}) returns the string S:
%
%           'CollectInstruct(A,B);' 
%
%    When EVAL is invoked in the workspace where the variables 
%    A and B live:
%
%            X = eval(PackInStructStr({'A' 'B'}));
%
%    The result is a struct X with fields A and B having the values
%    of A and B. In particular, the command:
%
%            X = eval(PackInStructStr(who));
%
%    returns a struct X in which *all* variables in the caller workspace 
%    are collected.
%
%    X = PackInStructStr(varNameList, Excl), where Excl is a char string or
%    cell array of strings, exludes the variables whos names are in Excl
%    from the struct X.
%
%    See also CollectInStruct.

% make sure excludeList exists and is a cell array
if nargin<2, excludeList = {}; 
elseif ischar(excludeList), excludeList = cellstr(excludeList);
elseif iscellstr(excludeList), % nothing wrong with that
else, error('ExcludeList must be char string or cell array of strings.');
end
% remove members of exclude list from varNameList
ixcl = []; % exclude indices sofar
for ii=1:length(excludeList), % collect exclude  indices
   ixcl = [ixcl; strmatch(excludeList{ii},{varNameList{:}},'exact')];
end
iincl = setdiff(1:length(varNameList), ixcl); % INclude indices
varNameList = {varNameList{iincl}}; % reduced varNameList

% build the command
ps = 'CollectInStruct(';
for iname=1:length(varNameList),
   if iname>1, ps = [ps ', ']; end;
   ps = [ps varNameList{iname}];
end
ps = [ps ');'];



