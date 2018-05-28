function [data, ipos] = FromCacheFile(CFN, pars)
% FromCacheFile - retrieve data from cache file
%   Syntax: data = FromCachFile(CFN, param)
%
%   See also ToCacheFile
data = []; ipos = [];

if isempty(CFN), return; end;

CFN = FullFileName(CFN, tempdir, 'cache');

if ~exist(CFN,'file'),
   return;
end

pID = char(0:3:44);
DD = load(CFN, '-mat');
ii = DD.N+1;
for jj=1:length(DD.Pars),
   ii = ii-1; % reverse search -> hit most recently stored data first
   if ii==0, ii=length(DD.Pars); end;
   if isequal(DD.Pars{ii}, pars), % hit
      data = DD.Data{ii};
      ipos = -ii; % cache-file position where data were found (neg = direct storage)
      try, % look for indirect storage
         if ischar(data) & isequal(1,findstr(pID, data)),
            dfn = data(length(pID)+1:end); % filename where data are stored
            load(dfn,'-mat');
            ipos = ii; % cache-file position where data were found (npo = indirect storage)
         end
      catch
         disp(lasterr)
      end
      return;
   end
end
