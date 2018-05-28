function ToCacheFile(cfn, Imax, pars, data);
% ToCacheFile - store data in cache file
%   Syntax: ToCacheFile(CFN, Nmax, param, data);
%   where:
%     CFN is cache file (default dir: tempdir, def ext .cache)
%     Nmax is max number of data stored [Nmax<0 -> direct storage]
%     param: struct that uniquely identifies the data
%     data: data to be stored
% 
%   See also FromCacheFile

if isempty(cfn), return; end;
% first check if data with the same pars are present, if so, substitute
[dum, ipos] = FromCacheFile(cfn, pars); % not found -> ipos will be empty

CFN = FullFileName(cfn, tempdir, 'cache');
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
   DFN = FullFileName([cfn '___' num2str(N)], tempdir, 'cache'); % real data in separate file
   save(DFN, 'data');
   Data{N} = [char(0:3:44) DFN];
end
save(CFN, 'DirectStorage', 'N', 'Pars', 'Data');





