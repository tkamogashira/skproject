function EmptyCacheFile(CFN, doWarn);
% EmptyCacheFile - remove cached data
%    DEPRICATED! use rmcache instead.
%
%   EmptyCacheFile('Foo') removes the cache file Foo.
%   A warning results if Foo is not an existing cache file.
% 
%   EmptyCacheFile('Foo', 1) suppresses the warning.
%
%   Use of wildcard '*' as last character the cache file name is allowed.
%   E.g., EmptyCacheFile('Foo*') removes all caches whose names start with Foo.
%
%   See also FromCacheFile, ToCacheFile

if nargin<2, doWarn=1; end

if isempty(CFN), return; end;

%---check for use of wildcard to remove all caches. Use recursion if needed.---
if strcmpi(CFN(end),'*'),
    CCFN = CFN(1:end-1); %"strip" wildcard off
    wildcard = '*';
    CFN = FullFileName([CCFN wildcard], tempdir, 'cache'); %expand name
    LL = dir(CFN); %find all cache-related files
    LL = {LL.name};
    indx = [];
    for ii = 1:numel(LL), %loop over all names, remove those with '__'
        if ~isempty(strfind(LL{ii},'__')), indx = [indx ii]; end
    end
    LL(indx) = [];
    if isempty(LL), LL = {CCFN}; end
    for ii = 1:numel(LL), %recursive call to EmptyCacheFile
        [dum, Lname] = fileparts(LL{ii});
        EmptyCacheFile(Lname,doWarn);
    end
    return
end

%---individual caches from here---
DFN = FullFileName([CFN '__*'], tempdir, 'cache');
CFN = FullFileName(CFN, tempdir, 'cache');

if exist(CFN,'file'),
   delete(CFN);
   delete(DFN);
elseif doWarn, 
   warning(['File ''' CFN ''' not found']);
end

