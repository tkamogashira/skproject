function fromBas(FN);
% toBas - copy EARLY mfile from YXO 

if ~isequal('KULAK', compuname),
    error('Frombas only works at KULAK');
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
SrcDir = fullfile('P:\', DD2);
Src = fullfile(SrcDir, [FF EXT])

if ~exist(Src,'file'), 
    error(['Source file ''' Src ''' does not exist.']);
end
copyfile(Src,DestDir);


