function index = storeSamples(x, dest);

if nargin<1, index=0; return; end;
if nargin<2, dest = 'MatLab'; end;
if strcmp(dest,'AP2'), 
   index=ML2DAMA(x); 
elseif  strcmp(dest,'MatLab'), 
   index = -ToSampleLib(x); 
elseif  strcmp(dest,'nowhere'), 
   index = 0;
else, error(['unknown destination ' char(dest)])   ;
end;
