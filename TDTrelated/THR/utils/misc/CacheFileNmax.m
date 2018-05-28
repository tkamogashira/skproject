function Nmax = CacheFileNmax(cfn);
% CacheFileNmax - defauyt sizes of cache files
%   CacheFileNmax('Foo') returns the default Nmax parameter for cached
%   'Foo' data.
%
%   See also FromCacheFile, ToCacheFile.

N.spiketimes = 1000;


Nmax = N.(lower(cfn));







