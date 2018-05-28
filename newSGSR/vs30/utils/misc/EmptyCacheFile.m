function EmptyCacheFile(CFN, doWarn);
% EmptyCacheFile - remove cached data
%   Syntax: EmptyCacheFile(CFN, doWarn)
%      doWarn defaults to 1.
% 
%   See also FromCacheFile, ToCacheFile

if nargin<2, doWarn=1; end

if isempty(CFN), return; end;

DFN = FullFileName([CFN '__*'], tempdir, 'cache');
CFN = FullFileName(CFN, tempdir, 'cache');

if exist(CFN,'file'),
   delete(CFN);
   delete(DFN);
elseif doWarn, 
   warning(['File ''' CFN ''' not found']);
end

