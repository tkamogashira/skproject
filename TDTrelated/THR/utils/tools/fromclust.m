function fromClust(FN);
% fromClust - copy EARLY mfile from CLUST 

if ~isequal('SIUT', compuname) && ~isequal('ORECCHIO', compuname) && ~isequal('Ee1285a', compuname),
    error('FromClust only works at SIUT, ORECCHIO and Ee1285a');
end
qq = which(FN,'-all');
if isempty(qq),
    error(['mfile''' FN ''' not found.' ])
end
if numel(qq)>1, error(['Multiple mfiles named ' FN '.']); end
FN = qq{1};
[DestDir FF EXT] = fileparts(FN);
% find corresponding dir at YXO
[DD1, DD2] = strtok(DestDir,'EARLY');
SrcDir = fullfile('\\Clust\MatlabProgs$\', DD2);
Src = fullfile(SrcDir, [FF EXT])

if ~exist(Src,'file'), 
    error(['Source file ''' Src ''' does not exist.']);
end
copyfile(Src,DestDir);


