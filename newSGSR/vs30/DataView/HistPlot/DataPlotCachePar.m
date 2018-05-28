function CachePar = DataPlotCachePar(ds, params);
% DataPlotCachePar - unique determinant of cache entry within a cache file

isub = params.iSub;
% no distinction between showallrecorded, 'up' and 'down' modes
if ischar(isub), isub = 0; end; CachePar = {ds.iseq isub}; 
