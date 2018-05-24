function explore(FN);
% explore - open explorer in folder where given file resides
%   explore Foo opens Windows Explorer in the folder where Foo is located.
%
%   See also WHICH, WINOPEN.

qq = which(FN, '-all');
if isempty(qq),
    error(['File ''' FN ''' not found in path.']);
end
if numel(qq)>1,
    warning(['Multiple instances of file ''' FN ''' found.']);
end

[DD Nam] = fileparts(qq{1});
winopen(DD);



