function [D, cfn, Param] = getcache(cfn, Param);
% getcache - retrieve cached stuff
%    Data=getcache('Foo', Param) retrieves Data previously stored in cache 
%    file Foo. Param must match the stored value (see putcache). If no
%    matching Data are found, [] is returned.
%    
%    The cache filename may be a full filename, but if it is
%    not complete, a default Dir (tempdir) and extension ('.ncache') is
%    provided.
%
%    [Data, CFN, CP] = getcache('Foo', Param) also returns the cache file
%    name CFN ('Foo" in this example) and cache parameters CP=Param.
%
%    See also putcache, rmcache.

D = []; % default: no match found
% check if Param was used before
[ihit, CFN, ParamList]=matchcache(cfn, Param);

if ~isempty(ihit),
    p = ParamList(ihit);
    if p.inseparatefile, % get that file
        [DDir] = fileparts(CFN);
        Dfile = fullfile(DDir, p.filename);
    else, % same file 
        Dfile = CFN;
    end
    if exist(Dfile,'file'), % cache satelite may have disappeared
        D = load(Dfile, p.datavar, '-mat');
        D = D.(p.datavar);
    end
end








