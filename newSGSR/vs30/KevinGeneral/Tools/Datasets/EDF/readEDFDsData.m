function [DsData, Err] = readEDFDsData(fid, DsLoc, SchName)

%B. Van de Sande 31-07-2003

Err = 0;
SchDir = [fileparts(which(mfilename)) '\SCHEMATA'];
FullFileName = [SchDir '\' SchName '.m'];
if exist(FullFileName, 'file')
    Foffset = (DsLoc-1)*512 + 13*4; %Location of dataset in EDF plus the length of the mandatory header ...
    fseek(fid, Foffset, 'bof');
    
    cwd = pwd;
    try
        cd(SchDir);
        DsData = eval(sprintf('%s(fid);', SchName));
        cd(cwd);
    catch
        cd(cwd);
        DsData = struct([]);
        Err = 2;
    end
else
    DsData = struct([]);
    Err = 1;
end
