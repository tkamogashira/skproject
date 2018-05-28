function [data, ipos] = FromCacheFile(CFN, pars)
% FromCacheFile - retrieve data from cache file
%    DEPRICATED! use getcache instead.
%
%    FromCacheFile(CFN, Param) returns data from cachefile CFN that are
%    uniquely determined by value Param. If no matching cached data are
%    found, [] is returned. 
%    
%    CFN need not be full filename: default directory is tempdir; default
%    extension is 'cache'. See ToCacheFile for an example.
%
%    See also ToCacheFile.

data = []; ipos = [];

if isempty(CFN), return; end;

CFN = FullFileName(CFN, tempdir, 'cache');
[CacheDir, dum] = fileparts(CFN);

if ~exist(CFN,'file'),
   return;
end

pID = char(0:3:44);
DD = load(CFN, '-mat');
ii = DD.N+1;
for jj=1:length(DD.Pars),
   ii = ii-1; % reverse search -> hit most recently stored data first
   if ii==0, ii=length(DD.Pars); end;
   if isequalwithequalnans(DD.Pars{ii}, pars), % hit
      data = DD.Data{ii};
      ipos = -ii; % cache-file position where data were found (neg = direct storage)
      try, % look for indirect storage
         if ischar(data) & isequal(1,findstr(pID, data)),
            dfn = data(length(pID)+1:end); % filename where data are stored
            % force to look in the same dir as CFN
            [dum dfn extension] = fileparts(dfn);
            dfn = fullfile(CacheDir, [dfn extension]);
            load(dfn,'-mat');
            ipos = ii; % cache-file position where data were found (npo = indirect storage)
         end
      catch
         disp(lasterr)
      end
      return;
   end
end
