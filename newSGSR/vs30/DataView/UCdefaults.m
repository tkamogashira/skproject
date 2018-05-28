function p = ucDefaults(UCxxx, params);
% ucDefaults - retrieve or save defaults for UCxxx analysis
%   P = ucDefaults('UCCYC') returns the current default values 
%   of the UCCYC analysis parameters in a struct variable.
%
%   ucDefaults('UCCYC', P) sets the default parameter values of the 
%   UCCYC analysis to the values stored in struct P.
%
%   See also UCrate.

CacheFileName = [databrowsedir '\DataPlotCacheFile']; % cache file for params
CachePar = UCxxx; % determinant of cache entry
factoryDefaults = eval([UCxxx '(''factory'');']);

if (nargin<2) & (nargout>0), %query
   p = FromCacheFile(CacheFileName, CachePar);
   % don't mess with default wrap freq stuff
   if isfield(p, 'FcycType'), p.FcycType = factoryDefaults.FcycType; end
   if isfield(p, 'Chan'), p.Chan = factoryDefaults.Chan; end
   % make sure all compulsary fields are there
   p = combinestruct(factoryDefaults, p); % % p has priority
else, % save
   % remove invalid fields
   fparam = eval([UCxxx '(''factory'');']);
   illegals = setdiff(fieldnames(params), fieldnames(factoryDefaults));
   if ~isempty(illegals),
      params = rmfield(params, illegals);
   end
   % save
   Tocachefile(CacheFileName, -200, CachePar, params);
end
 




%



