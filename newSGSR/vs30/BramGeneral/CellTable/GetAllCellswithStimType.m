function CellList = GetAllCellswithStimType(DataFile, StimType, DirInfo)
%GETALLCELLSWITHSTIMTYPE    gets all dsIDs within datafile which have the specified stimulus type.
%   CellList = GETALLCELLSWITHSTIMTYPE(DataFile, StimType, DirInfo)

CellList = cell(0);

load(DirInfo.TableFile, 'N', '-mat');
load(DirInfo.TableFile, 'Pars', '-mat'); SParam = Pars;
load(DirInfo.TableFile, 'Data', '-mat');

for i = 1:N
    if strcmp(SParam{i}.DataFile, DataFile)      & ...
       strcmp(upper(Data{i}.StimType), StimType)     
        dsID = [int2str(SParam{i}.CellNr) '-' int2str(SParam{i}.TestNr)];
        CellList = cat(1,CellList(:), {dsID});
    end    
end

