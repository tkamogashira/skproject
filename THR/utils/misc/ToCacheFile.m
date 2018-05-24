function ToCacheFile(cfn, Imax, pars, data);
% ToCacheFile - store data in cache file
%    DEPRICATED! use putcache instead.
%
%   ToCacheFile(CFN, Nmax, param, Data) caches Data.
%
%   Input args:
%     CFN:   cache file (default dir: tempdir, def ext .cache)
%     Nmax:  max number of data stored (-N means single file, max N entries)
%            if Nmax is exceeded, the oldest entries are overwritten (FIFO)
%     param: struct that uniquely identifies the data.
%     Data: data to be stored
%
%   EXAMPLE
%     D = NumberCrunch(X,Y); % some time consuming computation
%     cacheParams =  collectInStruct(X,Y);  X & Y uniquely determine outcome D
%     ToCacheFile('Foo', 128, cacheParams, D); % store the data - maximum of 128
%     % ---some other time---
%     X = ...; Y = ...; cacheParams =  collectInStruct(X,Y);
%     D = fromCacheFile('Foo', cacheParams); % look if same has been calculated before
%     if isempty(D), ... % only compute again if not in cache
%     
% 
%   See also FromCacheFile, CacheFileNmax.

if isempty(cfn), return; end;
% first check if data with the same pars are present, if so, substitute
[dum, ipos] = fromCacheFile(cfn, pars); % not found -> ipos will be empty

CFN = FullFileName(cfn, tempdir, 'cache');
DFN = @(N)FullFileName([cfn '___' num2str(N)], tempdir, 'cache'); % real data in separate file

DirectStorage = (Imax<0); 
Imax = abs(Imax);

if ~exist(CFN,'file'), % initialize
   N = 1;
   Pars = {1};
   Data = {[]};
else,
   DD = load(CFN, '-mat');
   conflict = 0;
   try, conflict =~isequal(DirectStorage, DD.DirectStorage); end
   if conflict,
      warning('Conflicting storage type of cache file'); 
      emptycachefile(CFN);
      ToCacheFile(cfn, Imax, pars, data);
      return;
   end;
   if ~isempty(ipos), % write to same position as earlier found data
      N = abs(ipos);
   else, % next pos; wrap if exceeds maxpos
      N = DD.N + 1;
      if N>Imax, N = 1; end;
   end
   Pars = DD.Pars;
   Data = DD.Data;
end

Pars{N} = pars;
if DirectStorage,
   Data{N} = data;
else, % store datafile name
   save(DFN(N), 'data');
   Data{N} = [char(0:3:44) DFN(N)];
end
save(CFN, 'DirectStorage', 'N', 'Pars', 'Data');






