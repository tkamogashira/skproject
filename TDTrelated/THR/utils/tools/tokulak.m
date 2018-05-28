function toKulak(FN);
% toKulak - copy EARLY mfile to Kulak

if ~isequal('SIUT', compuname) && ~isequal('CLUST', compuname) && ~isequal('Ee1285a', compuname),
    error('Tokulak only works at SIUT/CLUST');
end
qq = which(FN,'-all');
if isempty(qq),
    error(['mfile''' FN ''' not found.' ])
end
if numel(qq)>1, error(['Multiple mfiles named ' FN '.']); end
FN = qq{1};
[DD FF] = fileparts(FN);
[DD1, DD2] = strtok(DD,'EARLY');
DestDir = fullfile('K:\', DD2);
if ~exist(DestDir,'dir'), 
    error(['Destination dir ''' DestDir ''' does not exist.']);
end
copyfile(FN,DestDir);


