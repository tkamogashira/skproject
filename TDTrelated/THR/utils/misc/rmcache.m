function rmcache(cfn);
% rmcache - remove cache file(s)
%    rmcache('Foo') removes all cache files stored under the name Foo.
%    The cache filename may be a full filename, but if it is
%    not complete, a default Dir (tempdir) and extension ('.ncache') is
%    provided.
%
%   rmcache('Foo*') removes all cache files whose name start with Foo.
%
%   See also getcache, putcache.

[dum, CFN]= matchcache(cfn);
delete(CFN);

delete(strrep(CFN, cfn, [cfn '_Data*']));










