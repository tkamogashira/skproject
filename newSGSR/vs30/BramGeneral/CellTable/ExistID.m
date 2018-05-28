function Err = ExistID(DataFile, dsID, StimType, DirInfo)
%EXISTID    checks if dataset ID exist in DataFile and this dsID has the specified Stimulus Type.
%   Err = EXISTID(DataFile, dsID, StimType, DirInfo)

Err = 0;

%Legende Error-codes:
% 1 : Dataset ID bestaat niet
% 2 : dsID bevat geen respons op opgegeven Stimulus Type

index = findstr(dsID, '-');
if length(index) ~= 1, Err = 1; return; end

CellNr = str2num(dsID(1:index(1)-1));
TestNr = str2num(dsID(index(1)+1:end));

SParam = CollectInStruct(DataFile, CellNr, TestNr);
Data   = FromCacheFile(DirInfo.TableFile, SParam);
if isempty(Data), Err = 1; return; end
if ~strcmp(Data.StimType, StimType), Err = 2; return; end
