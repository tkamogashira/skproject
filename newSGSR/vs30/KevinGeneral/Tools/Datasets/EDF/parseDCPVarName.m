function [VarName, DSSName] = parseDCPVarName(DCPName)

%B. Van de Sande 02-10-2003

idx = findstr(DCPName, '#');
if ~isempty(idx),
    switch upper(DCPName(idx+1:end))
    case 'M', DSSName = 'master';
    case 'S', DSSName = 'slave'; 
    otherwise, DSSName = '??'; end
    VarName = DCPName(1:idx-1);
else 
    DSSName = 'master'; 
    VarName = DCPName;
end