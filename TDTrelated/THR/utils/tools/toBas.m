function toBas(FN);
% toBas - copy EARLY mfile to YXO

if ~isequal('KULAK', compuname) && ~isequal('SIUT', compuname) && ~isequal('CLUST', compuname) ,
    error('Tobas only works at KULAK/SIUT/CLUST');
end
qq = which(FN,'-all');
if isempty(qq),
    error(['mfile''' FN ''' not found.' ])
end
if numel(qq)>1, error(['Multiple mfiles named ' FN '.']); end
FN = qq{1};
[DD FF] = fileparts(FN);
[DD1, DD2] = strtok(DD,'EARLY');
DestDir = fullfile('P:\', DD2);
if ~exist(DestDir,'dir'), 
    error(['Destination dir ''' DestDir ''' does not exist.']);
end
copyfile(FN,DestDir);


