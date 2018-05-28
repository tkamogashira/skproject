function StimType = GetStimType(DataFile, dsID, DirInfo)
%GETSTIMTYPE    gets stimulus type for specific dsID
%   StimType = GETSTIMTYPE(DataFile, dsID, DirInfo)

index = findstr(dsID, '-');
if length(index) ~= 1, StimType = []; return; end
CellNr = str2num(dsID(1:index(1)-1));
TestNr = str2num(dsID(index(1)+1:end));

SParam = CollectInStruct(DataFile, CellNr, TestNr);
Data   = FromCacheFile(DirInfo.TableFile, SParam);
if isempty(Data), StimType = []; return; end
StimType = Data.StimType;