function DSSName = extractDSSVName(VName)

%B. Van de Sande 07-08-2003

idx = findstr(VName, '#');
if ~isempty(idx),
    switch upper(VName(idx+1:end))
    case 'M', DSSName = 'master';
    case 'S', DSSName = 'slave'; 
    otherwise, DSSName = '??'; end
else DSSName = 'master'; end    
